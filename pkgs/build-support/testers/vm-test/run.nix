{
  lib,
  hostPkgs,
}:

# Entry point for the image test framework, in the same spirit as
# `nixos/lib/testing/default.nix`'s `runTest`.

let
  testModules = [ ./default.nix ];

  evalTest =
    module:
    lib.evalModules {
      modules = testModules ++ [ module ];
      class = "vmTest";
      specialArgs = { inherit hostPkgs; };
    };
in
{
  inherit evalTest;

  runTest = module: (evalTest module).config.test;
}
