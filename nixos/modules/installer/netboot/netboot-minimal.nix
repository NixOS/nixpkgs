# This module defines a small netboot environment.

{ lib, ... }:

{
  imports = [
    ./netboot-base.nix
    ../../profiles/minimal.nix
  ];

  documentation.man.enable = lib.mkOverride 500 true;
  hardware.enableRedistributableFirmware = lib.mkOverride 70 false;
  system.extraDependencies = lib.mkOverride 70 [];
  networking.wireless.enable = lib.mkOverride 500 false;
}
