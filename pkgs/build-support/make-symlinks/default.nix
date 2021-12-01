{name ? "", stdenv, dir, files}:

stdenv.mkDerivation {
  inherit dir files;
  name = if name == "" then dir.name else name;
  builder = ./builder.sh;
}
