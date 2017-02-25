# This module defines a NixOS installation CD that contains X11 and
# KDE 5.

{ config, lib, pkgs, ... }:

with lib;

{
  imports = [ ./installation-cd-base.nix ];

  services.xserver = {
    enable = true;

    # Automatically login as root.
    displayManager.slim = {
      enable = true;
      defaultUser = "root";
      autoLogin = true;
    };

    desktopManager.kde5 = {
      enable = true;
      enableQt4Support = false;
    };

    # Enable touchpad support for many laptops.
    synaptics.enable = true;
  };

  environment.systemPackages =
    [ pkgs.glxinfo

      # Include gparted for partitioning disks.
      pkgs.gparted

      # Firefox for reading the manual.
      pkgs.firefox

      # Include some editors.
      pkgs.vim
      pkgs.bvi # binary editor
      pkgs.joe
    ];

  # Provide networkmanager for easy wireless configuration.
  networking.networkmanager.enable = true;
  networking.wireless.enable = mkForce false;

  # KDE complains if power management is disabled (to be precise, if
  # there is no power management backend such as upower).
  powerManagement.enable = true;

  # Don't start the X server by default.
  services.xserver.autorun = mkForce false;

  system.activationScripts.installerDesktop = let
    desktopFile = pkgs.writeText "nixos-manual.desktop" ''
      [Desktop Entry]
      Version=1.0
      Type=Application
      Name=NixOS Manual
      Exec=firefox ${config.system.build.manual.manual}/share/doc/nixos/index.html
      Icon=text-html
    '';

  in ''
    mkdir -p /root/Desktop
    ln -sfT ${desktopFile} /root/Desktop/nixos-manual.desktop
    ln -sfT ${pkgs.kdeApplications.konsole}/share/applications/org.kde.konsole.desktop /root/Desktop/org.kde.konsole.desktop
    ln -sfT ${pkgs.gparted}/share/applications/gparted.desktop /root/Desktop/gparted.desktop
  '';

}
