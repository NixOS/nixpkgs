# Run:
#   nix-build -A nixosTests.activation-lib
{
  lib,
  stdenv,
  testers,
}:
let
  inherit (lib) fileset;

  runTests = stdenv.mkDerivation {
    name = "tests-activation-lib";
    src = ./lib;
    buildPhase = ":";
    doCheck = true;
    postUnpack = ''
      patchShebangs --build .
    '';
    checkPhase = ''
      ./test.sh
    '';
    installPhase = ''
      runHook preInstall

      touch $out

      runHook postInstall
    '';
  };

  runShellcheck = testers.shellcheck {
    name = "activation-lib";
    src = runTests.src;
  };

in
lib.recurseIntoAttrs {
  inherit runTests runShellcheck;
}
