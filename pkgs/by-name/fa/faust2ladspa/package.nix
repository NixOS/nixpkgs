{
  boost,
  faust,
  ladspa-header,
}:

faust.wrapWithBuildEnv {

  baseName = "faust2ladspa";

  propagatedBuildInputs = [
    boost
    ladspa-header
  ];

}
