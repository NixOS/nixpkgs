{ lib, config, ... }:
let
  cfg = config.hardware.facter.detected.graphics.nvidia;
in
{
  options.hardware.facter.detected.graphics = {
    nvidia.enable = lib.mkEnableOption "Enable the NVIDIA Graphics module" // {
      default = builtins.elem "nvidia" config.hardware.facter.detected.boot.graphics.kernelModules;
      defaultText = "hardware dependent";
    };
  };
  config = lib.mkIf (config.hardware.facter.reportPath != null && cfg.enable) {
    services.xserver.videoDrivers = [ "nvidia" ];

    # Companion modules that make all work smoothly
    boot.initrd.kernelModules = [
      "nvidia_drm"
      "nvidia_modeset"
      "nvidia_uvm"
    ];

    hardware.nvidia.open = lib.versionAtLeast config.hardware.nvidia.package.version "560";
  };
}
