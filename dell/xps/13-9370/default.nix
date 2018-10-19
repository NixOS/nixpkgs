{ lib, pkgs, ... }:

{
  imports = [
    ../../../common/cpu/intel/kaby-lake
    ../../../common/pc/laptop
    ../../../lenovo/thinkpad/acpi_call.nix
    ../../../lenovo/thinkpad/cpu-throttling-bug.nix
  ];

  # Force S3 sleep mode. See README.wiki for details.
  boot.kernelParams = [ "mem_sleep_default=deep" ];

  # touchpad goes over i2c
  boot.blacklistedKernelModules = [ "psmouse" ];
}
