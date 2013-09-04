# This module defines a small NixOS installation CD.  It does not
# contain any graphical stuff.

{ config, pkgs, ... }:

{
  imports =
    [ ./installation-cd-base.nix
      ../../profiles/minimal.nix
    ];
}
