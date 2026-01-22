{ stdenv, perl }:
stdenv.mkDerivation {
  name = "mono-dll-fixer";
  dllFixer = ./dll-fixer.pl;
  dontUnpack = true;
  installPhase = ''
    runHook preInstall

    substitute $dllFixer $out --subst-var-by perl $perl/bin/perl
    chmod +x $out

    runHook postInstall
  '';
  inherit perl;
}
