{
  buildEnv,
  dejavu_fonts,
}:

buildEnv {
  inherit (dejavu_fonts) pname version;
  paths = [ dejavu_fonts.out ];
  meta.license = dejavu_fonts.meta.license;
}
