{ lib, testers, pkgs, writeText, hello, figlet, stdenvNoCC }:

# -------------------------------------------------------------------------- #
#
#                         trivial-builders test
#
# -------------------------------------------------------------------------- #
#
#  This file can be run independently (quick):
#
#      $ pkgs/build-support/trivial-builders/references-test.sh
#
#  or in the build sandbox with a ~20s VM overhead
#
#      $ nix-build -A tests.trivial-builders.references
#
# -------------------------------------------------------------------------- #

let
  invokeSamples = file:
    lib.concatStringsSep " " (
      lib.attrValues (import file { inherit pkgs; })
    );
in
testers.nixosTest {
  name = "nixpkgs-trivial-builders";
  nodes.machine = { ... }: {
    virtualisation.writableStore = true;

    # Test runs without network, so we don't substitute and prepare our deps
    nix.settings.substituters = lib.mkForce [];
    environment.etc."pre-built-paths".source = writeText "pre-built-paths" (
      builtins.toJSON [hello figlet stdenvNoCC]
    );
    environment.variables = {
      SAMPLE = invokeSamples ./sample.nix;
      REFERENCES = invokeSamples ./invoke-writeReferencesToFile.nix;
      DIRECT_REFS = invokeSamples ./invoke-writeDirectReferencesToFile.nix;
    };
  };
  testScript =
    ''
      machine.succeed("""
        ${./references-test.sh} 2>/dev/console
      """)
    '';
  meta = {
    maintainers = with lib.maintainers; [
      roberth
    ];
  };
}
