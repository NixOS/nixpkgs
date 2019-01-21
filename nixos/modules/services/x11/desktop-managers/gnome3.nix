{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.xserver.desktopManager.gnome3;
in {

  imports = [
    ./gnome-common.nix
  ];

  options = {

    services.xserver.desktopManager.gnome3 = {
      enable = mkOption {
        default = false;
        description = "Enable Gnome 3 desktop manager.";
      };
    };
  };

  config = mkIf cfg.enable {
    services.xserver.desktopManager.gnome-common.enable = true;
    services.xserver.desktopManager.gnome3.sessionPath = [ pkgs.gnome3.gnome-shell pkgs.gnome3.gnome-shell-extensions ];

    # Enable helpful DBus services.
    services.xserver.displayManager.extraSessionFilePackages = [ pkgs.gnome3.gnome-session ];
  };
}
