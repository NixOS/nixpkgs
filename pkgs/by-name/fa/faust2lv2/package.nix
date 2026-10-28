{
  bash,
  boost,
  faust,
  lv2,
  qt5,
}:

faust.wrapWithBuildEnv {

  baseName = "faust2lv2";

  buildInputs = [
    bash
  ];

  propagatedBuildInputs = [
    boost
    lv2
    qt5.qtbase
  ];

  dontWrapQtApps = true;

  preFixup = ''
    sed -i "/QMAKE=/c\ QMAKE="${qt5.qtbase.dev}/bin/qmake"" "$out"/bin/faust2lv2;
  '';
}
