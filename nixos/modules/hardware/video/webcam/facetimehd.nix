{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.hardware.facetimehd;

  kernelPackages = config.boot.kernelPackages;

in

{

  options.hardware.facetimehd.enable = mkEnableOption "facetimehd kernel module";

  config = mkIf cfg.enable {

    assertions = singleton {
      assertion = versionAtLeast kernelPackages.kernel.version "3.19";
      message = "facetimehd is not supported for kernels older than 3.19";
    };

    boot.kernelModules = [ "facetimehd" ];

    boot.extraModulePackages = [ kernelPackages.facetimehd ];

    hardware.firmware = [ pkgs.facetimehd-firmware ];

    # unload module during suspend/hibernate as it crashes the whole system
    powerManagement.powerDownCommands = ''
      ${pkgs.module_init_tools}/bin/rmmod -f facetimehd
    '';

    # and load it back on resume
    powerManagement.resumeCommands = ''
      export MODULE_DIR=/run/current-system/kernel-modules/lib/modules
      ${pkgs.module_init_tools}/bin/modprobe -v facetimehd
    '';

  };

}
