{name, stdenv, dir, files}:

stdenv.mkDerivation {
  inherit name dir files;
  builder = ./linker.sh;
}
