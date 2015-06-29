# This module defines a NixOS installation CD that contains X11 and
# KDE 4.

{ config, lib, pkgs, ... }:

with lib;

{
  imports = [ ./installation-cd-base.nix ../../profiles/graphical.nix ];

  # Provide wicd for easy wireless configuration.
  #networking.wicd.enable = true;

  environment.systemPackages =
    [ # Include gparted for partitioning disks.
      pkgs.gparted

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

  # Auto-login as root.
  services.xserver.displayManager.kdm.extraConfig =
    ''
      [X-*-Core]
      AllowRootLogin=true
      AutoLoginEnable=true
      AutoLoginUser=root
      AutoLoginPass=""
    '';

  # Custom kde-workspace adding some icons on the desktop

  system.activationScripts.installerDesktop = let
    openManual = pkgs.writeScript "nixos-manual.sh" ''
      #!${pkgs.stdenv.shell}
      cd ${config.system.build.manual.manual}/share/doc/nixos/
      konqueror ./index.html
    '';

    desktopFile = pkgs.writeText "nixos-manual.desktop" ''
      [Desktop Entry]
      Version=1.0
      Type=Application
      Name=NixOS Manual
      Exec=${openManual}
      Icon=konqueror
    '';

  in ''
    mkdir -p /root/Desktop
    ln -sfT ${desktopFile} /root/Desktop/nixos-manual.desktop
    ln -sfT ${pkgs.kde4.konsole}/share/applications/kde4/konsole.desktop /root/Desktop/konsole.desktop
    ln -sfT ${pkgs.gparted}/share/applications/gparted.desktop /root/Desktop/gparted.desktop
  '';

  services.xserver.desktopManager.kde4.kdeWorkspacePackage = let
    pkg = pkgs.kde4.kde_workspace;

    plasmaInit = pkgs.writeText "00-defaultLayout.js" ''
      loadTemplate("org.kde.plasma-desktop.defaultPanel")

      for (var i = 0; i < screenCount; ++i) {
        var desktop = new Activity
        desktop.name = i18n("Desktop")
        desktop.screen = i
        desktop.wallpaperPlugin = 'image'
        desktop.wallpaperMode = 'SingleImage'

        var folderview = desktop.addWidget("folderview");
        folderview.writeConfig("url", "desktop:/");

        //Create more panels for other screens
        if (i > 0){
          var panel = new Panel
          panel.screen = i
          panel.location = 'bottom'
          panel.height = screenGeometry(i).height > 1024 ? 35 : 27
          var tasks = panel.addWidget("tasks")
          tasks.writeConfig("showOnlyCurrentScreen", true);
        }
      }
    '';

  in
    pkgs.stdenv.mkDerivation {
      inherit (pkg) name meta;

      buildCommand = ''
        mkdir -p $out
        cp -prf ${pkg}/* $out/
        chmod a+w $out/share/apps/plasma-desktop/init
        cp -f ${plasmaInit} $out/share/apps/plasma-desktop/init/00-defaultLayout.js
      '';
    };

}
