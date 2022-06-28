{ system
, pkgs ? import ../.. { inherit system config; }
  # Use a minimal kernel?
, minimal ? false
  # Ignored
, config ? { }
  # !!! See comment about args in lib/modules.nix
, specialArgs ? { }
  # Modules to add to each VM
, extraConfigurations ? [ ]
}:

with pkgs;

let
  nixos-lib = import ./default.nix { inherit (pkgs) lib; };
in

rec {

  inherit pkgs;

  evalTest = module: nixos-lib.evalTest { imports = [ extraTestModule module ]; };
  runTest = module: nixos-lib.runTest { imports = [ extraTestModule module ]; };

  extraTestModule = {
    config = {
      hostPkgs = pkgs;
    };
  };

  # Make a full-blown test
  makeTest =
    { machine ? null
    , nodes ? {}
    , testScript
    , enableOCR ? false
    , name ? "unnamed"
    , skipTypeCheck ? false
      # Skip linting (mainly intended for faster dev cycles)
    , skipLint ? false
    , passthru ? {}
    , meta ? {}
    , # For meta.position
      pos ? # position used in error messages and for meta.position
        (if meta.description or null != null
          then builtins.unsafeGetAttrPos "description" meta
          else builtins.unsafeGetAttrPos "testScript" t)
    , extraPythonPackages ? (_ : [])
    , interactive ? {}
    } @ t:
      runTest {
        imports = [
          { _file = "makeTest parameters"; config = t; }
          {
            defaults = {
              _file = "makeTest: extraConfigurations";
              imports = extraConfigurations;
            };
          }
        ];
      };

  simpleTest = as: (makeTest as).test;

}
