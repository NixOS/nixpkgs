# This module contains the basic configuration for building netboot
# images

{ lib, ... }:

{
  imports = [
    ./netboot.nix

    # Profiles of this basic netboot media
    ../../profiles/base.nix
    ../../profiles/installation-device.nix
  ];

  hardware.enableAllHardware = true;
}
