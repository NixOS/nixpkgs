# This module defines a NixOS installation CD that contains X11 and
# GNOME 3.

{ config, lib, pkgs, ... }:

with lib;

{
  imports = [ ./installation-cd-base.nix ];

  services.xserver = {
    enable = true;
    # GDM doesn't start in virtual machines with ISO
    displayManager.slim = {
      enable = true;
      defaultUser = "root";
      autoLogin = true;
    };
    desktopManager.gnome3 = {
      enable = true;
      extraGSettingsOverrides = ''
        [org.gnome.desktop.background]
        show-desktop-icons=true

        [org.gnome.nautilus.desktop]
        trash-icon-visible=false
        volumes-visible=false
        home-icon-visible=false
        network-icon-visible=false
      '';

      extraGSettingsOverridePackages = [ pkgs.gnome3.nautilus ];
    };
  };

  environment.systemPackages =
    [ # Include gparted for partitioning disks.
      pkgs.gparted

      # Include some editors.
      pkgs.vim
      pkgs.bvi # binary editor
      pkgs.joe

      pkgs.glxinfo
    ];

  # Don't start the X server by default.
  services.xserver.autorun = mkForce false;

  # Auto-login as root.
  services.xserver.displayManager.gdm.autoLogin = {
    enable = true;
    user = "root";
  };

  system.activationScripts.installerDesktop = let
    # Must be executable
    desktopFile = pkgs.writeScript "nixos-manual.desktop" ''
      [Desktop Entry]
      Version=1.0
      Type=Link
      Name=NixOS Manual
      URL=${config.system.build.manual.manual}/share/doc/nixos/index.html
      Icon=system-help
    '';

  # use cp and chmod +x, we must be sure the apps are in the nix store though
  in ''
    mkdir -p /root/Desktop
    ln -sfT ${desktopFile} /root/Desktop/nixos-manual.desktop
    cp ${pkgs.gnome3.gnome_terminal}/share/applications/gnome-terminal.desktop /root/Desktop/gnome-terminal.desktop
    chmod a+rx /root/Desktop/gnome-terminal.desktop
    cp ${pkgs.gparted}/share/applications/gparted.desktop /root/Desktop/gparted.desktop
    chmod a+rx /root/Desktop/gparted.desktop
  '';

}
