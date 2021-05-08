{lib, qtbase, qttools, qmake, wrapQtAppsHook,
openmodelica, mkOpenModelicaDerivation}:

mkOpenModelicaDerivation rec {
  pname = "omplot";
  omdir = "OMPlot";
  omdeps = [openmodelica.omcompiler];
  omautoconf = true;

  nativeBuildInputs = [qtbase qttools qmake wrapQtAppsHook];

  buildInputs = [];

  patchPhase = ''
    sed -i OMPlot/Makefile.in -e 's|bindir = @includedir@|includedir = @includedir@|'
    sed -i OMPlot/OMPlot/OMPlotGUI/*.pro -e '/INCLUDEPATH +=/s|$| ../../qwt/src|'
    sed -i ''$(find -name qmake.m4) -e '/^\s*LRELEASE=/ s|LRELEASE=.*$|LRELEASE=${lib.getDev qttools}/bin/lrelease|'
    '';

  dontUseQmakeConfigure = true;
}
