# This module defines a NixOS configuration that contains X11 and
# KDE 4.
{config, pkgs, ...}:

{
  require = [
    ./base.nix
  ];

  services.xserver = {
    enable = true;
    autorun = true;
    defaultDepth = 24;
    desktopManager.default = "kde4";
    desktopManager.kde4.enable = true;
  };
}
