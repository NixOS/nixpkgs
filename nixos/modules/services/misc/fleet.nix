{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) types;

  cfg = config.services.fleet;

  settingsFormat = pkgs.formats.yaml { };

  configFile = settingsFormat.generate "fleet.yaml" cfg.settings;
in
{
  options.services.fleet = {
    enable = lib.mkEnableOption "Fleet osquery server";

    package = lib.mkPackageOption pkgs "fleet" { };

    user = lib.mkOption {
      type = types.str;
      description = ''
        The user under which fleet runs.
      '';
      default = "fleet";
    };

    group = lib.mkOption {
      type = types.str;
      description = ''
        The group under which fleet runs.
      '';
      default = "fleet";
    };

    createDatabaseLocally = lib.mkOption {
      type = types.bool;
      description = "Whether to create the MySQL database locally.";
      default = true;
    };

    createRedisLocally = lib.mkOption {
      type = types.bool;
      description = "Whether to create the Redis database locally.";
      default = true;
    };

    settings = lib.mkOption {
      type = types.nullOr (
        types.submodule {
          freeformType = settingsFormat.type;
          options = {
            mysql = {
              protocol = lib.mkOption {
                type = types.nullOr types.str;
                default = null;
                description = "Which protocol to use to connect with the MySQL instance.";
              };

              address = lib.mkOption {
                type = types.nullOr types.str;
                default = null;
                description = "The address of the MySQL server that Fleet should connect to.";
              };

              database = lib.mkOption {
                type = types.nullOr types.str;
                default = "fleet";
                description = "The name of the MySQL database which Fleet will use.";
              };

              username = lib.mkOption {
                type = types.nullOr types.str;
                default = "fleet";
                description = "The username to use when connecting to the MySQL instance.";
              };

              password = lib.mkOption {
                type = types.nullOr types.str;
                default = "fleet";
                description = "The password to use when connecting to the MySQL instance.";
              };
            };

            redis = {
              address = lib.mkOption {
                type = types.nullOr types.str;
                default = null;
                description = "The address of the Redis server that Fleet should connect to.";
              };

              username = lib.mkOption {
                type = types.nullOr types.str;
                default = null;
                description = "The username to use when connecting to the Redis instance.";
              };

              password = lib.mkOption {
                type = types.nullOr types.str;
                default = null;
                description = "The password to use when connecting to the Redis instance.";
              };
            };
          };
        }
      );
      default = { };
      description = ''
        Fleet configuration. Please refer to
        <https://fleetdm.com/docs/configuration/fleet-server-configuration> for details.
      '';
      example = {
        mysql = {
          address = "localhost:3306";
          database = "fleet";
          username = "fleet";
        };
        redis.address = "localhost:6379";
        server.tls = false;
      };
    };

    environmentFile = lib.mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        Environment file to override settings with. Refer to
        <https://fleetdm.com/docs/configuration/fleet-server-configuration>.
      '';
      example = "/var/lib/secrets/fleet-secrets";
    };
  };

  config = lib.mkIf cfg.enable {
    users.users."${cfg.user}" = {
      isSystemUser = true;
      group = cfg.group;
      extraGroups = lib.mkIf cfg.createRedisLocally [ config.services.redis.servers.fleet.group ];
    };

    users.groups."${cfg.group}" = { };

    services.fleet.settings = {
      mysql = lib.mkIf cfg.createDatabaseLocally {
        protocol = "unix";
        address = "/run/mysqld/mysqld.sock";
      };

      redis = lib.mkIf cfg.createRedisLocally {
        address = "localhost:${toString config.services.redis.servers.fleet.port}";
      };
    };

    services.mysql = lib.mkIf cfg.createDatabaseLocally {
      enable = true;
      package = lib.mkDefault pkgs.mysql80;
      ensureDatabases = [ cfg.settings.mysql.database ];
      ensureUsers = [
        {
          name = cfg.settings.mysql.username;
          ensurePermissions."${cfg.settings.mysql.database}.*" = "ALL PRIVILEGES";
        }
      ];
    };

    services.redis.servers.fleet = lib.mkIf cfg.createRedisLocally {
      enable = true;
      port = 6381;
    };

    systemd.services.fleet = {
      wantedBy = [ "multi-user.target" ];
      after = [
        "network-online.target"
      ]
      ++ lib.optionals cfg.createDatabaseLocally [ "mysql.service" ]
      ++ lib.optionals cfg.createRedisLocally [ "redis-fleet.service" ];
      wants = [ "network-online.target" ];
      requires =
        lib.optionals cfg.createDatabaseLocally [ "mysql.service" ]
        ++ lib.optionals cfg.createRedisLocally [ "redis-fleet.service" ];

      preStart = ''
        ${lib.getExe cfg.package} prepare db \
          --config ${configFile} \
          --no-prompt
      '';

      serviceConfig = {
        ExecStart = "${lib.getExe cfg.package} serve --config ${configFile}";
        EnvironmentFile = cfg.environmentFile;
        User = cfg.user;
        Group = cfg.group;
        Restart = "on-failure";
        RestartSec = 5;
        CapabilityBoundingSet = "";
        LockPersonality = true;
        NoNewPrivileges = true;
        MemoryDenyWriteExecute = true;
        PrivateDevices = true;
        PrivateMounts = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProcSubset = "pid";
        ProtectClock = true;
        ProtectControlGroups = "strict";
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "~@clock"
          "~@cpu-emulation"
          "~@debug"
          "~@module"
          "~@mount"
          "~@obsolete"
          "~@privileged"
          "~@raw-io"
          "~@reboot"
          "~@resources"
          "~@swap"
        ];
        UMask = "0077";
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ bddvlpr ];
}
