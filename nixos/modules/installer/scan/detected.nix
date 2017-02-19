# List all devices which are detected by nixos-generate-config.
# Common devices are enabled by default.
{ config, lib, pkgs, ... }:

with lib;

{
  config = mkDefault {
    # Wireless card firmware
    networking.enableIntel2200BGFirmware = true;
    networking.enableIntel3945ABGFirmware = true;
  };
}
