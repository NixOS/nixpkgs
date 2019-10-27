# This module defines a NixOS installation CD that contains X11 and
# Plasma 5.

{ config, lib, pkgs, ... }:

with lib;

{
  imports = [ ./installation-cd-graphical-base.nix ];

  services.xserver = {
    desktopManager.plasma5 = {
      enable = true;
      enableQt4Support = false;
    };
  };

  environment.systemPackages = with pkgs; [
    # Graphical text editor
    kate
  ];

  system.activationScripts.installerDesktop = let

    # Comes from documentation.nix when xserver and nixos.enable are true.
    manualDesktopFile = "/run/current-system/sw/share/applications/nixos-manual.desktop";

    homeDir = "/home/nixos/";
    desktopDir = homeDir + "Desktop/";

  in ''
    mkdir -p ${desktopDir}
    chown nixos ${homeDir} ${desktopDir}

    ln -sfT ${manualDesktopFile} ${desktopDir + "nixos-manual.desktop"}
    ln -sfT ${pkgs.gparted}/share/applications/gparted.desktop ${desktopDir + "gparted.desktop"}
    ln -sfT ${pkgs.konsole}/share/applications/org.kde.konsole.desktop ${desktopDir + "org.kde.konsole.desktop"}
  '';

}
