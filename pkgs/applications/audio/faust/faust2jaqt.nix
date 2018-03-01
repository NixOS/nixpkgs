{ faust
, jack2Full
, opencv
, qt4
, libsndfile
}:

faust.wrapWithBuildEnv {

  baseName = "faust2jaqt";

  scripts = [
    "faust2jaqt"
    "faust2jackserver"
  ];

  propagatedBuildInputs = [
    jack2Full
    opencv
    qt4
    libsndfile
  ];

}
