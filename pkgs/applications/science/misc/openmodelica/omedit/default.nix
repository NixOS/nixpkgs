{
  lib,
  jre8,
  qmake,
  qtbase,
  qttools,
  qtwebengine,
  qtxmlpatterns,
  binutils,
  wrapQtAppsHook,
  openmodelica,
  openscenegraph,
  mkOpenModelicaDerivation,
}:
with openmodelica;
mkOpenModelicaDerivation {
  pname = "omedit";
  omdir = "OMEdit";
  omdeps = [
    omcompiler
    omplot
    omparser
    omsimulator
  ];
  omautoconf = true;

  nativeBuildInputs = [
    jre8
    qmake
    qtbase
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    qtwebengine
    openscenegraph
    qtxmlpatterns
    binutils
  ];

  postPatch = ''
    sed -i ''$(find -name qmake.m4) -e '/^\s*LRELEASE=/ s|LRELEASE=.*$|LRELEASE=${lib.getDev qttools}/bin/lrelease|'

    #remove remnants of qtwebkit
    sed -i OMEdit/OMEdit.config.pre.pri -e '
      s|webkit|webengine|g
    '
    sed -i OMEdit/OMEditGUI/OMEditGUI.pro -e '
      s|webkit|webengine|g
    '
    sed -i OMEdit/OMEdit.config.pre.pri -e '
      s|webkit|webengine|g
      s|OM_HAVE_PTHREADS|OM_HAVE_PTHREADS OM_OMEDIT_ENABLE_QTWEBENGINE|
    '
    # here, the build system seems to assume that the current OPENMODELICAHOME is a subdirectory of the source
    # directory. Our packaging of Openmodelica breaks this assumption, so point OMEditLIB.pro towards the correct
    # source dir.
    sed -i OMEdit/OMEditLIB/OMEditLIB.pro -e '
      s|$$OPENMODELICAHOME/\.\.|$$PWD/../..|g
    '
  '';

  dontUseQmakeConfigure = true;
  QMAKESPEC = "linux-clang";

  meta = with lib; {
    description = "Modelica connection editor for OpenModelica";
    homepage = "https://openmodelica.org";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      balodja
      smironov
    ];
    platforms = platforms.linux;
  };
}
