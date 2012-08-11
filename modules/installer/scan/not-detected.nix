# List all devices which are _not_ detected by nixos-hardware-scan.
# Common devices are enabled by default.
{ config, pkgs, ... }:

with pkgs.lib;

{
  imports =
    [
      ../../hardware/network/intel-4965agn.nix
      ../../hardware/network/intel-5000.nix
      ../../hardware/network/intel-5150.nix
      ../../hardware/network/intel-6000.nix
      ../../hardware/network/intel-6000g2a.nix
      ../../hardware/network/intel-6000g2b.nix
      ../../hardware/network/broadcom-43xx.nix
    ];

  config = mkDefault {
    # That wireless card firmware not enabled because the corresponding
    # build expression 'rt73fw' is broken.
    networking.enableRalinkFirmware = false;
  };
}
