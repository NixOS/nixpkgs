{stdenv, firefox, plugins}:

stdenv.mkDerivation {
  name = firefox.name;

  builder = ./builder.sh;
  makeWrapper = ../../../../build-support/make-wrapper/make-wrapper.sh;

  inherit firefox plugins;
}
