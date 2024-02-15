{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.flexget;
  pkg = cfg.package;
  ymlFile = pkgs.writeText "flexget.yml" ''
    ${cfg.config}

    ${optionalString cfg.systemScheduler "schedules: no"}
'';
  configFile = "${toString cfg.homeDir}/flexget.yml";
in {
  options = {
    services.flexget = {
      enable = mkEnableOption (lib.mdDoc "FlexGet daemon");

      package = mkPackageOption pkgs "flexget" {};

      user = mkOption {
        default = "deluge";
        example = "some_user";
        type = types.str;
        description = lib.mdDoc "The user under which to run flexget.";
      };

      homeDir = mkOption {
        default = "/var/lib/deluge";
        example = "/home/flexget";
        type = types.path;
        description = lib.mdDoc "Where files live.";
      };

      interval = mkOption {
        default = "10m";
        example = "1h";
        type = types.str;
        description = lib.mdDoc "When to perform a {command}`flexget` run. See {command}`man 7 systemd.time` for the format.";
      };

      systemScheduler = mkOption {
        default = true;
        example = false;
        type = types.bool;
        description = lib.mdDoc "When true, execute the runs via the flexget-runner.timer. If false, you have to specify the settings yourself in the YML file.";
      };

      config = mkOption {
        default = "";
        type = types.lines;
        description = lib.mdDoc "The YAML configuration for FlexGet.";
      };
    };
  };

  config = mkIf cfg.enable {

    environment.systemPackages = [ pkg ];

    systemd.services = {
      flexget = {
        description = "FlexGet Daemon";
        path = [ pkg ];
        serviceConfig = {
          User = cfg.user;
          ExecStartPre = "${pkgs.coreutils}/bin/install -m644 ${ymlFile} ${configFile}";
          ExecStart = "${pkg}/bin/flexget -c ${configFile} daemon start";
          ExecStop = "${pkg}/bin/flexget -c ${configFile} daemon stop";
          ExecReload = "${pkg}/bin/flexget -c ${configFile} daemon reload";
          Restart = "on-failure";
          PrivateTmp = true;
          WorkingDirectory = toString cfg.homeDir;
        };
        wantedBy = [ "multi-user.target" ];
      };

      flexget-runner = mkIf cfg.systemScheduler {
        description = "FlexGet Runner";
        after = [ "flexget.service" ];
        wants = [ "flexget.service" ];
        serviceConfig = {
          User = cfg.user;
          ExecStart = "${pkg}/bin/flexget -c ${configFile} execute";
          PrivateTmp = true;
          WorkingDirectory = toString cfg.homeDir;
        };
      };
    };

    systemd.timers.flexget-runner = mkIf cfg.systemScheduler {
      description = "Run FlexGet every ${cfg.interval}";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = "5m";
        OnUnitInactiveSec = cfg.interval;
        Unit = "flexget-runner.service";
      };
    };
  };
}
