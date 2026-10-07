{
  lib,
  stdenv,
  perl,
}:
stdenv.mkDerivation {
  pname = "mono-dll-fixer";
  version = lib.trivial.release;
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
