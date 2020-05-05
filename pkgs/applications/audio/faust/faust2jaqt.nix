{ faust
, jack2Full
, opencv2
, qt4
, libsndfile
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
    opencv2
    qt4
    libsndfile
    which
  ];

}
