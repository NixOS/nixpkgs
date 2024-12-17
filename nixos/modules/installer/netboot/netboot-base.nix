# This module contains the basic configuration for building netboot
# images

{ lib, ... }:

with lib;

{
  imports = [
    ./netboot.nix

    # Profiles of this basic netboot media
    ../../profiles/all-hardware.nix
    ../../profiles/base.nix
    ../../profiles/installation-device.nix
  ];
}
