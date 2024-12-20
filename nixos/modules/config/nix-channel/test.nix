# Run:
#   nix-build -A nixosTests.nix-channel
{ lib, testers }:
let
  inherit (lib) fileset;

  runShellcheck = testers.shellcheck {
    src = fileset.toSource {
      root = ./.;
      fileset = fileset.unions [
        ./activation-check.sh
      ];
    };
  };

in
lib.recurseIntoAttrs {
  inherit runShellcheck;
}
