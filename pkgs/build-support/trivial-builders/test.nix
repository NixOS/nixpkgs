{ lib, nixosTest, pkgs, writeText, hello, figlet, stdenvNoCC }:

# -------------------------------------------------------------------------- #
#
#                         trivial-builders test
#
# -------------------------------------------------------------------------- #
#
#  This file can be run independently (quick):
#
#      $ pkgs/build-support/trivial-builders/test.sh
#
#  or in the build sandbox with a ~20s VM overhead
#
#      $ nix-build -A tests.trivial-builders
#
# -------------------------------------------------------------------------- #

let
  invokeSamples = file:
    lib.concatStringsSep " " (
      lib.attrValues (import file { inherit pkgs; })
    );
in
nixosTest {
  name = "nixpkgs-trivial-builders";
  nodes.machine = { ... }: {
    virtualisation.writableStore = true;

    # Test runs without network, so we don't substitute and prepare our deps
    nix.binaryCaches = lib.mkForce [];
    environment.etc."pre-built-paths".source = writeText "pre-built-paths" (
      builtins.toJSON [hello figlet stdenvNoCC]
    );
    environment.variables = {
      SAMPLE = invokeSamples ./test/sample.nix;
      REFERENCES = invokeSamples ./test/invoke-writeReferencesToFile.nix;
      DIRECT_REFS = invokeSamples ./test/invoke-writeDirectReferencesToFile.nix;
    };
  };
  testScript =
    let
      sample = import ./test/sample.nix { inherit pkgs; };
      samplePaths = lib.unique (lib.attrValues sample);
      sampleText = pkgs.writeText "sample-text" (lib.concatStringsSep "\n" samplePaths);
      stringReferencesText =
        pkgs.writeStringReferencesToFile
          ((lib.concatMapStringsSep "fillertext"
            (d: "${d}")
            (lib.attrValues sample)) + ''
              STORE=${builtins.storeDir};\nsystemctl start bar-foo.service
            '');
    in ''
      machine.succeed("""
        ${./test.sh} 2>/dev/console
      """)
      machine.succeed("""
        echo >&2 Testing string references...
        diff -U3 <(sort ${stringReferencesText}) <(sort ${sampleText})
      """)
    '';
  meta = {
    license = lib.licenses.mit; # nixpkgs license
    maintainers = with lib.maintainers; [
      roberth
    ];
    description = "Run the Nixpkgs trivial builders tests";
  };
}
