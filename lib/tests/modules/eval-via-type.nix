{ lib ? import ../.. }:

{
  inherit ((lib.types.submoduleWith {
    modules = [ { options.foo.enable = lib.mkEnableOption "foo"; } ];
    specialArgs.modulesPath = ./.;
  }).evalModules {
    modules = [ { config.foo.enable = true; } ];
  }) config options;
}
