{ nixos, pkgs, lib, config, stdenv, ... }:
{
  imports = [
    ../../../common/cpu/intel
    ../../../common/pc/laptop/acpi_call.nix
    ../.
  ];

  services.throttled.enable = lib.mkDefault true;
}
