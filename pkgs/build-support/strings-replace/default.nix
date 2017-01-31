{ stdenv
, binutils
, coreutils
, gnugrep
, makeWrapper
}:

stdenv.mkDerivation {
  name = "strings-replace";
  buildInputs = [ makeWrapper ];
  src = ./.;
  inherit binutils coreutils gnugrep;
  builder = ./builder.sh;
}
