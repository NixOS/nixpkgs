{ lib
, jre8
, qmake
, qtbase
, qttools
, qtwebkit
, qtxmlpatterns
, binutils
, wrapQtAppsHook
, openmodelica
<<<<<<< HEAD
, openscenegraph
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, mkOpenModelicaDerivation
}:
with openmodelica;
mkOpenModelicaDerivation rec {
  pname = "omedit";
  omdir = "OMEdit";
  omdeps = [ omcompiler omplot omparser omsimulator ];
  omautoconf = true;

  nativeBuildInputs = [ jre8 qmake qtbase qttools wrapQtAppsHook ];

<<<<<<< HEAD
  buildInputs = [ qtwebkit openscenegraph qtxmlpatterns binutils ];
=======
  buildInputs = [ qtwebkit qtxmlpatterns binutils ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  postPatch = ''
    sed -i ''$(find -name qmake.m4) -e '/^\s*LRELEASE=/ s|LRELEASE=.*$|LRELEASE=${lib.getDev qttools}/bin/lrelease|'
  '';

  dontUseQmakeConfigure = true;
  QMAKESPEC = "linux-clang";

  meta = with lib; {
    description = "A Modelica connection editor for OpenModelica";
    homepage = "https://openmodelica.org";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ balodja smironov ];
    platforms = platforms.linux;
  };
}
