{ boost
, faust1git
, lv2
, qt4

}:

faust1git.wrapWithBuildEnv {

  baseName = "faust2lv2";

  propagatedBuildInputs = [ boost lv2 qt4 ];

}
