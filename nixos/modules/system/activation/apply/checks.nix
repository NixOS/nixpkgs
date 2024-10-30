# Run:
#   nix-build -A nixosTests.apply
#
# These are not all tests. See also nixosTests.

{
  lib,
  stdenvNoCC,
  testers,
  ...
}:

let
  fileset = lib.fileset.unions [
    ./test.sh
    ./apply.sh
  ];
in

{
  unitTests = stdenvNoCC.mkDerivation {
    name = "nixos-apply-unit-tests";
    src = lib.fileset.toSource {
      root = ./.;
      inherit fileset;
    };
    dontBuild = true;
    checkPhase = ''
      ./test.sh
    '';
    installPhase = ''
      touch $out
    '';
  };

  shellcheck =
    (testers.shellcheck {
      src = lib.fileset.toSource {
        # This makes the error messages include the full path
        root = ../../../../..;
        inherit fileset;
      };
    }).overrideAttrs
      {
        postUnpack = ''
          for f in $(find . -type f); do
            substituteInPlace $f --replace @bash@ /usr/bin/bash
          done
        '';
      };
}
