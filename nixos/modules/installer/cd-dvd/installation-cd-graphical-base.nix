# This module contains the basic configuration for building a graphical NixOS
# installation CD.

{ config, lib, pkgs, ... }:

with lib;

{
  imports = [ ./installation-cd-base.nix ];

  services.xserver = {
    enable = true;

    # Don't start the X server by default.
    autorun = mkForce false;

    # Automatically login as root.
    displayManager.slim = {
      enable = true;
      defaultUser = "root";
      autoLogin = true;
    };

  };

  # Provide networkmanager for easy wireless configuration.
  networking.networkmanager.enable = true;
  networking.wireless.enable = mkForce false;

  # KDE complains if power management is disabled (to be precise, if
  # there is no power management backend such as upower).
  powerManagement.enable = true;

  # Enable sound in graphical iso's.
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.systemWide = true; # Needed since we run plasma as root.

  environment.systemPackages = [
    # Include gparted for partitioning disks.
    pkgs.gparted

    # Include some editors.
    pkgs.vim
    pkgs.bvi # binary editor
    pkgs.joe

    # Firefox for reading the manual.
    pkgs.firefox

    pkgs.glxinfo
  ];

}
