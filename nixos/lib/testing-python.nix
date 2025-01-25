args@{
  system,
  pkgs ? import ../.. { inherit system config; },
  # Use a minimal kernel?
  minimal ? false,
  # Ignored
  config ? { },
  # !!! See comment about args in lib/modules.nix
  specialArgs ? throw "legacy - do not use, see error below",
  # Modules to add to each VM
  extraConfigurations ? [ ],
}:
let
  nixos-lib = import ./default.nix { inherit (pkgs) lib; };
in

pkgs.lib.throwIf (args ? specialArgs)
  ''
    testing-python.nix: `specialArgs` is not supported anymore. If you're looking
    for the public interface to the NixOS test framework, use `runTest`, and
    `node.specialArgs`.
    See https://nixos.org/manual/nixos/unstable/index.html#sec-calling-nixos-tests
    and https://nixos.org/manual/nixos/unstable/index.html#test-opt-node.specialArgs
  ''
  rec {

    inherit pkgs;

    evalTest =
      module:
      nixos-lib.evalTest {
        imports = [
          extraTestModule
          module
        ];
      };
    runTest =
      module:
      nixos-lib.runTest {
        imports = [
          extraTestModule
          module
        ];
      };

    extraTestModule = {
      config = {
        hostPkgs = pkgs;
      };
    };

    # Make a full-blown test (legacy)
    # For an official public interface to the tests, see
    # https://nixos.org/manual/nixos/unstable/index.html#sec-calling-nixos-tests
    makeTest =
      {
        machine ? null,
        nodes ? { },
        testScript,
        enableOCR ? false,
        globalTimeout ? (60 * 60),
        name ? "unnamed",
        skipTypeCheck ? false,
        # Skip linting (mainly intended for faster dev cycles)
        skipLint ? false,
        passthru ? { },
        meta ? { },
        # For meta.position
        pos ? # position used in error messages and for meta.position
          (
            if meta.description or null != null then
              builtins.unsafeGetAttrPos "description" meta
            else
              builtins.unsafeGetAttrPos "testScript" t
          ),
        extraPythonPackages ? (_: [ ]),
        interactive ? { },
      }@t:
      let
        testConfig =
          (evalTest {
            imports = [
              {
                _file = "makeTest parameters";
                config = t;
              }
              {
                defaults = {
                  _file = "makeTest: extraConfigurations";
                  imports = extraConfigurations;
                };
              }
            ];
          }).config;
      in
      testConfig.test # For nix-build
      // testConfig; # For all-tests.nix

    simpleTest = as: (makeTest as).test;

  }
