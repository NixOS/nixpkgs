# This module contains the basic configuration for building a graphical NixOS
# installation CD.

{ ... }:

{
  imports =
    [ ./installation-cd-base.nix

      ../../profiles/graphical-base.nix
    ];
}
