{ faust
, gtk
, jack2
, opencv
}:

faust.wrapWithBuildEnv {

  baseName = "faust2jack";

  scripts = [
    "faust2jack"
    "faust2jackinternal"
    "faust2jackconsole"
  ];

  propagatedBuildInputs = [
    gtk
    jack2
    opencv
  ];

}
