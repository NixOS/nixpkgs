{ config, lib, pkgs, ... }:

with lib;
{
  options = {
    hardware.sensor.zenpower = {
      enable = mkEnableOption "additional sensors for AMD Zen family CPUs";
    };
  };

  config = mkIf config.hardware.sensor.zenpower.enable {
    boot.kernelModules = [ "zenpower" ];
    boot.blacklistedKernelModules = [ "k10temp" ];
    boot.extraModulePackages = [ config.boot.kernelPackages.zenpower ];
  };
}
