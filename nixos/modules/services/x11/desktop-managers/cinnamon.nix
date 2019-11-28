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

      # session requirements
      cinnamon-screensaver
      # nemo-autostart: provided by nemo
      # nm-applet: TODO
      # cinnamon-killer-daemon: provided by cinnamon-common

      # packages
      nemo
    ];

    environment.pathsToLink = [
      "/share" # TODO: https://github.com/NixOS/nixpkgs/issues/47173
    ];

    services.xserver.desktopManager.session = [{
      name = "cinnamon";
      bgSupport = true;
      start = ''
        ${pkgs.runtimeShell} ${pkgs.cinnamon.cinnamon-session}/bin/cinnamon-session & # cinnamon-session-cinnamon &
        # or cinnamon-session-cinnamon2d for 2d/sw-rendering. how to add?
        waitPID=$!
      '';
    }];
  };
}
