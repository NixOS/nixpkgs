{ config, lib, pkgs, ... }:

{
  imports = [
    ../.
    ../../../common/cpu/intel
  ];

  boot = {
    extraModprobeConfig = lib.mkDefault ''
      options bbswitch use_acpi_to_detect_card_state=1
    '';
    # TODO: probably enable tcsd? Is this line necessary?
    kernelModules = [ "tpm-rng" ];
  };
}
