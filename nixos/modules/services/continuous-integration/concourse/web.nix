{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.concourse.web;
in
{
  meta.maintainers = with lib.maintainers; [ lenianiva ];

  options.services.concourse.web = {
    enable = lib.mkEnableOption "Concourse web server";
    package = lib.mkPackageOption pkgs "concourse" { };
    user = lib.mkOption {
      type = lib.types.str;
      default = "concourse";
      description = "User account under which concourse runs.";
    };
    sessionSigningKey = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Path to session signing private key";
    };
    autoRestart = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Automatically restart failed servers";
    };
    network = {
      peerAddress = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Address to reach this `web` node from another `web` node";
      };
      bindPort = lib.mkOption {
        type = lib.types.port;
        default = 8080;
        description = "Web interface bind port";
      };
      externalUrl = lib.mkOption {
        type = lib.types.str;
        description = "URL visible from the outside accessible by Concourse users";
      };
      apiMaxConns = lib.mkOption {
        type = lib.types.int;
        default = 10;
        description = "Maximum number of API connections";
      };
      backendMaxConns = lib.mkOption {
        type = lib.types.int;
        default = 50;
        description = "Maximum number of backend connections";
      };
      clusterName = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Name of this cluster";
      };
    };
    postgres = {
      host = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Host of postgresql database";
      };
      port = lib.mkOption {
        type = lib.types.nullOr lib.types.port;
        default = null;
        description = "Port of postgresql database";
        example = "config.services.postgresql.settings.port";
      };
      socket = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = "/var/run/postgresql";
        description = "Socket address for locally hosted postgres. Set this to `null` to use host and port.";
      };
      database = lib.mkOption {
        type = lib.types.str;
        default = "atc";
        description = "Database name";
      };
      user = lib.mkOption {
        type = lib.types.str;
        default = "concourse";
        description = "Database user name";
      };
      password = lib.mkOption {
        type = lib.types.str;
        default = "concourse";
        description = "Database user password";
      };
    };
    tsa = {
      bindIP = lib.mkOption {
        type = lib.types.str;
        default = "0.0.0.0";
        description = "TSA binding ip";
      };
      bindPort = lib.mkOption {
        type = lib.types.nullOr lib.types.port;
        default = 2222;
        description = "TSA binding port";
      };
      hostKey = lib.mkOption {
        type = lib.types.str;
        description = "Path to TSA host key";
      };
      authorizedKeys = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Path to TSA authorized keys";
      };
    };
    args = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Extra options to pass to concourse executable";
    };
    environment = lib.mkOption {
      default = { };
      type = lib.types.attrsOf lib.types.str;
      example = lib.literalExpression ''
        {
          CONCOURSE_POSTGRES_USER=my-user
          CONCOURSE_POSTGRES_PASSWORD=my-password
        }
      '';
      description = "Concourse web server environment variables [documentation](https://concourse-ci.org/concourse-web.html#web-running)";
    };
    environmentFile = lib.mkOption {
      type = with lib.types; coercedTo path (f: [ f ]) (listOf path);
      default = [ ];
      example = [ "/run/concourse-web.env" ];
      description = ''
        File to load environment variables
        from. This is helpful for specifying secrets.
        Example content of environmentFile:
        ```
        CONCOURSE_POSTGRES_PASSWORD=********
        ```
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services = {
      concourse-web = {
        description = "Concourse CI web";
        after = [
          "network.target"
          "postgresql.target"
        ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          User = cfg.user;
          WorkingDirectory = "%S/concourse-web";
          StateDirectory = "concourse-web";
          StateDirectoryMode = "0700";
          UMask = "0007";
          ConfigurationDirectory = "concourse-web";
          EnvironmentFile = cfg.environmentFile;
          ExecStart = "${cfg.package}/bin/concourse web ${builtins.concatStringsSep " " cfg.args}";
          Restart = if cfg.autoRestart then "on-failure" else "no";
          RestartSec = 15;
          CapabilityBoundingSet = "";
          # Security
          NoNewPrivileges = true;
          # Sandboxing
          ProtectSystem = "strict";
          ProtectHome = true;
          PrivateTmp = true;
          PrivateDevices = true;
          PrivateUsers = true;
          ProtectHostname = true;
          ProtectClock = true;
          ProtectKernelTunables = true;
          ProtectKernelModules = true;
          ProtectKernelLogs = true;
          ProtectControlGroups = true;
          RestrictAddressFamilies = [ "AF_UNIX AF_INET AF_INET6" ];
          LockPersonality = true;
          MemoryDenyWriteExecute = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          PrivateMounts = true;
          # System Call Filtering
          SystemCallArchitectures = "native";
          SystemCallFilter = "~@clock @privileged @cpu-emulation @debug @keyring @module @mount @obsolete @raw-io @reboot @setuid @swap";
        };
        environment = {
          CONCOURSE_BIND_PORT = toString cfg.network.bindPort;
          CONCOURSE_PEER_ADDRESS = cfg.network.peerAddress;
          CONCOURSE_EXTERNAL_URL = cfg.network.externalUrl;
          CONCOURSE_API_MAX_CONNS = lib.mapNullable toString cfg.network.apiMaxConns;
          CONCOURSE_BACKEND_MAX_CONNS = lib.mapNullable toString cfg.network.backendMaxConns;
          CONCOURSE_CLUSTER_NAME = cfg.network.clusterName;

          CONCOURSE_POSTGRES_PORT = lib.mapNullable toString cfg.postgres.port;
          CONCOURSE_POSTGRES_SOCKET = cfg.postgres.socket;
          CONCOURSE_POSTGRES_DATABASE = cfg.postgres.database;
          CONCOURSE_POSTGRES_USER = cfg.postgres.user;
          CONCOURSE_POSTGRES_PASSWORD = cfg.postgres.password;
          CONCOURSE_SESSION_SIGNING_KEY = cfg.sessionSigningKey;
          CONCOURSE_TSA_BIND_IP = cfg.tsa.bindIP;
          CONCOURSE_TSA_BIND_PORT = toString cfg.tsa.bindPort;
          CONCOURSE_TSA_HOST_KEY = cfg.tsa.hostKey;
          CONCOURSE_TSA_AUTHORIZED_KEYS = cfg.tsa.authorizedKeys;
        }
        // cfg.environment;
      };
    };
  };

}
