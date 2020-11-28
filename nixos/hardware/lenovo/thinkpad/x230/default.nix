{ config, lib, pkgs, ... }:

{
  imports = [
    ../.
    ../../../common/cpu/intel
    ../../../common/pc/laptop/acpi_call.nix
  ];

  boot = {
    kernelModules = [
      "tpm-rng"
    ];
  };

  services.xserver.deviceSection = lib.mkDefault ''
    Option "TearFree" "true"
  '';
}
