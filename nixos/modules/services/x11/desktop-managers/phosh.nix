{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.xserver.desktopManager.phosh;
in

{
  options = {
    services.xserver.desktopManager.phosh = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable the Phone Shell.";
      };

      package = mkOption {
        type = types.package;
        default = pkgs.phosh;
        defaultText = literalExpression "pkgs.phosh";
        example = literalExpression "pkgs.phosh";
        description = ''
          Package that should be used for Phosh.
        '';
      };

      user = mkOption {
        description = "The user to run the Phosh service.";
        type = types.str;
        example = "alice";
      };

      group = mkOption {
        description = "The group to run the Phosh service.";
        type = types.str;
        example = "users";
      };
    };
  };

  config = mkIf cfg.enable {
    programs.phosh.enable = true;

    systemd.defaultUnit = "graphical.target";
    # Inspired by https://gitlab.gnome.org/World/Phosh/phosh/-/blob/main/data/phosh.service
    systemd.services.phosh = {
      wantedBy = [ "graphical.target" ];
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/phosh";
        User = cfg.user;
        Group = cfg.group;
        PAMName = "login";
        WorkingDirectory = "~";
        Restart = "always";

        TTYPath = "/dev/tty7";
        TTYReset = "yes";
        TTYVHangup = "yes";
        TTYVTDisallocate = "yes";

        # Fail to start if not controlling the tty.
        StandardInput = "tty-fail";
        StandardOutput = "journal";
        StandardError = "journal";

        # Log this user with utmp, letting it show up with commands 'w' and 'who'.
        UtmpIdentifier = "tty7";
        UtmpMode = "user";
      };
    };
  };
}
