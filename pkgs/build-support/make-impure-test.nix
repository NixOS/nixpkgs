/*
  Create tests that run in the nix sandbox with additional access to selected host paths

  This is for example useful for testing hardware where a tests needs access to
  /sys and optionally more.

  The following example shows a test that accesses the GPU:

  Example:
    makeImpureTest {
      name = "opencl";
      testedPackage = "mypackage"; # Or testPath = "mypackage.impureTests.opencl.testDerivation"

      sandboxPaths = [ "/sys" "/dev/dri" ]; # Defaults to ["/sys"]
      prepareRunCommands = ""; # (Optional) Setup for the runScript
      nixFlags = []; # (Optional) nix-build options for the runScript

      testScript = "...";
    }

  Save as `test.nix` next to a package and reference it from the package:
    passthru.impureTests = { opencl = callPackage ./test.nix {}; };

  `makeImpureTest` will return here a script that contains the actual nix-build command including all necessary sandbox flags.

  It can be executed like this:
    $(nix-build -A mypackage.impureTests)

  Rerun an already cached test:
    $(nix-build -A mypackage.impureTests) --check
*/
{
  lib,
  stdenv,
  writeShellScript,

  name,
  testedPackage ? null,
  testPath ? "${testedPackage}.impureTests.${name}.testDerivation",
  sandboxPaths ? [ "/sys" ],
  prepareRunCommands ? "",
  nixFlags ? [ ],
  testScript,
  ...
}@args:

let
  sandboxPathsTests = builtins.map (path: "[[ ! -e '${path}' ]]") sandboxPaths;
  sandboxPathsTest = lib.concatStringsSep " || " sandboxPathsTests;
  sandboxPathsList = lib.concatStringsSep " " sandboxPaths;

  testDerivation = stdenv.mkDerivation (
    lib.recursiveUpdate
      {
        name = "test-run-${name}";

        requiredSystemFeatures = [ "nixos-test" ];

        buildCommand = ''
          mkdir -p $out

          if ${sandboxPathsTest}; then
            echo 'Run this test as *root* with `--option extra-sandbox-paths '"'${sandboxPathsList}'"'`'
            exit 1
          fi

          # Run test
          ${testScript}
        '';

        passthru.runScript = runScript;
      }
      (
        builtins.removeAttrs args [
          "lib"
          "stdenv"
          "writeShellScript"

          "name"
          "testedPackage"
          "testPath"
          "sandboxPaths"
          "prepareRunCommands"
          "nixFlags"
          "testScript"
        ]
      )
  );

  runScript = writeShellScript "run-script-${name}" ''
    set -euo pipefail

    ${prepareRunCommands}

    sudo nix-build --option extra-sandbox-paths '${sandboxPathsList}' ${lib.escapeShellArgs nixFlags} -A ${testPath} "$@"
  '';
in
# The main output is the run script, inject the derivation for the actual test
runScript.overrideAttrs (old: {
  passthru = { inherit testDerivation; };
})
