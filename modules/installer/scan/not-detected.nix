# List all devices which are _not_ detected by nixos-hardware-scan.
# Common devices are enabled by default.
{config, pkgs, ...}:

with pkgs.lib;

{
  config = mkDefault {
    # Wireless card firmware
    networking.enableRT73Firmware = true;
  };
}
