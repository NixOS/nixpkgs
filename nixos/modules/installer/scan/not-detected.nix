# List all devices which are _not_ detected by nixos-hardware-scan.
# Common devices are enabled by default.
{ config, lib, pkgs, ... }:

with lib;

{
  hardware.enableAllFirmware = true;
}
