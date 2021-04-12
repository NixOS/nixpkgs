{ lib, pkgs, config, ... }:

let
  cfg = config.services.peertube;
  settingsFormat = pkgs.formats.yaml {};

  cfgService = {
    # Access write directories
    UMask = "0027";
    # Capabilities
    CapabilityBoundingSet = "";
    # Security
    NoNewPrivileges = true;
    # Sandboxing
    ProtectSystem = "strict";
    ProtectHome = true;
    PrivateTmp = true;
    PrivateDevices = true;
    PrivateUsers = true;
    ProtectClock = true;
    ProtectHostname = true;
    ProtectKernelLogs = true;
    ProtectKernelModules = true;
    ProtectKernelTunables = true;
    ProtectControlGroups = true;
    RestrictNamespaces = true;
    LockPersonality = true;
    RestrictRealtime = true;
    RestrictSUIDSGID = true;
    PrivateMounts = true;
    # System Call Filtering
    SystemCallArchitectures = "native";
  };

in {
  options.services.peertube = {
    enable = lib.mkEnableOption "Enable Peertube’s service";

    user = lib.mkOption {
      type = lib.types.str;
      default = "peertube";
      description = "User account under which Peertube runs";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "peertube";
      description = "Group under which Peertube runs";
    };

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = settingsFormat.type;

        options.listen = {
          port = lib.mkOption {
            type = lib.types.port;
            default = 9000;
            description = "listen port for HTTP server";
          };
        };

        options.webserver = {
          https = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Enable or disable HTTPS protocol";
          };
          hostname = lib.mkOption {
            type = lib.types.str;
            default = null;
            description = "Server name of reverse proxy";
          };
          port = lib.mkOption {
            type = lib.types.port;
            default = 443;
            description = "listen port for WEB server";
          };
        };

        options.redis = {
          hostname = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = if cfg.redis.createLocally && cfg.settings.redis.socket == null then "127.0.0.1" else null;
            description = "Redis host";
          };
          port = lib.mkOption {
            type = lib.types.nullOr lib.types.port;
            default = if cfg.redis.createLocally && cfg.settings.redis.socket != null then null else 6379;
            description = "Redis port";
          };
          socket = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = if cfg.redis.createLocally then "/run/redis/redis.sock" else null;
            description = "Use Unix socket";
          };
        };

        options.database = {
          hostname = lib.mkOption {
            type = lib.types.str;
            default = if cfg.database.createLocally then "/run/postgresql" else null;
            example = "192.168.15.47";
            description = "Database host address or unix socket";
          };
          port = lib.mkOption {
            type = lib.types.port;
            default = 5432;
            description = "Database host port";
          };
          name = lib.mkOption {
            type = lib.types.str;
            default = "peertube";
            description = "Database name";
          };
          username = lib.mkOption {
            type = lib.types.str;
            default = "peertube";
            description = "Database user";
          };
        };
      };
      default = {};
      description = ''
        <link xlink:href="https://example.com/docs/foo">Configuration for peertube</link>
      '';
    };

    serviceEnvironmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = "/run/keys/peertube/password-init-root";
      description = ''
        Set environment variables for the service. Mainly useful for setting the initial root password.
        For example write to file:
        PT_INITIAL_ROOT_PASSWORD=changeme
      '';
    };

    redis = {
      createLocally = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Configure local Redis server for PeerTube";
      };

      passwordFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        example = "/run/keys/peertube/password-redis-db";
        description = "Password for redis database";
      };
    };

    database = {
      createLocally = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Configure local PostgreSQL database server for PeerTube";
      };

      passwordFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        example = "/run/keys/peertube/password-posgressql-db";
        description = "Password for PostgreSQL database";
      };
    };

    smtp = {
      createLocally = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Configure local Postfix SMTP server for PeerTube";
      };
    };

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.peertube;
      description = "Peertube package to use";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      { assertion = cfg.serviceEnvironmentFile == null || !lib.hasPrefix builtins.storeDir cfg.serviceEnvironmentFile;
          message = ''
            <option>services.peertube.serviceEnvironmentFile</option> points to
            a file in the Nix store. You should use a quoted absolute path to
            prevent this.
          '';
      }
      { assertion = !(cfg.settings.redis.socket != null && (cfg.settings.redis.hostname != null || cfg.settings.redis.port != null));
          message = ''
            <option>services.peertube.redis.createLocally</option> and redis network connection (<option>services.peertube.settings.redis.hostname</option> or <option>services.peertube.settings.redis.port</option>) enabled. Disable either of them.
        '';
      }
      { assertion = cfg.settings.redis.socket != null || (cfg.settings.redis.hostname != null && cfg.settings.redis.port != null);
          message = ''
            <option>services.peertube.settings.redis.hostname</option> and <option>services.peertube.settings.redis.port</option> needs to be set if <option>services.peertube.settings.redis.socket</option> is not set..
        '';
      }
      { assertion = cfg.redis.passwordFile == null || !lib.hasPrefix builtins.storeDir cfg.redis.passwordFile;
          message = ''
            <option>services.peertube.redis.passwordFile</option> points to
            a file in the Nix store. You should use a quoted absolute path to
            prevent this.
          '';
      }
      { assertion = cfg.database.passwordFile == null || !lib.hasPrefix builtins.storeDir cfg.database.passwordFile;
          message = ''
            <option>services.peertube.database.passwordFile</option> points to
            a file in the Nix store. You should use a quoted absolute path to
            prevent this.
          '';
      }
    ];

    services.peertube.settings = {
      storage = {
        tmp = lib.mkDefault "/var/lib/peertube/storage/tmp/";
        avatars = lib.mkDefault "/var/lib/peertube/storage/avatars/";
        videos = lib.mkDefault "/var/lib/peertube/storage/videos/";
        streaming_playlists = lib.mkDefault "/var/lib/peertube/storage/streaming-playlists/";
        redundancy = lib.mkDefault "/var/lib/peertube/storage/redundancy/";
        logs = lib.mkDefault "/var/lib/peertube/storage/logs/";
        previews = lib.mkDefault "/var/lib/peertube/storage/previews/";
        thumbnails = lib.mkDefault "/var/lib/peertube/storage/thumbnails/";
        torrents = lib.mkDefault "/var/lib/peertube/storage/torrents/";
        captions = lib.mkDefault "/var/lib/peertube/storage/captions/";
        cache = lib.mkDefault "/var/lib/peertube/storage/cache/";
        plugins = lib.mkDefault "/var/lib/peertube/storage/plugins/";
        client_overrides = lib.mkDefault "/var/lib/peertube/storage/client-overrides/";
      };
    };

    systemd.tmpfiles.rules = [
      "d '/var/lib/peertube/config' 0700 ${cfg.user} ${cfg.group} - -"
      "z '/var/lib/peertube/config' 0700 ${cfg.user} ${cfg.group} - -"
      "d '/var/lib/peertube/storage' 0750 ${cfg.user} ${cfg.group} - -"
      "z '/var/lib/peertube/storage' 0750 ${cfg.user} ${cfg.group} - -"
    ];

    systemd.services.peertube-init-db = lib.mkIf cfg.database.createLocally {
      description = "Initialization database for PeerTube daemon";
      after = [ "network.target" "postgresql.service" ];
      wantedBy = [ "multi-user.target" ];

      script = let
        psqlSetupCommands = pkgs.writeText "peertube-init.sql" ''
          SELECT 'CREATE USER "${cfg.settings.database.username}"' WHERE NOT EXISTS (SELECT FROM pg_roles WHERE rolname = '${cfg.settings.database.username}')\gexec
          SELECT 'CREATE DATABASE "${cfg.settings.database.name}" OWNER "${cfg.settings.database.username}" TEMPLATE template0 ENCODING UTF8' WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = '${cfg.settings.database.name}')\gexec
          \c '${cfg.settings.database.name}'
          CREATE EXTENSION IF NOT EXISTS pg_trgm;
          CREATE EXTENSION IF NOT EXISTS unaccent;
        '';
      in "${config.services.postgresql.package}/bin/psql -f ${psqlSetupCommands}";

      serviceConfig = {
        Type = "oneshot";
        WorkingDirectory = cfg.package;
        # User and group
        User = "postgres";
        Group = "postgres";
        # Sandboxing
        RestrictAddressFamilies = [ "AF_UNIX" ];
        MemoryDenyWriteExecute = true;
        # System Call Filtering
        SystemCallFilter = "~@clock @cpu-emulation @debug @keyring @memlock @module @mount @obsolete @privileged @raw-io @reboot @resources @setuid @swap";
      } // cfgService;
    };

    systemd.services.peertube = {
      description = "PeerTube daemon";
      after = [ "network.target" ]
        ++ lib.optionals cfg.redis.createLocally [ "redis.service" ]
        ++ lib.optionals cfg.database.createLocally [ "postgresql.service" "peertube-init-db.service" ];
      wantedBy = [ "multi-user.target" ];

      environment.NODE_CONFIG_DIR = "/var/lib/peertube/config";
      environment.NODE_ENV = "production";
      environment.NODE_EXTRA_CA_CERTS = "/etc/ssl/certs/ca-certificates.crt";
      environment.HOME = cfg.package;

      path = with pkgs; [ bashInteractive ffmpeg nodejs openssl yarn youtube-dl ];

      serviceConfig = {
        Type = "simple";
        ExecStartPre = let preStartScript = pkgs.writeScript "peertube-pre-start.sh" ''
          #!/bin/sh
          umask 077
          cat > /var/lib/peertube/config/local.yaml <<EOF
          ${lib.optionalString ((!cfg.database.createLocally) && (cfg.database.passwordFile != null)) ''
          database:
            password: '$(cat ${cfg.database.passwordFile})'
          ''}
          ${lib.optionalString (cfg.redis.passwordFile != null) ''
          redis:
            auth: '$(cat ${cfg.redis.passwordFile})'
          ''}
          EOF
          ln -sf ${cfg.package}/config/default.yaml /var/lib/peertube/config/default.yaml
          ln -sf ${settingsFormat.generate "production.yaml" cfg.settings} /var/lib/peertube/config/production.yaml
        '';
        in "${preStartScript}";
        ExecStart = let startScript = pkgs.writeScript "peertube-start.sh" ''
          #!/bin/sh
          exec npm start
        '';
        in "${startScript}";
        Restart = "always";
        RestartSec = 20;
        TimeoutSec = 60;
        WorkingDirectory = cfg.package;
        # User and group
        User = cfg.user;
        Group = cfg.group;
        # State directory and mode
        StateDirectory = "peertube";
        StateDirectoryMode = "0750";
        # Environment
        EnvironmentFile = cfg.serviceEnvironmentFile;
        # Sandboxing
        RestrictAddressFamilies = [ "AF_UNIX" "AF_INET" "AF_INET6" "AF_NETLINK" ];
        MemoryDenyWriteExecute = false;
        # System Call Filtering
        SystemCallFilter = "~@clock @cpu-emulation @debug @keyring @memlock @module @mount @obsolete @privileged @raw-io @reboot @setuid @swap";
      } // cfgService;
    };

    services.postgresql = lib.mkIf cfg.database.createLocally {
      enable = true;
    };

    services.redis = lib.mkMerge [
      (lib.mkIf cfg.redis.createLocally {
        enable = true;
      })
      (lib.mkIf (cfg.redis.createLocally && cfg.settings.redis.socket != null) {
        unixSocket = "/run/redis/redis.sock";
        unixSocketPerm = 770;
      })
    ];

    services.postfix = lib.mkIf cfg.smtp.createLocally {
      enable = true;
      hostname = lib.mkDefault "${cfg.localDomain}";
    };

    users.users = lib.mkMerge [
      (lib.mkIf (cfg.user == "peertube") {
        peertube = {
          isSystemUser = true;
          group = cfg.group;
        };
      })
      (lib.mkIf (cfg.settings.redis.socket != null) {${config.services.peertube.user}.extraGroups = [ "redis" ];})
    ];

    users.groups = lib.optionalAttrs (cfg.group == "peertube") {
      peertube = { };
    };
  };
}
