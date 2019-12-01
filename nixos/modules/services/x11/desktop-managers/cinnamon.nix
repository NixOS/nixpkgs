{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.xserver.desktopManager.cinnamon;
in

{

  options = {
    services.xserver.desktopManager.cinnamon = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable the Cinnamon desktop environment.";
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs.cinnamon // pkgs; [
      # common-files
      cinnamon-common
      cinnamon-session
      cinnamon-desktop

      # utils needed by some scripts
      pkgs.killall

      # session requirements
      cinnamon-screensaver
      # nemo-autostart: provided by nemo
      pkgs.gnome3.networkmanagerapplet
      # cinnamon-killer-daemon: provided by cinnamon-common

      # packages
      nemo
      cinnamon-control-center
      cinnamon-settings-daemon

      # theme
      pkgs.gnome3.adwaita-icon-theme
      pkgs.hicolor-icon-theme
      pkgs.gnome3.gnome-themes-extra
      pkgs.gnome3.gtk
    ];

    environment.pathsToLink = [
      "/share" # TODO: https://github.com/NixOS/nixpkgs/issues/47173
    ];

    fonts.fonts = with pkgs; [
      cantarell-fonts
      dejavu_fonts
      source-code-pro # Default monospace font in 3.32
      source-sans-pro
    ];

    services.xserver.desktopManager.session = [
      {
        name = "cinnamon";
        bgSupport = true;
        start = ''
          ${pkgs.runtimeShell} ${pkgs.cinnamon.cinnamon-common}/bin/cinnamon-session-cinnamon &
          waitPID=$!
        '';
      }
      {
        name = "cinnamon2d";
        bgSupport = true;
        start = ''
          ${pkgs.runtimeShell} ${pkgs.cinnamon.cinnamon-common}/bin/cinnamon-session-cinnamon2d &
          waitPID=$!
        '';
      }
    ];
  };
}
