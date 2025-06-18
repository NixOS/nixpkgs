{
  boost,
  faust,
  ladspaH,
}:

faust.wrapWithBuildEnv {

  baseName = "faust2ladspa";

  propagatedBuildInputs = [
    boost
    ladspaH
  ];

}
