# Global configuration for oblogout.

{ config, lib, pkgs, ... }:

with lib;

let cfg = config.programs.oblogout;

in
{
  ###### interface

  options = {

    programs.oblogout = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to install OBLogout and create <filename>/etc/oblogout.conf</filename>.
          See <filename>${pkgs.oblogout}/share/doc/README</filename>.
        '';
      };

      opacity = mkOption {
        type = types.int;
        default = 70;
        description = ''
        '';
      };

      bgcolor = mkOption {
        type = types.str;
        default = "black";
        description = ''
        '';
      };

      buttontheme = mkOption {
        type = types.str;
        default = "simplistic";
        description = ''
        '';
      };

      buttons = mkOption {
        type = types.str;
        default =  "cancel, logout, restart, shutdown, suspend, hibernate";
        description = ''
        '';
      };

      cancel = mkOption {
        type = types.str;
        default =  "Escape";
        description = ''
        '';
      };

      shutdown = mkOption {
        type = types.str;
        default = "S";
        description = ''
        '';
      };

      restart = mkOption {
        type = types.str;
        default = "R";
        description = ''
        '';
      };

      suspend = mkOption {
        type = types.str;
        default = "U";
        description = ''
        '';
      };

      logout = mkOption {
        type = types.str;
        default = "L";
        description = ''
        '';
      };

      lock = mkOption {
        type = types.str;
        default = "K";
        description = ''
        '';
      };

      hibernate = mkOption {
        type = types.str;
        default =  "H";
        description = ''
        '';
      };

      clogout = mkOption {
        type = types.str;
        default = "openbox --exit";
        description = ''
        '';
      };

      clock = mkOption {
        type = types.str;
        default = "";
        description = ''
        '';
      };

      cswitchuser = mkOption {
        type = types.str;
        default = "";
        description = ''
        '';
      };
    };
  };

  ###### implementation

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.oblogout ];

    environment.etc."oblogout.conf".text = ''
      [settings]
      usehal = false

      [looks]
      opacity = ${toString cfg.opacity}
      bgcolor = ${cfg.bgcolor}
      buttontheme = ${cfg.buttontheme}
      buttons = ${cfg.buttons}

      [shortcuts]
      cancel = ${cfg.cancel}
      shutdown = ${cfg.shutdown}
      restart = ${cfg.restart}
      suspend = ${cfg.suspend}
      logout = ${cfg.logout}
      lock = ${cfg.lock}
      hibernate = ${cfg.hibernate}

      [commands]
      shutdown = systemctl poweroff
      restart = systemctl reboot
      suspend = systemctl suspend
      hibernate = systemctl hibernate
      logout = ${cfg.clogout}
      lock = ${cfg.clock}
      switchuser = ${cfg.cswitchuser}
    '';
  };
}
