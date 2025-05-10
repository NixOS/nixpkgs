{ lib }:
let

  evalTest =
    module:
    lib.evalModules {
      modules = testModules ++ [ module ];
      class = "nixosTest";
    };
  runTest =
    module:
    # Infra issue: virtualization on darwin doesn't seem to work yet.
    lib.addMetaAttrs { hydraPlatforms = lib.platforms.linux; }
      (evalTest (
        { config, ... }:
        {
          imports = [ module ];
          result = config.test;
        }
      )).config.result;

  testModules = [
    ./call-test.nix
    ./driver.nix
    ./interactive.nix
    ./legacy.nix
    ./meta.nix
    ./name.nix
    ./network.nix
    ./nodes.nix
    ./pkgs.nix
    ./run.nix
    ./testScript.nix
  ];

in
{
  inherit evalTest runTest testModules;
}
