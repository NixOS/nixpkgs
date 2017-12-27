{ config, lib, pkgs, ... }:

with lib; {
  imports = [
    ../.
    ../../../common/cpu/intel
  ];

  boot = {
    kernelModules = [
      "acpi_call"
      "tpm-rng"
    ];
    extraModulePackages = with config.boot.kernelPackages; [
      acpi_call
    ];
  };

  hardware.opengl.extraPackages = with pkgs; [
    vaapiIntel
    vaapiVdpau
    libvdpau-va-gl
  ];
}
