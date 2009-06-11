# This module defines a NixOS installation CD that contains X11 and
# KDE 4.

{config, pkgs, ...}:

{
  require = [./installation-cd-base.nix];

  services.xserver = {
    enable = true;
    autorun = false;
    defaultDepth = 16;
    desktopManager.default = "kde4";
    desktopManager.kde4.enable = true;
  };
}
