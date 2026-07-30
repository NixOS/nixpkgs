# This module defines a NixOS installation CD that contains Plasma 6.

{ lib, pkgs, ... }:

{
  imports = [ ./installation-cd-graphical-calamares.nix ];

  isoImage.edition = lib.mkDefault "plasma6";

  services.desktopManager.plasma6 = {
    enable = true;
    enableQt5Integration = false;
  };

  # Automatically login as nixos.
  services.displayManager = {
    plasma-login-manager.enable = true;
    autoLogin = {
      enable = true;
      user = "nixos";
    };
  };

  environment.plasma6.excludePackages = [
    # Optional wallpapers that add 126 MiB to the graphical installer
    # closure. They will still need to be downloaded when installing a
    # Plasma system, though.
    pkgs.kdePackages.plasma-workspace-wallpapers
  ];

  # Avoid bundling an entire MariaDB installation on the ISO.
  programs.kde-pim.enable = false;

  systemd.tmpfiles.settings."10-installer-desktop" =
    let
      # Comes from documentation.nix when xserver and nixos.enable are true.
      manualDesktopFile = "/run/current-system/sw/share/applications/nixos-manual.desktop";
    in
    {
      "/home/nixos/Desktop".d = {
        user = "nixos";
        group = "users";
        mode = "0755";
      };
      "/home/nixos/Desktop/nixos-manual.desktop"."L+".argument = manualDesktopFile;
      "/home/nixos/Desktop/gparted.desktop"."L+".argument =
        "${pkgs.gparted}/share/applications/gparted.desktop";
      "/home/nixos/Desktop/calamares.desktop"."L+".argument =
        "${pkgs.calamares-nixos}/share/applications/calamares.desktop";
    };

}
