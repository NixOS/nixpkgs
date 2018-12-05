{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.hardware.applespi;

  kernelPackages = config.boot.kernelPackages;

in

{

  options.hardware.applespi.enable = mkEnableOption "applespi kernel module";

  config = mkIf cfg.enable {

    boot.kernelModules = [ "applespi" "spi_pxa2xx_platform" "spi_pxa2xx_pci" ];

    boot.extraModulePackages = [ kernelPackages.applespi ];

    # unload module during suspend/hibernate as it crashes the whole system
    powerManagement.powerDownCommands = ''
      ${pkgs.kmod}/bin/lsmod | ${pkgs.gnugrep}/bin/grep -q "^applespi" && ${pkgs.kmod}/bin/rmmod -f -v applespi
    '';

    # and load it back on resume
    powerManagement.resumeCommands = ''
      ${pkgs.kmod}/bin/modprobe -v applespi
    '';

  };

}
