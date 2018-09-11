# This module defines a NixOS installation CD that contains X11 and
# Plasma5.

{ config, lib, pkgs, ... }:

with lib;

{
  imports = [ ./installation-cd-graphical-base.nix ];

  services.xserver = {
    desktopManager.plasma5 = {
      enable = true;
      enableQt4Support = false;
    };

    # Enable touchpad support for many laptops.
    synaptics.enable = true;
  };

  environment.systemPackages = with pkgs; [
    # Graphical text editor
    kate
  ];

  system.activationScripts.installerDesktop = let

    manualDesktopFile = pkgs.writeScript "nixos-manual.desktop" ''
      [Desktop Entry]
      Version=1.0
      Type=Application
      Name=NixOS Manual
      Exec=firefox ${config.system.build.manual.manual}/share/doc/nixos/index.html
      Icon=text-html
    '';

  in ''
    mkdir -p /root/Desktop
    ln -sfT ${manualDesktopFile} /root/Desktop/nixos-manual.desktop
    ln -sfT ${pkgs.konsole}/share/applications/org.kde.konsole.desktop /root/Desktop/org.kde.konsole.desktop
    ln -sfT ${pkgs.gparted}/share/applications/gparted.desktop /root/Desktop/gparted.desktop
  '';

}
