# This module defines a small NixOS installation CD.  It does not
# contain any graphical stuff.

{ ... }:

{
  imports =
    [ ./installation-cd-base.nix
    ];
}
