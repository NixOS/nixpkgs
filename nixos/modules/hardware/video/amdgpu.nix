{ config, lib, ... }:

with lib;

let

  cfg = config.hardware.amdgpu;

in
{
  options = {
    hardware.amdgpu.displayCore = mkOption {
      default = "default";
      type = types.enum [ "default" "disabled" "enabled"];
      description = ''
        This option controls drm display core (DC) support for amdgpu.
        Depending on hardware setup, it may either solve or cause video output problems.

        Try toggling this option if you encounter black screen during boot or DP/HDMI compatibility issues.

        By <literal>"default"</literal> it uses kernel's default config where DC support for newer family of cards
        will not be enabled.
      '';
    };
  };

  config = {
    boot.blacklistedKernelModules = mkIf (elem "amdgpu" config.services.xserver.videoDrivers) [ "radeon" ];

    boot.kernel.features.amdgpu_dc_disabled = cfg.displayCore == "disabled";
    boot.kernel.features.amdgpu_dc_all = cfg.displayCore == "enabled";
  };
}
