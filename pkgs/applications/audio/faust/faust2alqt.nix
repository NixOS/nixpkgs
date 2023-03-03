{ faust
, alsa-lib
, qt4
}:

faust.wrapWithBuildEnv {

  baseName = "faust2alqt";

  propagatedBuildInputs = [
    alsa-lib
    qt4
  ];

}
