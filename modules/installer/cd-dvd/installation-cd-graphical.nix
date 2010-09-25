# This module defines a NixOS installation CD that contains X11 and
# KDE 4.

{config, pkgs, ...}:

{
  require = [
    ./installation-cd-base.nix
    ../../profiles/graphical.nix
  ];
}
