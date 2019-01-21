{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.xserver.desktopManager.gnome-flashback;

  flashbackEnabled = cfg.enableMetacity || length cfg.customSessions > 0;

  flashbackSessions = cfg.customSessions ++ optional cfg.enableMetacity {
    wmName = "metacity";
    wmLabel = "Metacity";
    wmCommand = "${pkgs.gnome3.metacity}/bin/metacity";
  };
in {

  imports = [
    ./gnome-common.nix
  ];

  options = {

    services.xserver.desktopManager.gnome-flashback = {
      enable = mkEnableOption "Enable GNOME 3 desktop manager.";

      enableMetacity = mkOption {
        default = true;
        description = "Enable the standard GNOME Flashback session with Metacity.";
      };

      customSessions = mkOption {
        type = types.listOf (types.submodule {
          options = {
            wmName = mkOption {
              type = types.str;
              description = "The filename-compatible name of the window manager to use.";
              example = "xmonad";
            };

            wmLabel = mkOption {
              type = types.str;
              description = "The pretty name of the window manager to use.";
              example = "XMonad";
            };

            wmCommand = mkOption {
              type = types.str;
              description = "The executable of the window manager to use.";
              example = "\${pkgs.haskellPackages.xmonad}/bin/xmonad";
            };
          };
        });
        default = [];
        description = "Other GNOME Flashback sessions to enable.";
      };
    };

  };

  config = mkIf cfg.enable {
    assertions = singleton {
      assertion = flashbackEnabled;
      message = "No Flashback sessions defined, either add your own in `services.xserver.displayManager.gnome-flashback.customSessions` or do not disable the default one with `enableMetacity = true`.";
    };

    services.xserver.desktopManager.gnome-common.enable = true;

    services.dbus.packages = [ pkgs.gnome3.gnome-screensaver ];

    services.xserver.displayManager.extraSessionFilePackages =
      map (wm: pkgs.gnome3.gnome-flashback.mkSessionForWm {
        inherit (wm) wmName wmLabel wmCommand;
      }) flashbackSessions;

    security.pam.services.gnome-screensaver.enableGnomeKeyring = true;
  };
}
