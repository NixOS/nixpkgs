{ lib ? import <nixpkgs/lib>, modules ? [] }:

{
  inherit (lib.evalModules {
    inherit modules;
    specialArgs.modulesPath = ./.;
  }) config options;
}
