{stdenv}:

stdenv.mkDerivation {
  name = "native-darwin-cctools-wrapper";
  builder = ./builder.sh;
}
