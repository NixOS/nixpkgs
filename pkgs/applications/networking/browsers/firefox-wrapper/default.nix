{stdenv, firefox, plugins}:

stdenv.mkDerivation {
  name = firefox.name;

  builder = ./builder.sh;

  inherit firefox plugins;
}
