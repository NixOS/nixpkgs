{ faust
, jack2Full
, qt4
, libsndfile
, alsaLib
, which
}:

faust.wrapWithBuildEnv {

  baseName = "faust2jaqt";

  scripts = [
    "faust2jaqt"
    "faust2jackserver"
  ];

  propagatedBuildInputs = [
    jack2Full
    qt4
    libsndfile
    alsaLib
    which
  ];

}
