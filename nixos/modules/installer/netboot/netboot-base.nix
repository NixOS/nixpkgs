# This module contains the basic configuration for building netboot
# images

{ config, lib, pkgs, ... }:

with lib;

{
  imports =
    [ ./netboot.nix

      # Profiles of this basic netboot media
      ../../profiles/all-hardware.nix
      ../../profiles/base.nix
      ../../profiles/installation-device.nix
    ];

  # Allow the user to log in as root without a password.
  users.extraUsers.root.initialHashedPassword = "";
}
