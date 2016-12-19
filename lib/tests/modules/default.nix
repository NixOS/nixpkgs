{ lib ? import <nixpkgs/lib>, modules ? [] }:

{
  inherit (lib.evalModules {
    inherit modules;
  }) config options;
}
