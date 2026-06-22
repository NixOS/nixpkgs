{
  buildEnv,
  dejavu_fonts,
}:

buildEnv {
  inherit (dejavu_fonts) pname version;
  paths = [ dejavu_fonts.out ];
}
