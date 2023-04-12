{ boost
, faust
, lv2
, qt4
, which

}:

faust.wrapWithBuildEnv {

  baseName = "faust2lv2";

  propagatedBuildInputs = [ boost lv2 qt4 which ];

}
