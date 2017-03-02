{ lib ? import ../.., modules ? [] }:

{
  inherit (lib.evalModules {
    inherit modules;
  }) config options;
}
