# This module defines a NixOS configuration with the Plasma 5 desktop.
# It's used by the graphical installation CD.

{ pkgs, ... }:

{
  services.xserver = {
    enable = true;
    desktopManager.plasma5.enable = true;
  };

  services = {
    displayManager.sddm.enable = true;
    libinput.enable = true; # for touchpad support on many laptops
  };

  environment.systemPackages = [
    pkgs.mesa-demos
    pkgs.firefox
  ];
}
