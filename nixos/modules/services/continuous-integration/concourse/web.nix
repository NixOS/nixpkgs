{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.concourse-web;
in
{
  meta.maintainers = with lib.maintainers; [ lenianiva ];

  options.services.concourse-web = {
    enable = lib.mkEnableOption "A container-based automation system written in Go. (The web server part)";
    package = lib.mkPackageOption pkgs [ "concourse" "executable" ] { };
    user = lib.mkOption {
      type = lib.types.str;
      default = "concourse";
      description = "User account under which concourse runs.";
    };
    session-signing-key = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Path to session signing private key";
    };
    auto-restart = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Automatically restart failed servers";
    };
    network = {
      peer-address = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Address to reach this `web` node from another `web` node";
      };
      bind-port = lib.mkOption {
        type = lib.types.int;
        default = 8080;
        description = "Web interface bind port";
      };
      external-url = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "URL visible from the outside accessible by Concourse users";
      };
      api-max-conns = lib.mkOption {
        type = lib.types.int;
        default = 10;
        description = "Maximum number of API connections";
      };
      backend-max-conns = lib.mkOption {
        type = lib.types.int;
        default = 50;
        description = "Maximum number of backend connections";
      };
      cluster-name = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Name of this cluster";
      };
      p2p-volume-streaming = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Set to true to let the workers use p2p volume streaming.";
      };
    };
    postgres = {
      host = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = "127.0.0.1";
        description = "Host of postgresql database";
      };
      port = lib.mkOption {
        type = lib.types.int;
        default = 5432;
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
      bind-ip = lib.mkOption {
        type = lib.types.str;
        default = "0.0.0.0";
        description = "TSA binding ip";
      };
      bind-port = lib.mkOption {
        type = lib.types.nullOr lib.types.int;
        default = 2222;
        description = "TSA binding port";
      };
      host-key = lib.mkOption {
        type = lib.types.str;
        description = "Path to TSA host key";
      };
      authorized-keys = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Path to TSA authorized keys";
      };
    };
    extra-options = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Extra options to pass to concourse executable";
    };
    environment = lib.mkOption {
      default = { };
      type = lib.types.attrsOf lib.types.str;
      example = lib.literalExpression ''
        {
          CONCOURSE_POSTGRES_PORT = toString config.services.postgresql.settings.port;
          CONCOURSE_POSTGRES_SOCKET = "/var/run/postgresql";
          CONCOURSE_POSTGRES_HOST=127.0.0.1 # default
          CONCOURSE_POSTGRES_DATABASE=atc   # default
          CONCOURSE_POSTGRES_USER=my-user
          CONCOURSE_POSTGRES_PASSWORD=my-password
          CONCOURSE_TSA_HOST_KEY=/etc/concourse/host-key
          CONCOURSE_TSA_AUTHORIZED_KEYS=/etc/concourse/authorized_worker_keys.pub
        }
      '';
      description = "Concourse web server environment variables [documentation](https://concourse-ci.org/concourse-web.html#web-running)";
    };
    environmentFile = lib.mkOption {
      type = with lib.types; coercedTo path (f: [ f ]) (listOf path);
      default = [ ];
      example = [ "/root/concourse-web.env" ];
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
          ExecStart = "${cfg.package}/bin/concourse web ${cfg.extra-options}";
          Restart = if cfg.auto-restart then "on-failure" else "no";
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
          CONCOURSE_BIND_PORT = toString cfg.network.bind-port;
          CONCOURSE_PEER_ADDRESS = cfg.network.peer-address;
          CONCOURSE_EXTERNAL_URL = cfg.network.external-url;
          CONCOURSE_API_MAX_CONNS = lib.mapNullable toString cfg.network.api-max-conns;
          CONCOURSE_BACKEND_MAX_CONNS = lib.mapNullable toString cfg.network.backend-max-conns;
          CONCOURSE_CLUSTER_NAME = cfg.network.cluster-name;

          CONCOURSE_POSTGRES_PORT = toString cfg.postgres.port;
          CONCOURSE_POSTGRES_SOCKET = cfg.postgres.socket;
          CONCOURSE_POSTGRES_DATABASE = cfg.postgres.database;
          CONCOURSE_POSTGRES_USER = cfg.postgres.user;
          CONCOURSE_POSTGRES_PASSWORD = cfg.postgres.password;
          CONCOURSE_SESSION_SIGNING_KEY = cfg.session-signing-key;
          CONCOURSE_TSA_BIND_IP = cfg.tsa.bind-ip;
          CONCOURSE_TSA_BIND_PORT = toString cfg.tsa.bind-port;
          CONCOURSE_TSA_HOST_KEY = cfg.tsa.host-key;
          CONCOURSE_TSA_AUTHORIZED_KEYS = cfg.tsa.authorized-keys;

          CONCOURSE_ENABLE_P2P_VOLUME_STREAMING = toString cfg.network.p2p-volume-streaming;
        }
        // cfg.environment;
      };
    };
  };

}
