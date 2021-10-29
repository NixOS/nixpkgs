{ lib, pkgs, config, ... }:

let
  cfg = config.services.peertube;

  settingsFormat = pkgs.formats.json {};
  configFile = settingsFormat.generate "production.json" cfg.settings;

  env = {
    NODE_CONFIG_DIR = "/var/lib/peertube/config";
    NODE_ENV = "production";
    NODE_EXTRA_CA_CERTS = "/etc/ssl/certs/ca-certificates.crt";
    NPM_CONFIG_PREFIX = cfg.package;
    HOME = cfg.package;
  };

  systemCallsList = [ "@cpu-emulation" "@debug" "@keyring" "@ipc" "@memlock" "@mount" "@obsolete" "@privileged" "@setuid" ];

  cfgService = {
    # Proc filesystem
    ProcSubset = "pid";
    ProtectProc = "invisible";
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
    RemoveIPC = true;
    PrivateMounts = true;
    # System Call Filtering
    SystemCallArchitectures = "native";
  };

  envFile = pkgs.writeText "peertube.env" (lib.concatMapStrings (s: s + "\n") (
    (lib.concatLists (lib.mapAttrsToList (name: value:
      if value != null then [
        "${name}=\"${toString value}\""
      ] else []
    ) env))));

  peertubeEnv = pkgs.writeShellScriptBin "peertube-env" ''
    set -a
    source "${envFile}"
    eval -- "\$@"
  '';

  peertubeCli = pkgs.writeShellScriptBin "peertube" ''
    node ~/dist/server/tools/peertube.js $@
  '';

in {
  options.services.peertube = {
    enable = lib.mkEnableOption "Enable Peertube’s service";

    user = lib.mkOption {
      type = lib.types.str;
      default = "peertube";
      description = "User account under which Peertube runs.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "peertube";
      description = "Group under which Peertube runs.";
    };

    localDomain = lib.mkOption {
      type = lib.types.str;
      example = "peertube.example.com";
      description = "The domain serving your PeerTube instance.";
    };

    listenHttp = lib.mkOption {
      type = lib.types.int;
      default = 9000;
      description = "listen port for HTTP server.";
    };

    listenWeb = lib.mkOption {
      type = lib.types.int;
      default = 9000;
      description = "listen port for WEB server.";
    };

    enableWebHttps = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable or disable HTTPS protocol.";
    };

    dataDirs = lib.mkOption {
      type = lib.types.listOf lib.types.path;
      default = [ ];
      example = [ "/opt/peertube/storage" "/var/cache/peertube" ];
      description = "Allow access to custom data locations.";
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

    settings = lib.mkOption {
      type = settingsFormat.type;
      example = lib.literalExpression ''
        {
          listen = {
            hostname = "0.0.0.0";
          };
          log = {
            level = "debug";
          };
          storage = {
            tmp = "/opt/data/peertube/storage/tmp/";
            logs = "/opt/data/peertube/storage/logs/";
            cache = "/opt/data/peertube/storage/cache/";
          };
        }
      '';
      description = "Configuration for peertube.";
    };

    database = {
      createLocally = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Configure local PostgreSQL database server for PeerTube.";
      };

      host = lib.mkOption {
        type = lib.types.str;
        default = if cfg.database.createLocally then "/run/postgresql" else null;
        example = "192.168.15.47";
        description = "Database host address or unix socket.";
      };

      port = lib.mkOption {
        type = lib.types.int;
        default = 5432;
        description = "Database host port.";
      };

      name = lib.mkOption {
        type = lib.types.str;
        default = "peertube";
        description = "Database name.";
      };

      user = lib.mkOption {
        type = lib.types.str;
        default = "peertube";
        description = "Database user.";
      };

      passwordFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        example = "/run/keys/peertube/password-posgressql-db";
        description = "Password for PostgreSQL database.";
      };
    };

    redis = {
      createLocally = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Configure local Redis server for PeerTube.";
      };

      host = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = if cfg.redis.createLocally && !cfg.redis.enableUnixSocket then "127.0.0.1" else null;
        description = "Redis host.";
      };

      port = lib.mkOption {
        type = lib.types.nullOr lib.types.port;
        default = if cfg.redis.createLocally && cfg.redis.enableUnixSocket then null else 6379;
        description = "Redis port.";
      };

      passwordFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        example = "/run/keys/peertube/password-redis-db";
        description = "Password for redis database.";
      };

      enableUnixSocket = lib.mkOption {
        type = lib.types.bool;
        default = cfg.redis.createLocally;
        description = "Use Unix socket.";
      };
    };

    smtp = {
      createLocally = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Configure local Postfix SMTP server for PeerTube.";
      };

      passwordFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        example = "/run/keys/peertube/password-smtp";
        description = "Password for smtp server.";
      };
    };

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.peertube;
      description = "Peertube package to use.";
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
      { assertion = cfg.smtp.passwordFile == null || !lib.hasPrefix builtins.storeDir cfg.smtp.passwordFile;
          message = ''
            <option>services.peertube.smtp.passwordFile</option> points to
            a file in the Nix store. You should use a quoted absolute path to
            prevent this.
          '';
      }
    ];

    services.peertube.settings = lib.mkMerge [
      {
        listen = {
          port = cfg.listenHttp;
        };
        webserver = {
          https = (if cfg.enableWebHttps then true else false);
          hostname = "${cfg.localDomain}";
          port = cfg.listenWeb;
        };
        database = {
          hostname = "${cfg.database.host}";
          port = cfg.database.port;
          name = "${cfg.database.name}";
          username = "${cfg.database.user}";
        };
        redis = {
          hostname = "${toString cfg.redis.host}";
          port = (if cfg.redis.port == null then "" else cfg.redis.port);
        };
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
      }
      (lib.mkIf cfg.redis.enableUnixSocket { redis = { socket = "/run/redis/redis.sock"; }; })
    ];

    systemd.tmpfiles.rules = [
      "d '/var/lib/peertube/config' 0700 ${cfg.user} ${cfg.group} - -"
      "z '/var/lib/peertube/config' 0700 ${cfg.user} ${cfg.group} - -"
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
        SystemCallFilter = "~" + lib.concatStringsSep " " (systemCallsList ++ [ "@resources" ]);
      } // cfgService;
    };

    systemd.services.peertube = {
      description = "PeerTube daemon";
      after = [ "network.target" ]
        ++ lib.optionals cfg.redis.createLocally [ "redis.service" ]
        ++ lib.optionals cfg.database.createLocally [ "postgresql.service" "peertube-init-db.service" ];
      wantedBy = [ "multi-user.target" ];

      environment = env;

      path = with pkgs; [ bashInteractive ffmpeg nodejs-16_x openssl yarn youtube-dl ];

      script = ''
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
        ${lib.optionalString (cfg.smtp.passwordFile != null) ''
        smtp:
          password: '$(cat ${cfg.smtp.passwordFile})'
        ''}
        EOF
        ln -sf ${cfg.package}/config/default.yaml /var/lib/peertube/config/default.yaml
        ln -sf ${configFile} /var/lib/peertube/config/production.json
        npm start
      '';
      serviceConfig = {
        Type = "simple";
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
        # Access write directories
        ReadWritePaths = cfg.dataDirs;
        # Environment
        EnvironmentFile = cfg.serviceEnvironmentFile;
        # Sandboxing
        RestrictAddressFamilies = [ "AF_UNIX" "AF_INET" "AF_INET6" "AF_NETLINK" ];
        MemoryDenyWriteExecute = false;
        # System Call Filtering
        SystemCallFilter = [ ("~" + lib.concatStringsSep " " systemCallsList) "pipe" "pipe2" ];
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
          home = cfg.package;
        };
      })
      (lib.attrsets.setAttrByPath [ cfg.user "packages" ] [ cfg.package peertubeEnv peertubeCli pkgs.ffmpeg pkgs.nodejs-16_x pkgs.yarn ])
      (lib.mkIf cfg.redis.enableUnixSocket {${config.services.peertube.user}.extraGroups = [ "redis" ];})
    ];

    users.groups = lib.optionalAttrs (cfg.group == "peertube") {
      peertube = { };
    };
  };
}
