{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf mkOption mkPackageOption types mdDoc;

  cfg = config.services.scrutiny-collector;
in
{
  options.services.scrutiny-collector = {
    enable = mkEnableOption "scrutiny-collector";

    package = mkPackageOption pkgs "scrutiny-collector" { };

    config-path = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = "Specify the path to the devices file";
    };

    configuration = mkOption {
      type = types.nullOr (pkgs.formats.yaml { }).type;
      default = null;
      description = "Specify the configuration for the Scrutiny collector in Nix.";
    };

    api-endpoint = mkOption {
      type = types.str;
      default = "http://localhost:8080";
      description = "The api server endpoint";
    };

    log-file = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = "Path to file for logging. Leave empty to use STDOUT";
    };

    debug = mkEnableOption "debug logging";

    host-id = mkOption {
      type = types.str;
      default = config.networking.hostName;
      defaultText = lib.literalExpression "config.networking.hostName";
      description = "Host identifier/label, used for grouping devices";
    };

    calendar = mkOption {
      type = types.str;
      default = "*-*-* 00:00:00";
      description = ''
        Configured when to run the service systemd unit (DayOfWeek Year-Month-Day Hour:Minute:Second).
      '';
    };

    user = mkOption {
      type = types.str;
      default = "scrutiny-collector";
      description = "User under which the scrutiny collector service runs.";
    };

    group = mkOption {
      type = types.str;
      default = "scrutiny-collector";
      description = "Group under which the scrutiny collector service runs.";
    };
  };

  config = mkIf cfg.enable
    (
      let
        configFile =
          if cfg.configuration != null then
            (pkgs.writeTextFile {
              name = "collector.yaml";
              text = (lib.generators.toYAML { } cfg.configuration);
            })
          else null;
        createUser = cfg.user == "scrutiny-collector";
      in
      {
        environment.systemPackages = [ cfg.package ];

        users.groups.${cfg.group} = lib.mkIf createUser { };
        users.users.${cfg.user} = lib.mkIf createUser {
          description = "Scrutiny Collector Service User";
          createHome = false;
          isSystemUser = true;
          group = cfg.group;
        };
        users.users.${cfg.user}.extraGroups = [ "disk" ];

        systemd = {
          timers.scrutiny-collector = {
            description = "Scrutiny Collector";
            wantedBy = [ "timers.target" ];

            timerConfig = {
              OnCalendar = cfg.calendar;
              AccuracySec = "5m";
              Unit = "scrutiny-collector.service";
            };
          };

          services.scrutiny-collector = {
            description = "Scrutiny Collector";

            serviceConfig =
              let
                args = lib.cli.toGNUCommandLineShell { } {
                  inherit (cfg) api-endpoint log-file debug host-id;
                  config = if cfg.config-path != null then cfg.config-path else configFile;
                };
              in
              {
                ExecStart = "${lib.getExe cfg.package} run ${args}";
                User = cfg.user;
                PrivateTmp = true;
                ProtectHome = true;
                ProtectSystem = "full";
                NoNewPrivileges = true;
              };
          };
        };
      }
    );
}
