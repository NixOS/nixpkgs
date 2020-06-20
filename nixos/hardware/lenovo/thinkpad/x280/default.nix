{ config, pkgs, lib, ... }:

{
  imports = [
    ../.
    ../../../common/cpu/intel
    ../../../common/pc/laptop/acpi_call.nix
    ../../../common/pc/laptop/ssd/default.nix
  ];

  services.throttled.enable = lib.mkDefault true;
}
