{
  faust,
  xdg-utils,
}:

# This just runs faust2svg, then attempts to open a browser using
# 'xdg-open'.

faust.wrap {

  baseName = "faust2firefox";

  runtimeInputs = [ xdg-utils ];

}
