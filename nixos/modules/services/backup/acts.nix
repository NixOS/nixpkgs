{ config, lib, pkgs, ... }:

let
  cfg = config.services.acts;
  pkg = pkgs.acts;
  user = "acts";
  group = "acts";

  inherit (lib) mkEnableOption mkIf mkOption types;
in
  {
    # interface
    options = {
      services.acts = {
        enable = mkEnableOption "acts";

        calendar = mkOption {
          type = types.str;
          default = "daily";
          description = ''
            Configures when to run the backups using systemd.time syntax
          '';
        };
      };
    };

    # implementation
    config = {
      systemd.services.acts = {
        description= "acts tarsnap backup service";
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkg}/bin/acts";
        };
      };

      systemd.timers.acts = {
        description = "acts timer";
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnCalendar = cfg.calendar;
          Persistent = "true";
        };
      };
    };
  }
