{
  lib,
  pkgs,
  config,
  options,
  ...
}:

let
  cfg = config.services.sure;
  opt = options.services.sure;

  isRedisUnixSocket = lib.hasPrefix "/" cfg.redis.host;

  redisEnv =
    if isRedisUnixSocket then
      {
        REDIS_URL = "unix://${config.services.redis.servers.sure.unixSocket}";
      }
    else
      {
        REDIS_URL = "redis://${cfg.redis.host}:${toString cfg.redis.port}";
      };

  env = {
    RAILS_ENV = "production";
    NODE_ENV = "production";

    SELF_HOSTED = "true";

    RAILS_FORCE_SSL = toString cfg.forceSSL;
    RAILS_ASSUME_SSL = toString cfg.assumeSSL;

    DB_HOST = cfg.database.host;
    DB_PORT = toString cfg.database.port;

    POSTGRES_USER = cfg.database.user;
    POSTGRES_DB = cfg.database.name;

    PORT = toString cfg.webPort;
  }
  // redisEnv
  // cfg.environment;

  systemCallFilter =
    let
      allowedSystemCalls = [
        "@cpu-emulation"
        "@debug"
        "@keyring"
        "@ipc"
        "@mount"
        "@obsolete"
        "@privileged"
        "@setuid"
      ];
    in
    [
      ("~" + lib.concatStringsSep " " allowedSystemCalls)
      "@chown"
      "pipe"
      "pipe2"
    ];

  cfgService = {
    User = cfg.user;
    Group = cfg.group;
    WorkingDirectory = cfg.package;
    CacheDirectory = "sure";
    CacheDirectoryMode = "0750";
    StateDirectory = "sure";
    StateDirectoryMode = "0750";
    LogsDirectory = "sure";
    LogsDirectoryMode = "0750";
    ProcSubset = "pid";
    ProtectProc = "invisible";
    UMask = "0027";
    CapabilityBoundingSet = "";
    NoNewPrivileges = true;
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
    RestrictAddressFamilies = [
      "AF_UNIX"
      "AF_INET"
      "AF_INET6"
      "AF_NETLINK"
    ];
    RestrictNamespaces = true;
    LockPersonality = true;
    MemoryDenyWriteExecute = false;
    RestrictRealtime = true;
    RestrictSUIDSGID = true;
    RemoveIPC = true;
    PrivateMounts = true;
    SystemCallArchitectures = "native";
    SystemCallFilter = systemCallFilter;

    # ensure permissions to connect to the redis socket
    SupplementaryGroups = lib.mkIf (cfg.redis.createLocally && isRedisUnixSocket) [
      config.services.redis.servers.sure.group
    ];
  };

  # Units that all Sure units After= and Requires= on
  commonUnits =
    lib.optional cfg.redis.createLocally "redis-sure.service"
    ++ lib.optional cfg.database.createLocally "postgresql.target"
    ++ lib.optional cfg.automaticMigrations "sure-init-db.service";

  defaultSecretKeyBaseFile = "${cfg.statePath}/secrets/secret-key-base";
  needsGenCredentialsUnit = cfg.secretKeyBaseFile == null;
  credentials = {
    SECRET_KEY_BASE = lib.defaultTo defaultSecretKeyBaseFile cfg.secretKeyBaseFile;
  }
  // lib.optionalAttrs (cfg.database.passwordFile != null) {
    POSTGRES_PASSWORD = cfg.database.passwordFile;
  };
  loadCredentialsIntoEnv = lib.concatMapAttrsStringSep "\n" (
    name: _: ''export ${name}="$(systemd-creds cat ${name})"''
  ) credentials;
  loadCredentials = lib.mapAttrsToList (name: path: "${name}:${path}") credentials;

  sureRails = pkgs.writeShellApplication {
    name = "sure-rails";

    text =
      let
        sourceExtraEnv = lib.concatMapStrings (p: "source ${p}\n") cfg.extraEnvFiles;
        command = pkgs.writeShellScript "sure-rails-unwrapped" ''
          ${sourceExtraEnv}
          ${loadCredentialsIntoEnv}
          export RAILS_ROOT="${cfg.package}"
          exec ${lib.getExe' cfg.package.rubyEnv "bundle"} exec rails "$@"
        '';
        env' = lib.filterAttrs (_: value: value != null) env;
        supplementaryGroups = lib.optionalString (cfg.redis.createLocally && isRedisUnixSocket) (
          lib.escapeShellArg "--property=SupplementaryGroups=${config.services.redis.servers.sure.group}"
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
          --working-directory=${lib.escapeShellArg cfg.package} \
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
  sureConsole = pkgs.writeShellScriptBin "sure-console" ''
    exec ${lib.getExe sureRails} console "$@"
  '';

in
{

  options = {
    services.sure = {
      enable = lib.mkEnableOption "Sure, a personal finance app for everyone";

      configureNginx = lib.mkOption {
        description = ''
          Configure nginx as a reverse proxy for Sure.
          Alternatively you can configure a reverse-proxy of your choice to serve these paths:

          `/ -> ''${pkgs.sure}/public`

          `/ -> 127.0.0.1:{{ webPort }} `(If there was no file in the directory above.)

          Make sure that websockets are forwarded properly for ActionCable.
        '';
        type = lib.types.bool;
        default = true;
      };

      user = lib.mkOption {
        description = ''
          User under which Sure runs. If it is set to "sure",
          that user will be created, otherwise it should be set to the
          name of a user created elsewhere.
        '';
        type = lib.types.str;
        default = "sure";
      };

      group = lib.mkOption {
        description = ''
          Group under which Sure runs.
        '';
        type = lib.types.str;
        default = "sure";
      };

      webPort = lib.mkOption {
        description = "TCP port used by the Sure web service.";
        type = lib.types.port;
        default = 3000;
      };

      sidekiqThreads = lib.mkOption {
        description = ''
          Worker threads used by the Sure Sidekiq service.
        '';
        type = lib.types.int;
        default = 5;
      };

      forceSSL = lib.mkOption {
        description = ''
          Whether to force SSL via Rails. When enabled, all requests are redirected to HTTPS.
        '';
        type = lib.types.bool;
        default = false;
      };

      assumeSSL = lib.mkOption {
        description = ''
          Whether to assume SSL is terminated at the proxy. This sets the X-Forwarded-Proto header.
        '';
        type = lib.types.bool;
        default = false;
      };

      localDomain = lib.mkOption {
        description = "The domain serving your Sure instance.";
        example = "sure.example.org";
        type = lib.types.str;
      };

      secretKeyBaseFile = lib.mkOption {
        description = ''
          Path to file containing the secret key base.
          A new secret key base can be generated by running:

          `openssl rand -hex 64`

          This file is loaded using systemd credentials, and therefore does not need to be
          owned by the sure user.

          If this option is null, it will be created at `''${config.services.sure.statePath}/secrets/secret-key-base`
          with a new secret key base.
        '';
        default = null;
        type = lib.types.nullOr lib.types.str;
      };

      redis = {
        createLocally = lib.mkOption {
          description = ''
            Whether to configure a local Redis server for Sure.
            The connection is performed via Unix sockets by default,
            but that can be changed by configuring {option}`services.sure.redis.host` and {option}`services.sure.redis.port`.
          '';
          type = lib.types.bool;
          default = true;
        };

        host = lib.mkOption {
          description = "The redis host Sure will connect to.";
          type = lib.types.str;
          default = config.services.redis.servers.sure.unixSocket;
          defaultText = lib.literalExpression "config.services.redis.servers.sure.unixSocket";
        };

        port = lib.mkOption {
          description = "The port of the redis server Sure will connect to. Set to zero to disable TCP and use Unix sockets instead.";
          type = lib.types.port;
          default = 0;
        };
      };

      database = {
        createLocally = lib.mkOption {
          description = ''
            Whether to configure a local PostgreSQL server and database for Sure.
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
          default = "sure";
          description = "The name of the Sure database.";
        };

        user = lib.mkOption {
          type = lib.types.str;
          default = "sure";
          description = "The database user for Sure.";
        };

        passwordFile = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          default = null;
          example = "/run/keys/sure-db-password";
          description = ''
            A file containing the password corresponding to {option}`services.sure.database.user`.
          '';
        };
      };

      package = lib.mkPackageOption pkgs "sure" { };

      environment = lib.mkOption {
        type =
          with lib.types;
          attrsOf (
            nullOr (oneOf [
              str
              path
              package
            ])
          );
        default = { };
        description = ''
          Extra environment variables to pass to all Sure services.
        '';
      };

      extraEnvFiles = lib.mkOption {
        type = with lib.types; listOf path;
        default = [ ];
        description = ''
          Extra environment files to pass to all Sure services. Useful for passing down environment secrets.
        '';
        example = [ "/etc/sure/secret.env" ];
      };

      statePath = lib.mkOption {
        description = "Path where Sure stores its state.";
        type = lib.types.str;
        default = "/var/lib/sure";
      };

      automaticMigrations = lib.mkOption {
        description = "Whether to perform database migrations automatically.";
        type = lib.types.bool;
        default = true;
      };
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        assertions = [
          {
            assertion = !isRedisUnixSocket -> cfg.redis.port != 0;
            message = ''
              `services.sure.redis.port` needs to be configured if `services.sure.redis.host` is not a unix socket.
            '';
          }
        ];

        environment.systemPackages = [
          sureConsole
          sureRails
        ];

        systemd = {
          tmpfiles.rules = [
            "d /run/sure 0750 ${cfg.user} ${cfg.group} -"
            "d ${cfg.statePath} 0750 ${cfg.user} ${cfg.group} -"
            "d ${cfg.statePath}/tmp 0750 ${cfg.user} ${cfg.group} -"
            "d ${cfg.statePath}/log 0750 ${cfg.user} ${cfg.group} -"
            "d ${cfg.statePath}/storage 0750 ${cfg.user} ${cfg.group} -"

            "L+ /run/sure/tmp - - - - ${cfg.statePath}/tmp"
            "L+ /run/sure/log - - - - ${cfg.statePath}/log"
            "L+ /run/sure/storage - - - - ${cfg.statePath}/storage"
          ];

          targets.sure = {
            description = "Target for all Sure services";
            wantedBy = [ "multi-user.target" ];
            after = [ "network.target" ];
          };

          services.sure-init-credentials = lib.mkIf needsGenCredentialsUnit {
            script = ''
              umask 077
            ''
            + lib.optionalString (cfg.secretKeyBaseFile == null) ''
              if ! test -f ${defaultSecretKeyBaseFile}; then
                mkdir -p $(dirname ${defaultSecretKeyBaseFile})
                ${lib.getExe pkgs.openssl} rand -hex 64 > ${defaultSecretKeyBaseFile}
              fi
            '';

            environment = env;
            serviceConfig = {
              Type = "oneshot";
              SyslogIdentifier = "sure-init-credentials";
              # System Call Filtering
              SystemCallFilter = [ "~@resources" ] ++ systemCallFilter;
            }
            // cfgService;

            after = [ "network.target" ];
          };

          services.sure-init-db = lib.mkIf cfg.automaticMigrations {
            script = ''
              ${loadCredentialsIntoEnv}

              echo "Running database migrations..."
              ${lib.getExe' cfg.package.rubyEnv "bundle"} exec rails db:prepare
            '';
            path = [ cfg.package ];
            environment = env;
            serviceConfig = {
              Type = "oneshot";
              LoadCredential = loadCredentials;
              EnvironmentFile = cfg.extraEnvFiles;
              WorkingDirectory = cfg.package;
              # System Call Filtering
              SystemCallFilter = [ "~@resources" ] ++ systemCallFilter;
            }
            // cfgService;
            # both postgres and redis are needed for the migrations to work
            after = [
              "network.target"
            ]
            ++ lib.optional needsGenCredentialsUnit "sure-init-credentials.service"
            ++ lib.optional cfg.database.createLocally "postgresql.target"
            ++ lib.optional cfg.redis.createLocally "redis-sure.service";
            requires =
              lib.optional needsGenCredentialsUnit "sure-init-credentials.service"
              ++ lib.optional cfg.database.createLocally "postgresql.target"
              ++ lib.optional cfg.redis.createLocally "redis-sure.service";
          };

          services.sure-web = {
            after = [
              "network.target"
            ]
            ++ lib.optional needsGenCredentialsUnit "sure-init-credentials.service"
            ++ commonUnits;
            requires = lib.optional needsGenCredentialsUnit "sure-init-credentials.service" ++ commonUnits;
            wantedBy = [ "sure.target" ];
            description = "Sure web";
            environment = env;
            script = ''
              ${loadCredentialsIntoEnv}

              ${lib.getExe' cfg.package.rubyEnv "bundle"} exec rails server
            '';
            serviceConfig = {
              Restart = "always";
              RestartSec = 20;
              LoadCredential = loadCredentials;
              EnvironmentFile = cfg.extraEnvFiles;
              WorkingDirectory = cfg.package;
              # Runtime directory and mode
              RuntimeDirectory = "sure-web";
              RuntimeDirectoryMode = "0750";
            }
            // cfgService;
          };

          services.sure-sidekiq = {
            after = [
              "network.target"
            ]
            ++ lib.optional needsGenCredentialsUnit "sure-init-credentials.service"
            ++ commonUnits;
            requires = lib.optional needsGenCredentialsUnit "sure-init-credentials.service" ++ commonUnits;
            wantedBy = [ "sure.target" ];
            description = "Sure Sidekiq background jobs";
            environment = env // {
              RAILS_MAX_THREADS = toString cfg.sidekiqThreads;
            };
            script = ''
              ${loadCredentialsIntoEnv}

              ${lib.getExe' cfg.package.rubyEnv "bundle"} exec sidekiq -c ${toString cfg.sidekiqThreads}
            '';
            serviceConfig = {
              Restart = "always";
              RestartSec = 20;
              LoadCredential = loadCredentials;
              EnvironmentFile = cfg.extraEnvFiles;
              WorkingDirectory = cfg.package;
              LimitNOFILE = "1024000";
            }
            // cfgService;
          };
        };

        services = {
          nginx = lib.mkIf cfg.configureNginx {
            enable = true;
            virtualHosts."${cfg.localDomain}" = {
              root = "${cfg.package}/public/";

              locations."/" = {
                tryFiles = "$uri @proxy";
              };

              locations."@proxy" = {
                proxyPass = "http://127.0.0.1:${toString cfg.webPort}";
                recommendedProxySettings = true;
                proxyWebsockets = true;
              };
            };
          };

          redis.servers = lib.mkIf cfg.redis.createLocally {
            sure = {
              enable = true;
              port = cfg.redis.port;
              bind = lib.mkIf (!isRedisUnixSocket) cfg.redis.host;
            };
          };

          postgresql = lib.mkIf cfg.database.createLocally {
            enable = true;
            ensureUsers = [
              {
                name = cfg.database.user;
                ensureDBOwnership = true;
              }
            ];
            ensureDatabases = [ cfg.database.name ];
          };
        };

        users.users = lib.mkIf (cfg.user == "sure") {
          sure = {
            isSystemUser = true;
            home = cfg.package;
            inherit (cfg) group;
          };
        };
        users.groups = lib.mkIf (cfg.group == "sure") { ${cfg.group} = { }; };
      }
    ]
  );

  meta.maintainers = with lib.maintainers; [
    _74k1
    pjrm
  ];

}
