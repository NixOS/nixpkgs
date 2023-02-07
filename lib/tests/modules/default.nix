{ lib ? import ../.., modules ? [] }:

let
  inherit (lib.evalModules {
    inherit modules;
    specialArgs.modulesPath = ./.;
  }) config options;
in {
  inherit config options;
  docOptions = lib.optionAttrSetToDocList options;
}
