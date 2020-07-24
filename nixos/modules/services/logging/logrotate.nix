{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.logrotate;

  pathOptions = {
    options = {
      path = mkOption {
        type = types.str;
        description = "The path to log files to be rotated";
      };
      user = mkOption {
        type = types.str;
        description = "The user account to use for rotation";
      };
      group = mkOption {
        type = types.str;
        description = "The group to use for rotation";
      };
      frequency = mkOption {
        type = types.enum [
          "daily" "weekly" "monthly" "yearly"
        ];
        default = "daily";
        description = "How often to rotate the logs";
      };
      keep = mkOption {
        type = types.int;
        default = 20;
        description = "How many rotations to keep";
      };
      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = "Extra logrotate config options for this path";
      };
    };
  };

  pathConfig = options: ''
    "${options.path}" {
      su ${options.user} ${options.group}
      ${options.frequency}
      missingok
      notifempty
      rotate ${toString options.keep}
      ${options.extraConfig}
    }
  '';

  configFile = pkgs.writeText "logrotate.conf" (
    (concatStringsSep "\n" ((map pathConfig cfg.paths) ++ [cfg.extraConfig]))
  );

in
{
  imports = [
    (mkRenamedOptionModule [ "services" "logrotate" "config" ] [ "services" "logrotate" "extraConfig" ])
  ];

  options = {
    services.logrotate = {
      enable = mkEnableOption "the logrotate systemd service";

      paths = mkOption {
        type = types.listOf (types.submodule pathOptions);
        default = [];
        description = "List of attribute sets with paths to rotate";
        example = {
          "/var/log/myapp/*.log" = {
            user = "myuser";
            group = "mygroup";
            rotate = "weekly";
            keep = 5;
          };
        };
      };

      extraConfig = mkOption {
        default = "";
        type = types.lines;
        description = ''
          Extra contents to add to the logrotate config file.
          See https://linux.die.net/man/8/logrotate
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.logrotate = {
      description   = "Logrotate Service";
      wantedBy      = [ "multi-user.target" ];
      startAt       = "*-*-* *:05:00";

      serviceConfig.Restart = "no";
      serviceConfig.User    = "root";
      script = ''
        exec ${pkgs.logrotate}/sbin/logrotate ${configFile}
      '';
    };
  };
}
