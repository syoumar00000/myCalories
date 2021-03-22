import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Calculateur de Calories'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int calorieBase;
  int calorieAvecActivite;
  int radioSelectionee;
  double poids;
  double age;
  double taille = 170.0;
  bool genre = false;
  Map mapActivite = {
    0 : 'Faible',
    1 : 'Modéré',
    2 : 'Forte'
  };

  @override
  Widget build(BuildContext context) {
    // pour afficher mon contenu de body differement selon le systeme d'exploitation(android ou iOS)
       if(Platform.isIOS) {
         print("nous sommes sur iOS");
       } else {
         print("nous  ne sommes pas  sur iOS");
       }
    return GestureDetector( //gere l'affichage du clavier numerique
      onTap: (() => FocusScope.of(context).requestFocus(new FocusNode())),//permet de fermer le clavier lors du clic sur l'ecran
       child: (Platform.isIOS)? new CupertinoPageScaffold(
         navigationBar: new CupertinoNavigationBar(
           backgroundColor: setColor(),
           middle: textAvecStyle(widget.title),//pour le titre du navbar
         ),
           child: body())
           :Scaffold(
           appBar: AppBar(
             title: Text(widget.title),
             backgroundColor: setColor(),
           ),
           body:  body(),
       ),
    );
  }
  Widget body() {
     return new SingleChildScrollView(// gere les erreurs causés par la taille de nos widgets d'ou les widgets vont scroller
       padding: EdgeInsets.all(0.0),
       child: new Column(
         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
         children: <Widget>[
           padding(),
           textAvecStyle("Veuillez remplir tout les champs pour obtenir votre besoin journalier en calorie"),
           padding(),
           new Card(
             elevation: 10.0,
             child: new Column(
               children: <Widget>[
                 padding(),
                 new Row(
                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                   children: <Widget>[
                     textAvecStyle("Femme", color: Colors.pink),
                    switchSelonPlatforme(),
                     textAvecStyle("Homme", color: Colors.blue),
                   ],
                 ),
                 padding(),
                 ageButton(),
                 padding(),
                 textAvecStyle("Votre taille et de : ${taille.toInt()} cm.", color: setColor()),
                 padding(),
                 sliderSelonPlatforme(),
                 padding(),
                textfieldSelonPlateforme(),
                 padding(),
                 textAvecStyle("Quelle est votre activité sportive ?", color: setColor()),
                 padding(),
                 rowRadio(),
                 padding(),
               ],
             ),
           ),
           padding(),
           calcButton(),
         ],
       ),
     );
  }
 // fonction qui affiche du texte avec un style propre a lui en fonction du SE
  Widget textfieldSelonPlateforme() {
    if(Platform.isIOS) {
      return  new CupertinoTextField( //affiche mon clavier numerique pour android
        keyboardType: TextInputType.number,
        onChanged: (String string){
          setState(() {
            poids = double.tryParse(string);
          });
        },
        placeholder: "Entrez Votre Poids en Kilogramme !!",
      );
    } else {
       return new TextField( //affiche mon clavier numerique pour android
        keyboardType: TextInputType.number,
        onChanged: (String string){
          setState(() {
            poids = double.tryParse(string);
          });
        },
        decoration: new InputDecoration(
          labelText: "Entrez Votre Poids en Kilogramme !!",
        ),
      );
    }
  }
  
  //fonction pour creer des espaces en utilisant padding
  Padding padding () {
    return new Padding(padding: EdgeInsets.only(top:20.0));
  }

  //fonction qui montre la date
  Future<Null> montrerPicker() async {
       DateTime choix = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(1900),
        lastDate: new DateTime.now(),
        //pour afficher mon calendrier
        initialDatePickerMode: DatePickerMode.year,
      );
      if(choix != null) {
        //difference entre la date de maintenant et la date choisie
        var difference = new DateTime.now().difference(choix);
        var jours = difference.inDays;
        var ans = (jours / 365);
        setState(() {
          age = ans;
        });
      }

  }

  //fonction qui adapte une couleur en fonction du genre choisit
  Color setColor(){
    if(genre){
      return Colors.blue;
    } else {
      return Colors.pink;
    }
  }
  // fonction qui affiche differentes formes de boutons "calculer" selon le SE
  Widget calcButton() {if(Platform.isIOS) {
    return new CupertinoButton(
      color: setColor(),
        child: textAvecStyle("Calculer", color: Colors.white),
        onPressed: calculerNombreDeCalories,
    );
  } else {
   return new RaisedButton(
      color: setColor(),
      child: textAvecStyle("Calculer", color: Colors.white),
      onPressed: calculerNombreDeCalories,
    );
  }}

  // fonction qui affiche differentes formes de boutons "age" selon le SE
  Widget ageButton() {if(Platform.isIOS) {
    return new CupertinoButton(
        color: setColor(),
        //si age est null on affiche "appuyer pour entrer votre age" a sinon on affiche "age"
        child: textAvecStyle((age == null)? "Entrer votre age": "Votre age est : ${age.toInt()}  ans",
          color: Colors.white,
        ),
        onPressed: (() => montrerPicker())
    );
  } else {
    return new RaisedButton(
        color: setColor(),
        //si age est null on affiche "appuyer pour entrer votre age" a sinon on affiche "age"
        child: textAvecStyle((age == null)? "Appuyer pour entrer votre age": "Votre age est : ${age.toInt()}  ans",
          color: Colors.white,
        ),
        onPressed: (() => montrerPicker())
    );
  }}

  // cree une fonction  slider qui va gerer les switch selon le SE
  Widget sliderSelonPlatforme() {
    if(Platform.isIOS) {
      return new CupertinoSlider(
          value: taille,
          activeColor: setColor(),
          onChanged: ((double d) {
            setState(() {
              taille = d;
            });
          }),
        max: 210.0,
        min: 100.0,
      );
    } else {
      return new Slider(
        value: taille,
        activeColor: setColor(),
        onChanged: ((double d) {
          setState(() {
            taille = d;
          });
        }
        ),
        max: 210.0,
        min: 100.0,
      );
    }
  }

  // cree une fonction  switch qui va gerer les switch selon le SE
  Widget switchSelonPlatforme() {
     if(Platform.isIOS) {
      return new CupertinoSwitch(
           value: genre,
           activeColor: Colors.blue,
           onChanged: (bool b) {
             setState(() {
               genre = b;
             });
           }
       );
     } else {
       return new Switch(
         value: genre,
         inactiveTrackColor: Colors.pink,
         activeTrackColor: Colors.blue,
         onChanged: (bool b){
           setState(() {
             genre = b;
           });
         },
       );
     }
  }

  // je cree une fonction textAvecStyle car j'aurai besoin de de plusieurs textes selon le SE
 Widget textAvecStyle(String data, {color: Colors.black, fontSize:15.0}) {
    if(Platform.isIOS) {
       return new DefaultTextStyle(
           style: new TextStyle(
             color: color,
             fontSize: fontSize,

           ),
           child: new Text(
               data,
             textAlign: TextAlign.center,
           )
       );
    } else {
      return new Text(
        data,
        textAlign: TextAlign.center,
        style: new TextStyle(
          color: Colors.black,
          fontSize: fontSize,
        ),
      );
    }

  }

  Row rowRadio() {
    List<Widget> l = [];
    mapActivite.forEach((key, value) {
       Column colonne = new Column(
         mainAxisAlignment: MainAxisAlignment.center,
         children: <Widget>[
           new Radio(
             activeColor: setColor(),
               value: key,
               groupValue: radioSelectionee,
               onChanged: (Object i) {
               setState(() {
                 radioSelectionee = i;
               });
               }),
           textAvecStyle(value, color: setColor()),
         ],
       );
       l.add(colonne);
    });
     return new Row(
       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
       children: l,
     );
  }

  void calculerNombreDeCalories () {
      if(age != null && poids != null && radioSelectionee != null) {
         //calculer
        if(genre) {
          calorieBase =(66.4730 + (13.7516 * poids) + (5.0033 * taille) - (6.7550 * age)).toInt();
        } else {
          calorieBase =(655.0955 + (9.5634 * poids) + (1.8496 * taille) - (4.6756 * age)).toInt();
        }
        switch(radioSelectionee) {
          case 0:
            calorieAvecActivite = (calorieBase * 1.2).toInt();
            break;
          case 1:
            calorieAvecActivite = (calorieBase * 1.5).toInt();
            break;
          case 3:
            calorieAvecActivite = (calorieBase * 1.8).toInt();
            break;
          default:
            calorieAvecActivite = calorieBase;
            break;
        }
        setState(() {
          dialogue();
        });
      } else {
        //alerte remplir tout les champs
        alerte();
      }
  }

  Future<Null> dialogue() async {
    return showDialog(
        context: context,
        barrierDismissible: false,
      builder: (BuildContext buildContext) {
          return SimpleDialog(
            title: textAvecStyle("Votre besoin en calorie", color: setColor()),
            contentPadding: EdgeInsets.all(15.0),
            children: <Widget>[
              padding(),
              textAvecStyle("Votre besoin de base est de : $calorieBase  calories"),
              padding(),
              textAvecStyle("Votre besoin avec activité sportive est de : $calorieAvecActivite  calories"),
              new RaisedButton(
                onPressed: () {
                  Navigator.pop(buildContext);
                },
                child: textAvecStyle("OK", color: Colors.white),
                color: setColor(),
              ),
            ],
          );
      }
    );
  }

  // je cree mon alerte
Future<Null> alerte() async {
    return showDialog(
        context: context,
         barrierDismissible: false,
         builder: (BuildContext buildContext) {
          if(Platform.isIOS) {
            return new CupertinoAlertDialog(
              title: textAvecStyle("Erreur"),
              content: textAvecStyle("Veuillez remplir touts les champs"),
              actions: <Widget>[
                new CupertinoButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  color: Colors.white,
                  child: textAvecStyle("OK", color: Colors.red),
                )
              ],
            );
          } else {
            return new AlertDialog(
              title: textAvecStyle("Erreur"),
              content: textAvecStyle("Veuillez remplir touts les champs"),
              actions: <Widget>[
                new FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: textAvecStyle("OK", color: Colors.red),
                )
              ],
            );
          }

         }
    );
}
}
