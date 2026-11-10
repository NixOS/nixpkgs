{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.flexget;
  pkg = cfg.package;
  ymlFile = pkgs.writeText "flexget.yml" ''
    ${cfg.config}

    ${lib.optionalString cfg.systemScheduler "schedules: no"}
  '';
  configFile = "${toString cfg.homeDir}/flexget.yml";
in
{
  options = {
    services.flexget = {
      enable = lib.mkEnableOption "FlexGet daemon";

      package = lib.mkPackageOption pkgs "flexget" { };

      user = lib.mkOption {
        default = "deluge";
        example = "some_user";
        type = lib.types.str;
        description = "The user under which to run flexget.";
      };

      homeDir = lib.mkOption {
        default = "/var/lib/deluge";
        example = "/home/flexget";
        type = lib.types.path;
        description = "Where files live.";
      };

      interval = lib.mkOption {
        default = "10m";
        example = "1h";
        type = lib.types.str;
        description = "When to perform a {command}`flexget` run. See {command}`man 7 systemd.time` for the format.";
      };

      systemScheduler = lib.mkOption {
        default = true;
        example = false;
        type = lib.types.bool;
        description = "When true, execute the runs via the flexget-runner.timer. If false, you have to specify the settings yourself in the YML file.";
      };

      config = lib.mkOption {
        default = "";
        type = lib.types.lines;
        description = "The YAML configuration for FlexGet.";
      };
    };
  };

  config = lib.mkIf cfg.enable {

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

      flexget-runner = lib.mkIf cfg.systemScheduler {
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

    systemd.timers.flexget-runner = lib.mkIf cfg.systemScheduler {
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
