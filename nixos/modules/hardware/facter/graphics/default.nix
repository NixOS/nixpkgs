{ lib, config, ... }:
let
  facterLib = import ../lib.nix lib;
  cfg = config.hardware.facter.detected.graphics;
  graphicsEnableOption =
    if lib.versionOlder lib.version "24.11pre" then
      "hardware.opengl.enable"
    else
      "hardware.graphics.enable";
in
{
  imports = [
    ./amd.nix
  ];
  options.hardware.facter.detected = {
    graphics.enable = lib.mkEnableOption "Enable the Graphics module" // {
      default = builtins.length (config.hardware.facter.report.hardware.monitor or [ ]) > 0;
      defaultText = "hardware dependent";
    };
    boot.graphics.kernelModules = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      # We currently don't auto import nouveau, in case the user might want to use the proprietary nvidia driver,
      # We might want to change this in future, if we have a better idea, how to handle this.
      default = lib.remove "nouveau" (
        lib.uniqueStrings (
          facterLib.collectDrivers (config.hardware.facter.report.hardware.graphics_card or [ ])
        )
      );
      defaultText = "hardware dependent";
      description = ''
        List of kernel modules to load at boot for the graphics card.
      '';
    };
  };

  config = lib.mkIf (config.hardware.facter.enable && cfg.enable) (
    lib.mkMerge [
      (facterLib.mkFacterAssignment {
        moduleName = "graphics";
        path = "boot.initrd.kernelModules";
        value = config.hardware.facter.detected.boot.graphics.kernelModules;
      })

      (facterLib.mkFacterAssignment {
        moduleName = "graphics";
        path = graphicsEnableOption;
        value = lib.mkDefault true;
        facterValue = true;
      })
    ]
  );
}
