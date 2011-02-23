# List all devices which are _not_ detected by nixos-hardware-scan.
# Common devices are enabled by default.
{ config, pkgs, ... }:

with pkgs.lib;

{
  imports =
    [ ../../hardware/network/intel-5000.nix
      ../../hardware/network/intel-6000.nix
    ];

  config = mkDefault {
    # Wireless card firmware
    networking.enableRT73Firmware = true;
  };
}
