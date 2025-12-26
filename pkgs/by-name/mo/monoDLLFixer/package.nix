{ stdenv, perl }:
stdenv.mkDerivation {
  name = "mono-dll-fixer";
  dllFixer = ./dll-fixer.pl;
  dontUnpack = true;
  installPhase = ''
    substitute $dllFixer $out --subst-var-by perl $perl/bin/perl
    chmod +x $out
  '';
  inherit perl;
}
