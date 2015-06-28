{ faust
, alsaLib
, qt4
}:

faust.wrapWithBuildEnv {

  baseName = "faust2alqt";

  propagatedBuildInputs = [
    alsaLib
    qt4
  ];

}
