{stdenv, wrapperDir}:

stdenv.mkDerivation {
  name = "setuid-wrapper";
  builder = ./builder.sh;
  setuidWrapper = ./setuid-wrapper.c;
  inherit wrapperDir;
}
