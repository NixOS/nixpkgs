{ faust
, lv2
}:

faust.wrapWithBuildEnv {

  baseName = "faust2lv2";

  propagatedBuildInputs = [ lv2 ];

}
