{ config, pkgs, ... }:

{
  imports = [ ./general-intel.nix ];

  boot = {
    extraModprobeConfig = ''
      options bbswitch use_acpi_to_detect_card_state=1
    '';
    kernelModules = [ "tpm-rng" ];
  };
}
