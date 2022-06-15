{ lib }:
let

  evalTest = module: lib.evalModules { modules = testModules ++ [ module ]; };
  runTest = module: (evalTest module).config.result;

  testModules = [
    ./driver.nix
    ./interactive.nix
    ./legacy.nix
    ./matrix.nix
    ./meta.nix
    ./name.nix
    ./network.nix
    ./nodes.nix
    ./params.nix
    ./pkgs.nix
    ./run.nix
    ./testScript.nix
  ];

in
{
  inherit evalTest runTest testModules;
}
