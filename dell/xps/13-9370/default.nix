{ lib, pkgs, ... }:

{
  imports = [
    ../../../common/cpu/intel/kaby-lake
    ../../../common/pc/laptop
    ../../../common/pc/laptop/acpi_call.nix
  ];

  # Force S3 sleep mode. See README.wiki for details.
  boot.kernelParams = [ "mem_sleep_default=deep" ];

  # touchpad goes over i2c
  boot.blacklistedKernelModules = [ "psmouse" ];

  services.throttled.enable = lib.mkDefault true;
}
