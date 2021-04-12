{ lib, pkgs, config, ... }:

let
  cfg = config.services.peertube;

  configFile = pkgs.writeText  "production.yaml" ''
    listen:
      port: ${toString cfg.listenHttp}

    webserver:
      https: ${toString (if cfg.enableWebHttps then "true" else "false")}
      hostname: '${cfg.localDomain}'
      port: ${toString cfg.listenWeb}

    database:
      hostname: '${cfg.database.host}'
      port: ${toString cfg.database.port}
      name: '${cfg.database.name}'
      username: '${cfg.database.user}'

    redis:
      hostname: ${toString cfg.redis.host}
      port: ${toString cfg.redis.port}
      ${lib.optionalString cfg.redis.enableUnixSocket "socket: '/run/redis/redis.sock'"}

    storage:
      tmp: '/var/lib/peertube/storage/tmp/'
      avatars: '/var/lib/peertube/storage/avatars/'
      videos: '/var/lib/peertube/storage/videos/'
      streaming_playlists: '/var/lib/peertube/storage/streaming-playlists/'
      redundancy: '/var/lib/peertube/storage/redundancy/'
      logs: '/var/lib/peertube/storage/logs/'
      previews: '/var/lib/peertube/storage/previews/'
      thumbnails: '/var/lib/peertube/storage/thumbnails/'
      torrents: '/var/lib/peertube/storage/torrents/'
      captions: '/var/lib/peertube/storage/captions/'
      cache: '/var/lib/peertube/storage/cache/'
      plugins: '/var/lib/peertube/storage/plugins/'
      client_overrides: '/var/lib/peertube/storage/client-overrides/'

    ${cfg.extraConfig}
  '';

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

    localDomain = lib.mkOption {
      type = lib.types.str;
      example = "peertube.example.com";
      description = "The domain serving your PeerTube instance.";
    };

    listenHttp = lib.mkOption {
      type = lib.types.int;
      default = 9000;
      description = "listen port for HTTP server";
    };

    listenWeb = lib.mkOption {
      type = lib.types.int;
      default = 443;
      description = "listen port for WEB server";
    };

    enableWebHttps = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable or disable HTTPS protocol";
    };

    extraConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
      example = ''
        listen:
          hostname: '0.0.0.0'
        trust_proxy:
          - '192.168.10.21'
        log:
          level: 'debug'
      '';
      description = "Extra config options for peertube";
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

    database = {
      createLocally = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Configure local PostgreSQL database server for PeerTube";
      };

      host = lib.mkOption {
        type = lib.types.str;
        default = if cfg.database.createLocally then "/run/postgresql" else null;
        example = "192.168.15.47";
        description = "Database host address or unix socket";
      };

      port = lib.mkOption {
        type = lib.types.int;
        default = 5432;
        description = "Database host port";
      };

      name = lib.mkOption {
        type = lib.types.str;
        default = "peertube";
        description = "Database name";
      };

      user = lib.mkOption {
        type = lib.types.str;
        default = "peertube";
        description = "Database user";
      };

      passwordFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        example = "/run/keys/peertube/password-posgressql-db";
        description = "Password for PostgreSQL database";
      };
    };

    redis = {
      createLocally = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Configure local Redis server for PeerTube";
      };

      host = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = if cfg.redis.createLocally && !cfg.redis.enableUnixSocket then "127.0.0.1" else null;
        description = "Redis host";
      };

      port = lib.mkOption {
        type = lib.types.nullOr lib.types.port;
        default = if cfg.redis.createLocally && cfg.redis.enableUnixSocket then null else 6379;
        description = "Redis port";
      };

      passwordFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        example = "/run/keys/peertube/password-redis-db";
        description = "Password for redis database";
      };

      enableUnixSocket = lib.mkOption {
        type = lib.types.bool;
        default = cfg.redis.createLocally;
        description = "Use Unix socket";
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
      { assertion = !(cfg.redis.enableUnixSocket && (cfg.redis.host != null || cfg.redis.port != null));
          message = ''
            <option>services.peertube.redis.createLocally</option> and redis network connection (<option>services.peertube.redis.host</option> or <option>services.peertube.redis.port</option>) enabled. Disable either of them.
        '';
      }
      { assertion = cfg.redis.enableUnixSocket || (cfg.redis.host != null && cfg.redis.port != null);
          message = ''
            <option>services.peertube.redis.host</option> and <option>services.peertube.redis.port</option> needs to be set if <option>services.peertube.redis.enableUnixSocket</option> is not enabled.
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
          SELECT 'CREATE USER "${cfg.database.user}"' WHERE NOT EXISTS (SELECT FROM pg_roles WHERE rolname = '${cfg.database.user}')\gexec
          SELECT 'CREATE DATABASE "${cfg.database.name}" OWNER "${cfg.database.user}" TEMPLATE template0 ENCODING UTF8' WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = '${cfg.database.name}')\gexec
          \c '${cfg.database.name}'
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
          ln -sf ${configFile} /var/lib/peertube/config/production.yaml
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
      (lib.mkIf (cfg.redis.createLocally && cfg.redis.enableUnixSocket) {
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
      (lib.mkIf cfg.redis.enableUnixSocket {${config.services.peertube.user}.extraGroups = [ "redis" ];})
    ];

    users.groups = lib.optionalAttrs (cfg.group == "peertube") {
      peertube = { };
    };
  };
}
