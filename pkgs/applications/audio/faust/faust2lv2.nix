{ boost
, faust
, lv2
<<<<<<< HEAD
, qtbase
, which
=======
, qt4
, which

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

faust.wrapWithBuildEnv {

  baseName = "faust2lv2";

<<<<<<< HEAD
  propagatedBuildInputs = [ boost lv2 qtbase ];

  dontWrapQtApps = true;

  preFixup = ''
    sed -i "/QMAKE=/c\ QMAKE="${qtbase.dev}/bin/qmake"" "$out"/bin/faust2lv2;
  '';
=======
  propagatedBuildInputs = [ boost lv2 qt4 which ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}
