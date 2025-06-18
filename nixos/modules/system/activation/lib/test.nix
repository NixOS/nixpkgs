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
    src = fileset.toSource {
      root = ./.;
      fileset = fileset.unions [
        ./lib.sh
        ./test.sh
      ];
    };
    buildPhase = ":";
    doCheck = true;
    postUnpack = ''
      patchShebangs --build .
    '';
    checkPhase = ''
      ./test.sh
    '';
    installPhase = ''
      touch $out
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
