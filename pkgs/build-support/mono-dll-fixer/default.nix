{stdenv, perl}:

stdenv.mkDerivation {
  name = "mono-dll-fixer";
  builder = ./builder.sh;
  dllFixer = ./dll-fixer.pl;
  inherit perl;
}
