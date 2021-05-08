{lib, jre, qmake, qtbase, qttools, qtwebkit, qtxmlpatterns, binutils, wrapQtAppsHook,
openmodelica, mkOpenModelicaDerivation}:
with openmodelica;
mkOpenModelicaDerivation rec {
  pname = "omedit";
  omdir = "OMEdit";
  omdeps = [omcompiler omplot omparser omsimulator];
  omautoconf = true;

  nativeBuildInputs = [jre qmake qtbase qttools wrapQtAppsHook];

  buildInputs = [qtwebkit qtxmlpatterns binutils];

  patchPhase = ''
    sed -i ''$(find -name qmake.m4) -e '/^\s*LRELEASE=/ s|LRELEASE=.*$|LRELEASE=${lib.getDev qttools}/bin/lrelease|'
    '';

  dontUseQmakeConfigure = true;
}
