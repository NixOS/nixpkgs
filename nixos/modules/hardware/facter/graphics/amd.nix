{ lib, config, ... }:
let
  facterLib = import ../lib.nix lib;
  cfg = config.hardware.facter.detected.graphics.amd;
in
{
  options.hardware.facter.detected.graphics = {
    amd.enable = lib.mkEnableOption "Enable the AMD Graphics module" // {
      default = builtins.elem "amdgpu" (
        facterLib.collectDrivers (config.hardware.facter.report.hardware.graphics_card or [ ])
      );
      defaultText = "hardware dependent";
    };
  };
  config = lib.mkIf (config.hardware.facter.reportPath != null && cfg.enable) {
    services.xserver.videoDrivers = [ "modesetting" ];
  };
}
