{ boost
, faust
, lv2
, qt4

}:

faust.wrapWithBuildEnv {

  baseName = "faust2lv2";

  propagatedBuildInputs = [ boost lv2 qt4 ];

}
