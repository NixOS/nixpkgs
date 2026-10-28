{
  lib,
  config,
  pkgs,
  options,
  ...
}:

let

  cfg = config.services.greenlight;
  opt = options.services.greenlight;

  dataDir = "/var/lib/greenlight";

  listeningAddress = "${cfg.settings.BINDING}:${lib.toString cfg.settings.PORT}";

  configEnv = lib.concatMapAttrs (
    name: value:
    lib.optionalAttrs (value != null) {
      ${name} = if lib.isBool value then lib.boolToString value else toString value;
    }
  ) cfg.settings;
  defaultSecretKeyBaseFile = "${dataDir}/secrets/secret-key-base";
  needsGenCredentialsUnit = cfg.secretKeyBaseFile == null;
  credentials = {
    SECRET_KEY_BASE = lib.defaultTo defaultSecretKeyBaseFile cfg.secretKeyBaseFile;
  }
  // lib.optionalAttrs (cfg.database.passwordFile != null) {
    DATABASE_PASSWORD = cfg.database.passwordFile;
  };
  loadCredentialsIntoEnv = lib.concatMapAttrsStringSep "\n" (
    name: _: ''export ${name}="$(systemd-creds cat ${name})"''
  ) credentials;
  loadCredentials = lib.mapAttrsToList (name: path: "${name}:${path}") credentials;

  isRedisUnixSocket = lib.hasPrefix "/" cfg.redis.host;
  isDatabaseUnixSocket = lib.hasPrefix "/" cfg.database.host;
  databaseUrl = "postgresql://${lib.strings.escapeURL cfg.database.user}:$DATABASE_PASSWORD@${lib.strings.escapeURL cfg.database.host}${
    lib.optionalString (
      !isDatabaseUnixSocket && cfg.database.port != null
    ) ":${toString cfg.database.port}"
  }/${lib.strings.escapeURL cfg.database.name}";

  redisEnv =
    if isRedisUnixSocket then
      {
        REDIS_URL = "unix://${cfg.redis.host}";
      }
    else
      {
        # Does not support passwords, but upstream does not provide an adequate env variable
        # Perhaps patch or make a PR upstream in the future
        REDIS_URL = "redis://${cfg.redis.host}:${toString cfg.redis.port}";
      };

  greenlight-rake = pkgs.writeShellApplication {
    name = "greenlight-rake";

    text =
      let
        command = pkgs.writeShellScript "greenlight-rake-unwrapped" ''
          ${loadCredentialsIntoEnv}
          export DATABASE_PASSWORD="''${DATABASE_PASSWORD:-}"
          export DATABASE_URL="${databaseUrl}"
          exec ${lib.getExe' cfg.package.rubyEnv "rake"} "$@"
        '';
        env' = lib.filterAttrs (_: value: value != null) configEnv;
        supplementaryGroups = lib.optionalString (cfg.redis.createLocally && isRedisUnixSocket) (
          lib.escapeShellArg "--property=SupplementaryGroups=${config.services.redis.servers.greenlight.group}"
        );
      in
      ''
        exec ${lib.getExe' config.systemd.package "systemd-run"} \
          ${
            lib.escapeShellArgs (map (credential: "--property=LoadCredential=${credential}") loadCredentials)
          } \
          ${
            lib.escapeShellArgs (lib.mapAttrsToList (name: value: "--setenv=${name}=${toString value}") env')
          } \
          --uid=${lib.escapeShellArg cfg.user} \
          --gid=${lib.escapeShellArg cfg.group} \
          ${supplementaryGroups} \
          --working-directory=${lib.escapeShellArg cfg.package}/share/greenlight \
          --property=PrivateTmp=yes \
          --pty \
          --wait \
          --collect \
          --service-type=exec \
          --quiet \
          -- \
          ${command} "$@"
      '';
  };

  defaultServiceConfig = {
    User = cfg.user;
    Group = cfg.group;
    WorkingDirectory = "${cfg.package}/share/greenlight";
    StateDirectory = [
      "greenlight"
      "greenlight/secrets"
      "greenlight/storage"
    ];
    StateDirectoryMode = "0700";
    LogsDirectory = "greenlight";
    # Service hardening
    ReadWritePaths = [
      dataDir
      "/var/log/greenlight"
    ];
    CacheDirectory = "greenlight";
    AmbientCapabilities = "";
    CapabilityBoundingSet = "";
    # ProtectClock adds DeviceAllow=char-rtc r
    DeviceAllow = "";
    DevicePolicy = "closed";
    LockPersonality = true;
    # Loosening setting, required by Ruby daemon
    MemoryDenyWriteExecute = false;
    NoNewPrivileges = true;
    RemoveIPC = true;
    PrivateDevices = true;
    PrivateMounts = true;
    PrivateTmp = true;
    PrivateUsers = true;
    ProtectClock = true;
    ProtectHome = true;
    ProtectHostname = true;
    ProtectSystem = "strict";
    ProtectControlGroups = true;
    ProtectKernelLogs = true;
    ProtectKernelModules = true;
    ProtectKernelTunables = true;
    ProtectProc = "invisible";
    ProcSubset = "pid";
    RestrictAddressFamilies = [
      "AF_UNIX"
      "AF_INET"
      "AF_INET6"
    ];
    RestrictNamespaces = true;
    RestrictRealtime = true;
    RestrictSUIDSGID = true;
    SystemCallArchitectures = "native";
    SystemCallFilter = [
      "@system-service"
      # Loosening setting, required by Ruby daemon
      #"~@privileged @setuid @keyring"
    ];
    UMask = "0077";

    # ensure permissions to connect to the redis socket
    SupplementaryGroups = lib.mkIf (cfg.redis.createLocally && isRedisUnixSocket) [
      config.services.redis.servers.greenlight.group
    ];
  };

in
{
  meta = {
    buildDocsInSandbox = false;
    maintainers = [ lib.maintainers.onny ];
    teams = [ lib.teams.ngi ];
  };

  options.services.greenlight = {

    enable = lib.mkEnableOption "Greenlight web interface for BigBlueButton";

    package = lib.mkPackageOption pkgs "greenlight" { };

    database = {
      createLocally = lib.mkOption {
        description = ''
          Whether to configure a local PostgreSQL server and database for Greenlight.
          The connection is performed via Unix sockets.
        '';
        type = lib.types.bool;
        default = true;
      };

      host = lib.mkOption {
        type = lib.types.str;
        default = "/run/postgresql";
        example = "127.0.0.1";
        description = "Hostname or address of the postgresql server. If an absolute path is given here, it will be interpreted as a unix socket path.";
      };

      port = lib.mkOption {
        type = lib.types.nullOr lib.types.port;
        default = 5432;
        description = "Port of the postgresql server.";
      };

      name = lib.mkOption {
        type = lib.types.str;
        default = "greenlight";
        description = "The name of the Greenlight database.";
      };

      user = lib.mkOption {
        type = lib.types.str;
        default = "greenlight";
        description = "The database user for Greenlight.";
      };

      passwordFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        example = "/run/keys/greenlight-db-password";
        description = ''
          A file containing the password corresponding to {option}`${opt.database.user}`.
        '';
      };
    };

    redis = {
      createLocally = lib.mkOption {
        description = ''
          Whether to configure a local Redis server for Greenlight.
          The connection is performed via Unix sockets by default,
          but that can be changed by configuring {option}`${opt.redis.host}` and {option}`${opt.redis.port}`.
        '';
        type = lib.types.bool;
        default = true;
      };

      host = lib.mkOption {
        description = "The redis host Greenlight will connect to.";
        type = lib.types.str;
        default =
          if cfg.redis.createLocally then config.services.redis.servers.greenlight.unixSocket else null;
        defaultText = lib.literalExpression "config.services.redis.servers.greenlight.unixSocket";
      };

      port = lib.mkOption {
        description = "The port of the redis server Greenlight will connect to. Set to zero to disable TCP and use Unix sockets instead.";
        type = lib.types.port;
        default = 0;
      };
    };

    configureNginx = lib.mkOption {
      description = ''
        Configure nginx as a reverse proxy for Greenlight.
        Alternatively you can configure a reverse-proxy of your choice to serve specific
        paths. Take a look at Greenlight's provided reverse proxy configurations at
        `https://github.com/bigbluebutton/greenlight/blob/master/greenlight-v3.nginx`.
      '';
      type = lib.types.bool;
      default = true;
    };

    user = lib.mkOption {
      description = ''
        User under which Greenlight runs. If it is set to "greenlight",
        that user will be created, otherwise it should be set to the
        name of a user created elsewhere.
      '';
      type = lib.types.str;
      default = "greenlight";
    };

    group = lib.mkOption {
      description = ''
        Group under which Greenlight runs.
      '';
      type = lib.types.str;
      default = "greenlight";
    };

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = lib.types.attrsOf (
          lib.types.nullOr (
            lib.types.oneOf [
              lib.types.str
              lib.types.bool
              lib.types.int
              lib.types.port
              lib.types.path
            ]
          )
        );
        options = {
          URL_HOST = lib.mkOption {
            type = lib.types.str;
            default = "localhost";
            description = "Hostname to use";
          };
          PORT = lib.mkOption {
            type = lib.types.port;
            default = 6346;
            description = "Port for the puma daemon to bind to.";
          };
          BINDING = lib.mkOption {
            type = lib.types.str;
            default = "127.0.0.1";
            description = "Address for the puma daemon to bind to.";
          };
        };
      };
      default = { };
      description = ''
        Extra configuration options to append or override.
        For available and default option values see
        [upstream configuration file](https://github.com/bigbluebutton/greenlight/blob/master/sample.env).
      '';
    };

    secretKeyBaseFile = lib.mkOption {
      description = ''
        Path to file containing the secret key base.
        The content of the file will be sourced into {env}`SECRET_KEY_BASE` environment
        variable. The secret has a minimum length requirement of 64 bytes.

        One way to generate such a secret is to use `openssl rand -hex 64`.

        This file is loaded using systemd credentials, and therefore does not need to be
        owned by the greenlight user.

        If this option is null, it will be created at ${defaultSecretKeyBaseFile}
        with a new secret key base.
      '';
      default = null;
      type = lib.types.nullOr lib.types.str;
    };

  };

  config = lib.mkIf cfg.enable {

    assertions = [
      {
        assertion = !isRedisUnixSocket -> cfg.redis.port != 0;
        message = ''
          `services.greenlight.redis.port` needs to be configured if `services.greenlight.redis.host` is not a unix socket.
        '';
      }
      {
        assertion = !isDatabaseUnixSocket -> cfg.database.port != null;
        message = ''
          `services.greenlight.database.port` needs to be configured if `services.greenlight.database.host` is not a unix socket.
        '';
      }
      {
        assertion = cfg.database.passwordFile == null || !isDatabaseUnixSocket;
        message = ''
          `services.greenlight.database.passwordFile` has no effect when `services.greenlight.database.host`
          is a unix socket, since local socket connections normally authenticate via peer/ident, not a password.
          Either point `database.host` at a TCP address, or drop `passwordFile`.
        '';
      }
      {
        assertion = !(cfg.database.createLocally && cfg.database.passwordFile != null);
        message = ''
          `services.greenlight.database.passwordFile` is set, but `database.createLocally` is also enabled.
          The PostgreSQL role created via `ensureUsers` has no password configured, so authentication would
          fail. Either disable `database.createLocally` and use an external database, or configure the local
          role's password yourself (e.g. via `services.postgresql.initialScript`) and keep it in sync with
          `passwordFile`.
        '';
      }
      {
        assertion = cfg.database.createLocally && isDatabaseUnixSocket -> cfg.database.user == cfg.user;
        message = ''
          services.greenlight.database.user must equal services.greenlight.user when
          services.greenlight.database.createLocally is true and services.greenlight.database.host
          is a unix socket, since the local PostgreSQL connection authenticates via peer auth
          (OS user must match the Postgres role name).
        '';
      }
    ];

    services.greenlight.settings = lib.mkMerge [
      {
        RAILS_ENV = lib.mkDefault "production";
        RAILS_ROOT = "${cfg.package}/share/greenlight";
        BUNDLE_WITHOUT = "development:test";
        BUNDLE_USER_HOME = "/tmp/bundle"; # will use private tmp inside systemd unit
      }
      redisEnv
    ];

    systemd.services.greenlight-init-credentials = lib.mkIf needsGenCredentialsUnit {
      script = ''
        if ! test -f ${defaultSecretKeyBaseFile}; then
          ${lib.getExe' cfg.package.rubyEnv "bundle"} exec rails secret > ${defaultSecretKeyBaseFile}
        fi
      '';
      serviceConfig = {
        Type = "oneshot";
        SyslogIdentifier = "greenlight-init-dirs";
      }
      // defaultServiceConfig;
      environment = configEnv;
      after = [ "network.target" ];
    };

    systemd.services."greenlight-seeder" = {
      script = ''
        set -o pipefail -o nounset
        shopt -s inherit_errexit
        ${loadCredentialsIntoEnv}

        export DATABASE_PASSWORD="''${DATABASE_PASSWORD:-}"
        export DATABASE_URL="${databaseUrl}"

        # Auto-migrate on first run or if the package has changed
        versionFile="${dataDir}/src-version"
        version=$(cat "$versionFile" 2>/dev/null || echo 0)

        if [[ $version == 0 ]]; then
          echo "Initialising database and running seed..."
          DISABLE_DATABASE_ENVIRONMENT_CHECK=1 rails db:migrate db:migrate:with_data
          echo ${cfg.package.version} > "$versionFile"
        elif [[ $version != ${cfg.package.version} ]]; then
          echo "Executing database migration and database seed..."
          rails db:migrate db:migrate:with_data
          echo ${cfg.package.version} > "$versionFile"
        fi
      '';
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        LoadCredential = loadCredentials;
      }
      // defaultServiceConfig;
      path = [ cfg.package.rubyEnv ];
      environment = configEnv;
      wants = lib.optional cfg.database.createLocally "postgresql.target";
      after = [
        "network.target"
      ]
      ++ lib.optional cfg.database.createLocally "postgresql.target"
      ++ lib.optional needsGenCredentialsUnit "greenlight-init-credentials.service"
      ++ lib.optional cfg.redis.createLocally "redis-greenlight.service";
      requires =
        lib.optional needsGenCredentialsUnit "greenlight-init-credentials.service"
        ++ lib.optional cfg.database.createLocally "postgresql.target"
        ++ lib.optional cfg.redis.createLocally "redis-greenlight.service";
    };

    systemd.services."greenlight-web" = {
      script = ''
        ${loadCredentialsIntoEnv}

        export DATABASE_PASSWORD="''${DATABASE_PASSWORD:-}"
        export DATABASE_URL="${databaseUrl}"

        ${lib.getExe' cfg.package.rubyEnv "bundle"} exec rails server -u puma
      '';
      serviceConfig = {
        LoadCredential = loadCredentials;
      }
      // defaultServiceConfig;
      environment = configEnv;
      bindsTo = [ "greenlight-seeder.service" ];
      after = [
        "greenlight-seeder.service"
      ]
      ++ lib.optional needsGenCredentialsUnit "greenlight-init-credentials.service"
      ++ lib.optional cfg.database.createLocally "postgresql.target"
      ++ lib.optional cfg.redis.createLocally "redis-greenlight.service";
      requires =
        lib.optional needsGenCredentialsUnit "greenlight-init-credentials.service"
        ++ lib.optional cfg.database.createLocally "postgresql.target"
        ++ lib.optional cfg.redis.createLocally "redis-greenlight.service";
      wantedBy = [ "multi-user.target" ];
    };

    services.redis.servers = lib.mkIf cfg.redis.createLocally {
      greenlight = {
        enable = true;
        port = cfg.redis.port;
        bind = lib.mkIf (!isRedisUnixSocket) cfg.redis.host;
      };
    };

    services.postgresql = lib.mkIf cfg.database.createLocally {
      enable = true;
      ensureUsers = [
        {
          name = cfg.database.user;
          ensureDBOwnership = true;
        }
      ];
      ensureDatabases = [ cfg.database.name ];
    };

    services.nginx = lib.mkIf cfg.configureNginx {
      enable = true;
      # See https://github.com/bigbluebutton/greenlight/blob/master/greenlight-v3.nginx
      virtualHosts."${cfg.settings.URL_HOST}" =
        let
          bbbProxyHeaders = ''
            proxy_redirect off;
            proxy_http_version 1.1;
            proxy_set_header Host "${cfg.settings.URL_HOST}";
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
          '';
        in
        {
          root = "${cfg.package}/share/greenlight/public";
          locations."/" = {
            tryFiles = "$uri @greenlight";
          };
          locations."@greenlight" = {
            proxyPass = "http://${listeningAddress}";
            extraConfig = bbbProxyHeaders;
          };
          locations."/cable" = {
            proxyPass = "http://${listeningAddress}";
            extraConfig = bbbProxyHeaders + ''
              proxy_set_header Connection "upgrade";
              proxy_set_header Upgrade $http_upgrade;
            '';
          };
          locations."@bbb-fe" = {
            proxyPass = "http://${listeningAddress}";
            extraConfig = bbbProxyHeaders + ''
              proxy_set_header Connection "";
              proxy_buffer_size 128k;
              proxy_buffers 4 256k;
              proxy_busy_buffers_size 256k;
            '';
          };
          locations."~ '/api/v1/rooms/\\w{3}-\\w{3}-\\w{3}-\\w{3}\\.json$'" = {
            proxyPass = "http://${listeningAddress}";
            extraConfig = bbbProxyHeaders + ''
              proxy_set_header Connection "";
              client_max_body_size 31m;
            '';
          };
          locations."~ '/api/v1/users/\\w{8}-\\w{4}-\\w{4}-\\w{4}-\\w{12}\\.json$'" = {
            proxyPass = "http://${listeningAddress}";
            extraConfig = bbbProxyHeaders + ''
              proxy_set_header Connection "";
              client_max_body_size 4m;
            '';
          };
          locations."~ /api/v1/admin/site_settings/BrandingImage\\.json$" = {
            proxyPass = "http://${listeningAddress}";
            extraConfig = bbbProxyHeaders + ''
              proxy_set_header Connection "";
              client_max_body_size 4m;
            '';
          };
        };
    };

    users.users = lib.mkIf (cfg.user == "greenlight") {
      greenlight = {
        isSystemUser = true;
        home = cfg.package;
        inherit (cfg) group;
      };
    };
    users.groups = lib.mkIf (cfg.group == "greenlight") { ${cfg.group} = { }; };

    environment.systemPackages = [ greenlight-rake ];

  };
}
