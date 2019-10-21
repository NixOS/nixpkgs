{ config, lib, pkgs, ... }:

{
  imports = [
    ../../../common/cpu/intel
    ../../../common/pc/laptop/acpi_call.nix
    ../.
  ];

  services.throttled.enable = lib.mkDefault true;
}
