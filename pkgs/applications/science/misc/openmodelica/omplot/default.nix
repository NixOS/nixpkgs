{
  lib,
  qtbase,
  qttools,
  qmake,
  wrapQtAppsHook,
  openmodelica,
  mkOpenModelicaDerivation,
}:

mkOpenModelicaDerivation {
  pname = "omplot";
  omdir = "OMPlot";
  omdeps = [ openmodelica.omcompiler ];
  omautoconf = true;

  nativeBuildInputs = [
    qtbase
    qttools
    qmake
    wrapQtAppsHook
  ];

  postPatch = ''
    sed -i OMPlot/Makefile.in -e 's|bindir = @includedir@|includedir = @includedir@|'
    sed -i OMPlot/OMPlot/OMPlotGUI/*.pro -e '/INCLUDEPATH +=/s|$| ../../qwt/src|'
    sed -i ''$(find -name qmake.m4) -e '/^\s*LRELEASE=/ s|LRELEASE=.*$|LRELEASE=${lib.getDev qttools}/bin/lrelease|'
  '';

  dontUseQmakeConfigure = true;
  QMAKESPEC = "linux-clang";

<<<<<<< HEAD
  meta = {
    description = "Plotting tool for OpenModelica-generated results files";
    homepage = "https://openmodelica.org";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      balodja
      smironov
    ];
    platforms = lib.platforms.linux;
=======
  meta = with lib; {
    description = "Plotting tool for OpenModelica-generated results files";
    homepage = "https://openmodelica.org";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      balodja
      smironov
    ];
    platforms = platforms.linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
