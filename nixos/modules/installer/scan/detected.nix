# List all devices which are detected by nixos-generate-config.
# Common devices are enabled by default.
{ config, lib, pkgs, ... }:

with lib;

{
  config = mkDefault {
    # Common firmware, i.e. for wifi cards
    hardware.enableRedistributableFirmware = true;
  };
}
