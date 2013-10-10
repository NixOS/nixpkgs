# List all devices which are detected by nixos-hardware-scan.
# Common devices are enabled by default.
{config, pkgs, ...}:

with pkgs.lib;

{
  config = mkDefault {
    # Wireless card firmware
    networking.enableIntel2200BGFirmware = true;
    networking.enableIntel3945ABGFirmware = true;
  };
}
