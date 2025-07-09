{
  lib,
  pkgs,
  config,
  options,
  ...
}:

let
  cfg = config.services.peertube;
  opt = options.services.peertube;

  settingsFormat = pkgs.formats.json { };
  configFile = settingsFormat.generate "production.json" cfg.settings;

  env = {
    NODE_CONFIG_DIR = "/var/lib/peertube/config";
    NODE_ENV = "production";
    NODE_EXTRA_CA_CERTS = config.security.pki.caBundle;
    NPM_CONFIG_CACHE = "/var/cache/peertube/.npm";
    NPM_CONFIG_PREFIX = cfg.package;
    HOME = cfg.package;
    # Used for auto video transcription
    HF_HOME = "/var/cache/peertube/huggingface";
  };

  systemCallsList = [
    "@cpu-emulation"
    "@debug"
    "@keyring"
    "@ipc"
    "@memlock"
    "@mount"
    "@obsolete"
    "@privileged"
    "@setuid"
  ];

  cfgService = {
    # Proc filesystem
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

  envFile = pkgs.writeText "peertube.env" (
    lib.concatMapStrings (s: s + "\n") (
      (lib.concatLists (
        lib.mapAttrsToList (name: value: lib.optional (value != null) ''${name}="${toString value}"'') env
      ))
    )
  );

  peertubeEnv = pkgs.writeShellScriptBin "peertube-env" ''
    set -a
    source "${envFile}"
    eval -- "\$@"
  '';

  nginxCommonHeaders =
    lib.optionalString config.services.nginx.virtualHosts.${cfg.localDomain}.forceSSL ''
      add_header Strict-Transport-Security 'max-age=31536000';
    ''
    +
      lib.optionalString
        (
          config.services.nginx.virtualHosts.${cfg.localDomain}.quic
          && config.services.nginx.virtualHosts.${cfg.localDomain}.http3
        )
        ''
          add_header Alt-Svc 'h3=":$server_port"; ma=604800';
        '';

  nginxCommonHeadersExtra = ''
    add_header Access-Control-Allow-Origin '*';
    add_header Access-Control-Allow-Methods 'GET, OPTIONS';
    add_header Access-Control-Allow-Headers 'Range,DNT,X-CustomHeader,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type';
  '';

in
{
  options.services.peertube = {
    enable = lib.mkEnableOption "Peertube";

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
      type = lib.types.port;
      default = 9000;
      description = "The port that the local PeerTube web server will listen on.";
    };

    listenWeb = lib.mkOption {
      type = lib.types.port;
      default = 9000;
      description = "The public-facing port that PeerTube will be accessible at (likely 80 or 443 if running behind a reverse proxy). Clients will try to access PeerTube at this port.";
    };

    enableWebHttps = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether clients will access your PeerTube instance with HTTPS. Does NOT configure the PeerTube webserver itself to listen for incoming HTTPS connections.";
    };

    dataDirs = lib.mkOption {
      type = lib.types.listOf lib.types.path;
      default = [ ];
      example = [
        "/opt/peertube/storage"
        "/var/cache/peertube"
      ];
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

    configureNginx = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Configure nginx as a reverse proxy for peertube.";
    };

    secrets = {
      secretsFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        example = "/run/secrets/peertube";
        description = ''
          Secrets to run PeerTube.
          Generate one using `openssl rand -hex 32`
        '';
      };
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
        defaultText = lib.literalExpression ''
          if config.${opt.database.createLocally}
          then "/run/postgresql"
          else null
        '';
        example = "192.168.15.47";
        description = "Database host address or unix socket.";
      };

      port = lib.mkOption {
        type = lib.types.port;
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
        example = "/run/keys/peertube/password-postgresql";
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
        defaultText = lib.literalExpression ''
          if config.${opt.redis.createLocally} && !config.${opt.redis.enableUnixSocket}
          then "127.0.0.1"
          else null
        '';
        description = "Redis host.";
      };

      port = lib.mkOption {
        type = lib.types.nullOr lib.types.port;
        default = if cfg.redis.createLocally && cfg.redis.enableUnixSocket then null else 31638;
        defaultText = lib.literalExpression ''
          if config.${opt.redis.createLocally} && config.${opt.redis.enableUnixSocket}
          then null
          else 6379
        '';
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
        defaultText = lib.literalExpression "config.${opt.redis.createLocally}";
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
      defaultText = lib.literalExpression "pkgs.peertube";
      description = "PeerTube package to use.";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion =
          cfg.serviceEnvironmentFile == null || !lib.hasPrefix builtins.storeDir cfg.serviceEnvironmentFile;
        message = ''
          <option>services.peertube.serviceEnvironmentFile</option> points to
          a file in the Nix store. You should use a quoted absolute path to
          prevent this.
        '';
      }
      {
        assertion = cfg.secrets.secretsFile != null;
        message = ''
          <option>services.peertube.secrets.secretsFile</option> needs to be set.
        '';
      }
      {
        assertion = !(cfg.redis.enableUnixSocket && (cfg.redis.host != null || cfg.redis.port != null));
        message = ''
          <option>services.peertube.redis.createLocally</option> and redis network connection (<option>services.peertube.redis.host</option> or <option>services.peertube.redis.port</option>) enabled. Disable either of them.
        '';
      }
      {
        assertion = cfg.redis.enableUnixSocket || (cfg.redis.host != null && cfg.redis.port != null);
        message = ''
          <option>services.peertube.redis.host</option> and <option>services.peertube.redis.port</option> needs to be set if <option>services.peertube.redis.enableUnixSocket</option> is not enabled.
        '';
      }
      {
        assertion =
          cfg.redis.passwordFile == null || !lib.hasPrefix builtins.storeDir cfg.redis.passwordFile;
        message = ''
          <option>services.peertube.redis.passwordFile</option> points to
          a file in the Nix store. You should use a quoted absolute path to
          prevent this.
        '';
      }
      {
        assertion =
          cfg.database.passwordFile == null || !lib.hasPrefix builtins.storeDir cfg.database.passwordFile;
        message = ''
          <option>services.peertube.database.passwordFile</option> points to
          a file in the Nix store. You should use a quoted absolute path to
          prevent this.
        '';
      }
      {
        assertion = cfg.smtp.passwordFile == null || !lib.hasPrefix builtins.storeDir cfg.smtp.passwordFile;
        message = ''
          <option>services.peertube.smtp.passwordFile</option> points to
          a file in the Nix store. You should use a quoted absolute path to
          prevent this.
        '';
      }
    ];

    environment.systemPackages = [ cfg.package.cli ];

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
          port = (lib.optionalString (cfg.redis.port != null) cfg.redis.port);
        };
        storage = {
          tmp = lib.mkDefault "/var/lib/peertube/storage/tmp/";
          tmp_persistent = lib.mkDefault "/var/lib/peertube/storage/tmp_persistent/";
          bin = lib.mkDefault "/var/lib/peertube/storage/bin/";
          avatars = lib.mkDefault "/var/lib/peertube/storage/avatars/";
          logs = lib.mkDefault "/var/lib/peertube/storage/logs/";
          web_videos = lib.mkDefault "/var/lib/peertube/storage/web-videos/";
          streaming_playlists = lib.mkDefault "/var/lib/peertube/storage/streaming-playlists/";
          original_video_files = lib.mkDefault "/var/lib/peertube/storage/original-video-files/";
          redundancy = lib.mkDefault "/var/lib/peertube/storage/redundancy/";
          thumbnails = lib.mkDefault "/var/lib/peertube/storage/thumbnails/";
          storyboards = lib.mkDefault "/var/lib/peertube/storage/storyboards/";
          previews = lib.mkDefault "/var/lib/peertube/storage/previews/";
          captions = lib.mkDefault "/var/lib/peertube/storage/captions/";
          torrents = lib.mkDefault "/var/lib/peertube/storage/torrents/";
          cache = lib.mkDefault "/var/lib/peertube/storage/cache/";
          plugins = lib.mkDefault "/var/lib/peertube/storage/plugins/";
          client_overrides = lib.mkDefault "/var/lib/peertube/storage/client-overrides/";
          well_known = lib.mkDefault "/var/lib/peertube/storage/well_known/";
        };
        import = {
          videos = {
            http = {
              youtube_dl_release = {
                python_path = "${pkgs.python3}/bin/python";
              };
            };
          };
        };
        video_transcription = {
          engine = lib.mkDefault "whisper-ctranslate2";
          engine_path = lib.mkDefault (lib.getExe pkgs.whisper-ctranslate2);
        };
      }
      (lib.mkIf cfg.redis.enableUnixSocket {
        redis = {
          socket = "/run/redis-peertube/redis.sock";
        };
      })
    ];

    systemd.tmpfiles.rules = [
      "d '/var/lib/peertube/config' 0700 ${cfg.user} ${cfg.group} - -"
      "z '/var/lib/peertube/config' 0700 ${cfg.user} ${cfg.group} - -"
      "d '/var/lib/peertube/www' 0750 ${cfg.user} ${cfg.group} - -"
      "z '/var/lib/peertube/www' 0750 ${cfg.user} ${cfg.group} - -"
    ];

    systemd.services.peertube-init-db = lib.mkIf cfg.database.createLocally {
      description = "Initialization database for PeerTube daemon";
      after = [
        "network.target"
        "postgresql.target"
      ];
      requires = [ "postgresql.target" ];

      script =
        let
          psqlSetupCommands = pkgs.writeText "peertube-init.sql" ''
            SELECT 'CREATE USER "${cfg.database.user}"' WHERE NOT EXISTS (SELECT FROM pg_roles WHERE rolname = '${cfg.database.user}')\gexec
            SELECT 'CREATE DATABASE "${cfg.database.name}" OWNER "${cfg.database.user}" TEMPLATE template0 ENCODING UTF8' WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = '${cfg.database.name}')\gexec
            \c '${cfg.database.name}'
            CREATE EXTENSION IF NOT EXISTS pg_trgm;
            CREATE EXTENSION IF NOT EXISTS unaccent;
          '';
        in
        "${config.services.postgresql.package}/bin/psql -f ${psqlSetupCommands}";

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
      after =
        [ "network.target" ]
        ++ lib.optional cfg.redis.createLocally "redis-peertube.service"
        ++ lib.optionals cfg.database.createLocally [
          "postgresql.target"
          "peertube-init-db.service"
        ];
      requires =
        lib.optional cfg.redis.createLocally "redis-peertube.service"
        ++ lib.optionals cfg.database.createLocally [
          "postgresql.target"
          "peertube-init-db.service"
        ];
      wantedBy = [ "multi-user.target" ];

      environment = env;

      path = with pkgs; [
        nodejs_20
        yarn
        ffmpeg-headless
        openssl
      ];

      script = ''
        umask 077
        cat > /var/lib/peertube/config/local.yaml <<EOF
        ${lib.optionalString (cfg.secrets.secretsFile != null) ''
          secrets:
            peertube: '$(cat ${cfg.secrets.secretsFile})'
        ''}
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
        umask 027
        ln -sf ${configFile} /var/lib/peertube/config/production.json
        ln -sf ${cfg.package}/config/default.yaml /var/lib/peertube/config/default.yaml
        ln -sf ${cfg.package}/client/dist -T /var/lib/peertube/www/client
        ln -sf ${cfg.settings.storage.client_overrides} -T /var/lib/peertube/www/client-overrides
        exec node dist/server
      '';
      serviceConfig = {
        Type = "simple";
        Restart = "always";
        RestartSec = 20;
        TimeoutSec = 60;
        WorkingDirectory = cfg.package;
        SyslogIdentifier = "peertube";
        # User and group
        User = cfg.user;
        Group = cfg.group;
        # State directory and mode
        StateDirectory = "peertube";
        StateDirectoryMode = "0750";
        # Cache directory and mode
        CacheDirectory = "peertube";
        CacheDirectoryMode = "0750";
        # Access write directories
        ReadWritePaths = cfg.dataDirs;
        # Environment
        EnvironmentFile = cfg.serviceEnvironmentFile;
        # Sandboxing
        RestrictAddressFamilies = [
          "AF_UNIX"
          "AF_INET"
          "AF_INET6"
          "AF_NETLINK"
        ];
        MemoryDenyWriteExecute = false;
        # System Call Filtering
        SystemCallFilter = [
          ("~" + lib.concatStringsSep " " systemCallsList)
          "pipe"
          "pipe2"
        ];
      } // cfgService;
    };

    services.nginx = lib.mkIf cfg.configureNginx {
      enable = true;
      upstreams."peertube".servers = {
        "127.0.0.1:${toString cfg.listenHttp}".fail_timeout = "0";
      };
      virtualHosts."${cfg.localDomain}" = {
        root = "/var/lib/peertube/www";

        # Application
        locations."/" = {
          tryFiles = "/dev/null @api";
          priority = 1110;
        };

        locations."~ ^/api/v1/videos/(upload-resumable|([^/]+/source/replace-resumable))$" = {
          tryFiles = "/dev/null @api";
          priority = 1120;

          extraConfig =
            ''
              client_max_body_size 0;
              proxy_request_buffering off;
            ''
            + nginxCommonHeaders;
        };

        locations."~ ^/api/v1/users/[^/]+/imports/import-resumable$" = {
          tryFiles = "/dev/null @api";
          priority = 1130;

          extraConfig =
            ''
              client_max_body_size 0;
              proxy_request_buffering off;
            ''
            + nginxCommonHeaders;
        };

        locations."~ ^/api/v1/videos/(upload|([^/]+/studio/edit))$" = {
          tryFiles = "/dev/null @api";
          root = cfg.settings.storage.tmp;
          priority = 1140;

          extraConfig =
            ''
              limit_except POST HEAD { deny all; }

              client_max_body_size 12G;
              add_header X-File-Maximum-Size 8G always;
            ''
            + nginxCommonHeaders;
        };

        locations."~ ^/api/v1/runners/jobs/[^/]+/(update|success)$" = {
          tryFiles = "/dev/null @api";
          root = cfg.settings.storage.tmp;
          priority = 1150;

          extraConfig =
            ''
              client_max_body_size 12G;
              add_header X-File-Maximum-Size 8G always;
            ''
            + nginxCommonHeaders;
        };

        locations."~ ^/api/v1/(videos|video-playlists|video-channels|users/me)" = {
          tryFiles = "/dev/null @api";
          priority = 1160;

          extraConfig =
            ''
              client_max_body_size 6M;
              add_header X-File-Maximum-Size 4M always;
            ''
            + nginxCommonHeaders;
        };

        locations."@api" = {
          proxyPass = "http://peertube";
          priority = 1170;

          extraConfig =
            ''
              proxy_set_header Host $host;
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

              proxy_connect_timeout 10m;

              proxy_send_timeout 10m;
              proxy_read_timeout 10m;

              client_max_body_size 100k;
              send_timeout 10m;
            ''
            + nginxCommonHeaders;
        };

        # Websocket
        locations."/socket.io" = {
          tryFiles = "/dev/null @api_websocket";
          priority = 1210;
        };

        locations."/tracker/socket" = {
          tryFiles = "/dev/null @api_websocket";
          priority = 1220;

          extraConfig = ''
            proxy_read_timeout 15m;
          '';
        };

        locations."~ ^/plugins/[^/]+(/[^/]+)?/ws/" = {
          tryFiles = "/dev/null @api_websocket";
          priority = 1230;
        };

        locations."@api_websocket" = {
          proxyPass = "http://peertube";
          priority = 1240;

          extraConfig =
            ''
              proxy_http_version 1.1;
              proxy_set_header Upgrade $http_upgrade;
              proxy_set_header Connection 'upgrade';
              proxy_set_header Host $host;
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

            ''
            + nginxCommonHeaders;
        };

        # Bypass PeerTube for performance reasons.
        locations."~ ^/client/(assets/images/(icons/icon-36x36\\.png|icons/icon-48x48\\.png|icons/icon-72x72\\.png|icons/icon-96x96\\.png|icons/icon-144x144\\.png|icons/icon-192x192\\.png|icons/icon-512x512\\.png|logo\\.svg|favicon\\.png|default-playlist\\.jpg|default-avatar-account\\.png|default-avatar-account-48x48\\.png|default-avatar-video-channel\\.png|default-avatar-video-channel-48x48\\.png))$" =
          {
            tryFiles = "/client-overrides/$1 /client/$1 $1";
            priority = 1310;

            extraConfig = nginxCommonHeaders;
          };

        locations."~ ^/client/(.*\\.(js|css|png|svg|woff2|otf|ttf|woff|eot))$" = {
          alias = "${cfg.package}/client/dist/$1";
          priority = 1320;
          extraConfig =
            ''
              add_header Cache-Control 'public, max-age=604800, immutable';
            ''
            + nginxCommonHeaders;
        };

        locations."^~ /download/" = {
          proxyPass = "http://peertube";
          priority = 1410;
          extraConfig =
            ''
              proxy_set_header Host $host;
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

              proxy_limit_rate 5M;
            ''
            + nginxCommonHeaders;
        };

        locations."^~ /static/streaming-playlists/hls/private/" = {
          proxyPass = "http://peertube";
          priority = 1420;
          extraConfig =
            ''
              proxy_set_header Host $host;
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

              proxy_limit_rate 5M;
            ''
            + nginxCommonHeaders;
        };

        locations."^~ /static/web-videos/private/" = {
          proxyPass = "http://peertube";
          priority = 1430;
          extraConfig =
            ''
              proxy_set_header Host $host;
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

              proxy_limit_rate 5M;
            ''
            + nginxCommonHeaders;
        };

        locations."^~ /static/webseed/private/" = {
          proxyPass = "http://peertube";
          priority = 1440;
          extraConfig =
            ''
              proxy_set_header Host $host;
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

              proxy_limit_rate 5M;
            ''
            + nginxCommonHeaders;
        };

        locations."^~ /static/redundancy/" = {
          tryFiles = "$uri @api";
          root = cfg.settings.storage.redundancy;
          priority = 1450;
          extraConfig = ''
            set $peertube_limit_rate 800k;

            if ($request_uri ~ -fragmented.mp4$) {
              set $peertube_limit_rate 5M;
            }

            if ($request_method = 'OPTIONS') {
              ${nginxCommonHeaders}
              ${nginxCommonHeadersExtra}
              add_header Access-Control-Max-Age 1728000;
              add_header Content-Type 'text/plain charset=UTF-8';
              add_header Content-Length 0;
              return 204;
            }
            if ($request_method = 'GET') {
              ${nginxCommonHeaders}
              ${nginxCommonHeadersExtra}
            }

            aio threads;
            sendfile on;
            sendfile_max_chunk 1M;

            limit_rate $peertube_limit_rate;
            limit_rate_after 5M;

            rewrite ^/static/redundancy/(.*)$ /$1 break;
          '';
        };

        locations."^~ /static/streaming-playlists/" = {
          tryFiles = "$uri @api";
          root = cfg.settings.storage.streaming_playlists;
          priority = 1460;
          extraConfig = ''
            set $peertube_limit_rate 800k;

            if ($request_uri ~ -fragmented.mp4$) {
              set $peertube_limit_rate 5M;
            }

            if ($request_method = 'OPTIONS') {
              ${nginxCommonHeaders}
              ${nginxCommonHeadersExtra}
              add_header Access-Control-Max-Age 1728000;
              add_header Content-Type 'text/plain charset=UTF-8';
              add_header Content-Length 0;
              return 204;
            }
            if ($request_method = 'GET') {
              ${nginxCommonHeaders}
              ${nginxCommonHeadersExtra}
            }

            aio threads;
            sendfile on;
            sendfile_max_chunk 1M;

            limit_rate $peertube_limit_rate;
            limit_rate_after 5M;

            rewrite ^/static/streaming-playlists/(.*)$ /$1 break;
          '';
        };

        locations."^~ /static/web-videos/" = {
          tryFiles = "$uri @api";
          root = cfg.settings.storage.web_videos;
          priority = 1470;
          extraConfig = ''
            set $peertube_limit_rate 800k;

            if ($request_uri ~ -fragmented.mp4$) {
              set $peertube_limit_rate 5M;
            }

            if ($request_method = 'OPTIONS') {
              ${nginxCommonHeaders}
              ${nginxCommonHeadersExtra}
              add_header Access-Control-Max-Age 1728000;
              add_header Content-Type 'text/plain charset=UTF-8';
              add_header Content-Length 0;
              return 204;
            }
            if ($request_method = 'GET') {
              ${nginxCommonHeaders}
              ${nginxCommonHeadersExtra}
            }

            aio threads;
            sendfile on;
            sendfile_max_chunk 1M;

            limit_rate $peertube_limit_rate;
            limit_rate_after 5M;

            rewrite ^/static/web-videos/(.*)$ /$1 break;
          '';
        };

        locations."^~ /static/webseed/" = {
          tryFiles = "$uri @api";
          root = cfg.settings.storage.web_videos;
          priority = 1480;
          extraConfig = ''
            set $peertube_limit_rate 800k;

            if ($request_uri ~ -fragmented.mp4$) {
              set $peertube_limit_rate 5M;
            }

            if ($request_method = 'OPTIONS') {
              ${nginxCommonHeaders}
              ${nginxCommonHeadersExtra}
              add_header Access-Control-Max-Age 1728000;
              add_header Content-Type 'text/plain charset=UTF-8';
              add_header Content-Length 0;
              return 204;
            }
            if ($request_method = 'GET') {
              ${nginxCommonHeaders}
              ${nginxCommonHeadersExtra}
            }

            aio threads;
            sendfile on;
            sendfile_max_chunk 1M;

            limit_rate $peertube_limit_rate;
            limit_rate_after 5M;

            rewrite ^/static/webseed/(.*)$ /web-videos/$1 break;
          '';
        };
      };
    };

    services.postgresql = lib.mkIf cfg.database.createLocally {
      enable = true;
    };

    services.redis.servers.peertube = lib.mkMerge [
      (lib.mkIf cfg.redis.createLocally {
        enable = true;
      })
      (lib.mkIf (cfg.redis.createLocally && !cfg.redis.enableUnixSocket) {
        bind = "127.0.0.1";
        port = cfg.redis.port;
      })
      (lib.mkIf (cfg.redis.createLocally && cfg.redis.enableUnixSocket) {
        unixSocket = "/run/redis-peertube/redis.sock";
        unixSocketPerm = 660;
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
      (lib.attrsets.setAttrByPath
        [ cfg.user "packages" ]
        [ peertubeEnv pkgs.nodejs_20 pkgs.yarn pkgs.ffmpeg-headless ]
      )
      (lib.mkIf cfg.redis.enableUnixSocket {
        ${config.services.peertube.user}.extraGroups = [ "redis-peertube" ];
      })
    ];

    users.groups = {
      ${cfg.group} = {
        members = lib.optional cfg.configureNginx config.services.nginx.user;
      };
    };
  };
}
