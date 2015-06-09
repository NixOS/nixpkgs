# This module defines a small NixOS installation CD.  It does not
# contain any graphical stuff.

{ config, pkgs, lib, ... }:

{
  imports =
    [ ./installation-cd-base.nix
      ../../profiles/minimal.nix
    ];

  # Enable in installer, even if minimal profile disables it
  services.nixosManual.enable = lib.mkOverride 999 true;
}
