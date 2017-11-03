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
          Opacity percentage of Cairo rendered backgrounds.
        '';
      };

      bgcolor = mkOption {
        type = types.str;
        default = "black";
        description = ''
          Colour name or hex code (#ffffff) of the background color.
        '';
      };

      buttontheme = mkOption {
        type = types.str;
        default = "simplistic";
        description = ''
          Icon theme for the buttons, must be in the themes folder of
          the package, or in
          <filename>~/.themes/&lt;name&gt;/oblogout/</filename>.
        '';
      };

      buttons = mkOption {
        type = types.str;
        default =  "cancel, logout, restart, shutdown, suspend, hibernate";
        description = ''
          List and order of buttons to show.
        '';
      };

      cancel = mkOption {
        type = types.str;
        default =  "Escape";
        description = ''
          Cancel logout/shutdown shortcut.
        '';
      };

      shutdown = mkOption {
        type = types.str;
        default = "S";
        description = ''
          Shutdown shortcut.
        '';
      };

      restart = mkOption {
        type = types.str;
        default = "R";
        description = ''
          Restart shortcut.
        '';
      };

      suspend = mkOption {
        type = types.str;
        default = "U";
        description = ''
          Suspend shortcut.
        '';
      };

      logout = mkOption {
        type = types.str;
        default = "L";
        description = ''
          Logout shortcut.
        '';
      };

      lock = mkOption {
        type = types.str;
        default = "K";
        description = ''
          Lock session shortcut.
        '';
      };

      hibernate = mkOption {
        type = types.str;
        default =  "H";
        description = ''
          Hibernate shortcut.
        '';
      };

      clogout = mkOption {
        type = types.str;
        default = "openbox --exit";
        description = ''
          Command to logout.
        '';
      };

      clock = mkOption {
        type = types.str;
        default = "";
        description = ''
          Command to lock screen.
        '';
      };

      cswitchuser = mkOption {
        type = types.str;
        default = "";
        description = ''
          Command to switch user.
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
