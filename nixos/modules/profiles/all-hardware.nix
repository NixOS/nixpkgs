# This module enables all hardware supported by NixOS: i.e., all
# firmware is included, and all devices from which one may boot are
# enabled in the initrd.  Its primary use is in the NixOS installation
# CDs.

{ pkgs, lib,... }:
let
  platform = pkgs.stdenv.hostPlatform;
in
{
  # Include lots of firmware.
  hardware.enableRedistributableFirmware = true;

  imports =
    [ ../hardware/network/zydas-zd1211.nix ];

}
