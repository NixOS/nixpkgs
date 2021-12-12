# This module defines a NixOS installation CD that contains X11 and
# Plasma 5.

{ ... }:

{
  imports =
    [ ./installation-cd-graphical-base.nix

      ../../profiles/graphical-plasma5.nix
    ];

  isoImage.edition = "plasma5";
}
