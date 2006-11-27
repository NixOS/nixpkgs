{stdenv, theme}:

stdenv.mkDerivation {
  name = "theme";
  builder = ./unpack-theme.sh;
  inherit theme;
}
