{ config, lib, ... }:

with lib;
{
  config = mkIf (elem "amdgpu" config.services.xserver.videoDrivers) {
    boot.blacklistedKernelModules = [ "radeon" ];
  };
}

