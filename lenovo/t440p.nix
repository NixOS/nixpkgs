{ config, pkgs, ... }:

{
  imports = [ ./general.nix ];

  boot = {
    extraModprobeConfig = ''
      options bbswitch use_acpi_to_detect_card_state=1
    '';
    kernelModules = [ "kvm-intel" "tpm-rng" ];
  };
}
