{ config, lib, pkgs, ... }:

{
  imports = [ ../. ];

  boot = {
    extraModprobeConfig = lib.mkDefault ''
      options bbswitch use_acpi_to_detect_card_state=1
    '';
    kernelModules = [ "tpm-rng" ];
  };

  services.xserver.videoDrivers = [ "intel" ];
}
