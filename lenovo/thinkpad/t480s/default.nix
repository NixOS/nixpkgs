{ config, lib, pkgs, ... }:

{
  imports = [
    ../../../common/cpu/intel
    ../acpi_call.nix
    ../cpu-throttling-bug.nix
    ../.
  ];
}
