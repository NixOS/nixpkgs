{stdenv, bash, coreutils, findutils}:

derivation {
  name = "init";
  system = stdenv.system;
  builder = ./builder.sh;
  src = ./init.sh;
  inherit stdenv bash coreutils findutils;
}
