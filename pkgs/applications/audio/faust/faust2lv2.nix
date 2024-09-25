{ boost
, faust
, lv2
, qtbase
}:

faust.wrapWithBuildEnv {

  baseName = "faust2lv2";

  propagatedBuildInputs = [ boost lv2 qtbase ];

  dontWrapQtApps = true;

  preFixup = ''
    sed -i "/QMAKE=/c\ QMAKE="${qtbase.dev}/bin/qmake"" "$out"/bin/faust2lv2;
  '';
}
