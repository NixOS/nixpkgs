{ config, lib, pkgs, ... }:

{
  imports = [
    ../.
    ../../../common/cpu/intel
    ../../../common/pc/laptop/acpi_call.nix
  ];

  boot = {
    # TODO: probably enable tcsd? Is this line necessary?
    kernelModules = [ "tpm-rng" ];
  };
}
