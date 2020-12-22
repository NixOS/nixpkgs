{ config, lib, ... }:

with lib;

let

  cfg = config.hardware.amdgpu;

  enabled = elem "amdgpu" config.services.xserver.videoDrivers;

in
{
  options = {
    hardware.amdgpu.enableDisplayCore = mkOption {
      default = true;
      type = types.bool;
      description = ''
        Enable drm display core (DC) support for amdgpu.
        Depending on hardware setup this may either solve or cause video output problems.
      '';
    };
  };

  config = {
    boot.blacklistedKernelModules = mkIf (elem "amdgpu" config.services.xserver.videoDrivers) [ "radeon" ];
    boot.kernel.features.amdgpu_dc = cfg.enableDisplayCore;
  };
}

