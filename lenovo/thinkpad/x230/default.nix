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

  services.tlp.extraConfig = lib.mkDefault ''
    START_CHARGE_THRESH_BAT0=67
    STOP_CHARGE_THRESH_BAT0=100
  '';

}
