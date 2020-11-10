{ faust
, gtk2
, jack2Full
, alsaLib
, opencv
, libsndfile
, which
}:

faust.wrapWithBuildEnv {

  baseName = "faust2jack";

  scripts = [
    "faust2jack"
    "faust2jackconsole"
  ];

  propagatedBuildInputs = [
    gtk2
    jack2Full
    alsaLib
    opencv
    libsndfile
    which
  ];

}
