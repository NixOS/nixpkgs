{stdenv, perl}:

stdenv.mkDerivation {
  name = "mono-dll-fixer";
  builder = ./builder.sh;
  substituter = ../substitute/substitute.sh;
  dllFixer = ./dll-fixer.pl;
  inherit perl;
}