{
  config,
  lib,
  pkgs,
  utils,
  ...
}:
let
  inherit (lib)
    concatMapStringsSep
    concatStringsSep
    escapeShellArg
    getExe
    hasSuffix
    mapAttrs
    match
    mkEnableOption
    mkIf
    mkPackageOption
    mkOption
    types
    optional
    optionalString
    ;

  cfg = config.services.lasuite-messages;

  pythonEnvironment = mapAttrs (
    _: value:
    if value == null then
      "None"
    else if value == true then
      "True"
    else if value == false then
      "False"
    else
      toString value
  ) cfg.settings;

  commonServiceConfig = {
    RuntimeDirectory = "lasuite-messages";
    StateDirectory = "lasuite-messages";
    WorkingDirectory = "/var/lib/lasuite-messages";

    User = "lasuite-messages";
    DynamicUser = true;
    SupplementaryGroups = mkIf cfg.redis.createLocally [
      config.services.redis.servers.lasuite-messages.group
    ];
    # hardening
    AmbientCapabilities = "";
    CapabilityBoundingSet = [ "" ];
    DevicePolicy = "closed";
    LockPersonality = true;
    NoNewPrivileges = true;
    PrivateDevices = true;
    PrivateTmp = true;
    PrivateUsers = true;
    ProcSubset = "pid";
    ProtectClock = true;
    ProtectControlGroups = true;
    ProtectHome = true;
    ProtectHostname = true;
    ProtectKernelLogs = true;
    ProtectKernelModules = true;
    ProtectKernelTunables = true;
    ProtectProc = "invisible";
    ProtectSystem = "strict";
    RemoveIPC = true;
    MemoryDenyWriteExecute = true;
    RestrictAddressFamilies = [
      "AF_INET"
      "AF_INET6"
      "AF_UNIX"
    ];
    RestrictNamespaces = true;
    RestrictRealtime = true;
    RestrictSUIDSGID = true;
    SystemCallArchitectures = "native";
    UMask = "0077";
    EnvironmentFile = cfg.environmentFiles;
  };

  # Convert environment variables to be used as systemd-run arguments
  envArgs = lib.concatStringsSep " " (
    lib.mapAttrsToList (name: value: "-E ${escapeShellArg "${name}=${value}"}") pythonEnvironment
  );

  # Easier usage of django manage.py stuff
  manage = pkgs.writeShellScriptBin "lasuite-messages-manage" ''
    exec ${lib.getExe' config.systemd.package "systemd-run"} \
      -p User=${commonServiceConfig.User} \
      -p DynamicUser=yes \
      -p StateDirectory=${commonServiceConfig.StateDirectory} \
      ${optionalString cfg.redis.createLocally "-p SupplementaryGroups=${config.services.redis.servers.lasuite-messages.group} \\"}
      ${concatMapStringsSep "\n" (envFile: "-p EnvironmentFile=${envFile} \\") cfg.environmentFiles}
      --working-directory=${commonServiceConfig.WorkingDirectory} \
      --quiet --collect --pipe --pty \
      ${envArgs} ${lib.getExe cfg.package} "$@"
  '';
in
{
  options.services.lasuite-messages = {
    enable = mkEnableOption "SuiteNumérique Messages";

    package = mkPackageOption pkgs "lasuite-messages" { };

    bind = mkOption {
      type = types.str;
      default = "unix:/run/lasuite-messages/gunicorn.sock";
      example = "127.0.0.1:8000";
      description = ''
        The path, host/port or file descriptior to bind the gunicorn socket to.

        See  <https://docs.gunicorn.org/en/stable/settings.html#bind> for possible options.
      '';
    };

    enableNginx = mkEnableOption "enable and configure Nginx for reverse proxying" // {
      default = true;
    };

    secretKeyPath = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        Path to the Django secret key.

        The key can be generated using:
        ```
        python3 -c 'import secrets; print(secrets.token_hex())'
        ```

        :::{.note}
        If not specified, a secret key is automatically generated and stored in the state directory.
        :::
      '';
    };

    postgresql = {
      createLocally = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Configure local PostgreSQL database server for messages.
        '';
      };
    };

    redis = {
      createLocally = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Configure local Redis cache server for messages.
        '';
      };
    };

    gunicorn = {
      extraArgs = mkOption {
        type = types.listOf types.str;
        default = [
          "--name=messages"
          "--workers=3"
        ];
        description = ''
          Extra arguments to pass to the gunicorn process.
        '';
      };
    };

    celery = {
      extraArgs = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = ''
          Extra arguments to pass to the celery process.
        '';
      };
    };

    domain = mkOption {
      type = types.str;
      description = ''
        Domain name of the messages instance.
      '';
    };

    settings = mkOption {
      type = types.submodule {
        freeformType = types.attrsOf (
          types.nullOr (
            types.oneOf [
              types.str
              types.bool
              types.path
              types.int
            ]
          )
        );

        options = {
          DJANGO_CONFIGURATION = mkOption {
            type = types.str;
            internal = true;
            default = "Production";
            description = "The configuration that Django will use";
          };

          DJANGO_SETTINGS_MODULE = mkOption {
            type = types.str;
            internal = true;
            default = "messages.settings";
            description = "The configuration module that Django will use";
          };

          DJANGO_SECRET_KEY_FILE = mkOption {
            type = types.path;
            default =
              if cfg.secretKeyPath == null then
                "/var/lib/lasuite-messages/django_secret_key"
              else
                cfg.secretKeyPath;
            description = "The path to the file containing Django's secret key";
          };

          DJANGO_DATA_DIR = mkOption {
            type = types.path;
            default = "/var/lib/lasuite-messages";
            description = "Path to the data directory";
            readOnly = true;
          };

          DJANGO_ALLOWED_HOSTS = mkOption {
            type = types.listOf types.str;
            default =
              if cfg.enableNginx then
                [
                  "localhost"
                  "127.0.0.1"
                  cfg.domain
                ]
              else
                [ ];
            defaultText = lib.literalExpression ''
              if cfg.enableNginx then [ "localhost" "127.0.0.1" cfg.domain ] else [ ]
            '';
            apply = list: concatStringsSep "," list;
            description = "Comma-separated list of hosts that are able to connect to the server";
          };

          DB_NAME = mkOption {
            type = types.str;
            default = "lasuite-messages";
            description = "Name of the database";
          };

          DB_USER = mkOption {
            type = types.str;
            default = "lasuite-messages";
            description = "User of the database";
          };

          DB_HOST = mkOption {
            type = types.nullOr types.str;
            default = if cfg.postgresql.createLocally then "/run/postgresql" else null;
            description = "Host of the database";
          };

          REDIS_URL = mkOption {
            type = types.nullOr types.str;
            default =
              if cfg.redis.createLocally then
                "unix://${config.services.redis.servers.lasuite-messages.unixSocket}?db=0"
              else
                null;
            description = "URL of the redis backend";
          };

          CELERY_BROKER_URL = mkOption {
            type = types.nullOr types.str;
            default =
              if cfg.redis.createLocally then
                "redis+socket://${config.services.redis.servers.lasuite-messages.unixSocket}?db=1"
              else
                null;
            description = "URL of the redis backend for celery";
          };
        };
      };
      default = { };
      example = ''
        {
          AWS_S3_ENDPOINT_URL = "https://s3.us-west.amazonaws.com";
        }
      '';
      description = ''
        Configuration options of messages.

        See <https://github.com/suitenumerique/messages/blob/v${cfg.package.version}/docs/env.md>

        `REDIS_URL` and `CELERY_BROKER_URL` are set if `services.lasuite-messages.redis.createLocally` is true.
        `DB_HOST` is set if `services.lasuite-messages.postgresql.createLocally` is true.
      '';
    };

    environmentFiles = mkOption {
      type = types.listOf types.path;
      default = [ ];
      description = ''
        Path to environment files.

        This can be useful to pass secrets to messages via tools like `agenix` or `sops`.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ manage ];

    systemd.services.lasuite-messages = {
      description = "Messages from SuiteNumérique";
      after = [
        "network-online.target"
      ]
      ++ (optional cfg.postgresql.createLocally "postgresql.service")
      ++ (optional cfg.redis.createLocally "redis-lasuite-messages.service");
      wants =
        (optional cfg.postgresql.createLocally "postgresql.service")
        ++ (optional cfg.redis.createLocally "redis-lasuite-messages.service");
      wantedBy = [ "multi-user.target" ];

      preStart = ''
        if [ ! -f .version ]; then
          touch .version
        fi

        ${optionalString (cfg.secretKeyPath == null) ''
          if [[ ! -f /var/lib/lasuite-messages/django_secret_key ]]; then
            (
              umask 0377
              tr -dc A-Za-z0-9 < /dev/urandom | head -c64 | ${pkgs.moreutils}/bin/sponge /var/lib/lasuite-messages/django_secret_key
            )
          fi
        ''}
        if [ "${cfg.package.version}" != "$(cat .version)" ]; then
          ${getExe cfg.package} migrate
          echo -n "${cfg.package.version}" > .version
        fi
      '';

      environment = pythonEnvironment;

      serviceConfig = {
        BindReadOnlyPaths = "${cfg.package}/share/static:/var/lib/lasuite-messages/static";

        ExecStart = utils.escapeSystemdExecArgs (
          [
            (lib.getExe' cfg.package "gunicorn")
            "--bind=${cfg.bind}"
          ]
          ++ cfg.gunicorn.extraArgs
          ++ [ "messages.wsgi:application" ]
        );
      }
      // commonServiceConfig;
    };

    systemd.services.lasuite-messages-celery = {
      description = "Messages Celery broker from SuiteNumérique";
      after = [
        "network-online.target"
      ]
      ++ (optional cfg.postgresql.createLocally "postgresql.service")
      ++ (optional cfg.redis.createLocally "redis-lasuite-messages.service");
      wants =
        (optional cfg.postgresql.createLocally "postgresql.service")
        ++ (optional cfg.redis.createLocally "redis-lasuite-messages.service");
      wantedBy = [ "multi-user.target" ];

      environment = pythonEnvironment;

      serviceConfig = {
        ExecStart = utils.escapeSystemdExecArgs (
          [ (lib.getExe' cfg.package "celery") ]
          ++ cfg.celery.extraArgs
          ++ [
            "--app=messages.celery_app"
            "worker"
          ]
        );
      }
      // commonServiceConfig;
    };

    systemd.services.lasuite-messages-beat = {
      description = "Messages Celery beat from SuiteNumérique";
      after = [
        "network-online.target"
      ]
      ++ (optional cfg.postgresql.createLocally "postgresql.service")
      ++ (optional cfg.redis.createLocally "redis-lasuite-messages.service");
      wants =
        (optional cfg.postgresql.createLocally "postgresql.service")
        ++ (optional cfg.redis.createLocally "redis-lasuite-messages.service");
      wantedBy = [ "multi-user.target" ];

      environment = pythonEnvironment;

      serviceConfig = {
        ExecStart = utils.escapeSystemdExecArgs (
          [ (lib.getExe' cfg.package "celery") ]
          ++ cfg.celery.extraArgs
          ++ [
            "--app=messages.celery_app"
            "beat"
          ]
        );
      }
      // commonServiceConfig;
    };

    services.postgresql = mkIf cfg.postgresql.createLocally {
      enable = true;
      ensureDatabases = [ "lasuite-messages" ];
      ensureUsers = [
        {
          name = "lasuite-messages";
          ensureDBOwnership = true;
        }
      ];
    };

    services.redis.servers.lasuite-messages = mkIf cfg.redis.createLocally { enable = true; };

    # from https://github.com/suitenumerique/messages/blob/9a04a37b06ef9adce710986b7da78546cb119a55/src/frontend/caddy/Caddyfile
    services.nginx = mkIf cfg.enableNginx {
      enable = true;

      virtualHosts.${cfg.domain} = {
        extraConfig = ''
          error_page 404 /index.html;
        '';

        root = cfg.package.frontend;

        locations."/" = {
          tryFiles = "$uri $uri.html index.html $uri/ =404";
        };

        locations."/assets/" = {
          extraConfig = ''
            add_header Cache-Control "public, max-age=31536000, immutable";
          '';
        };

        locations."/static/" = {
          alias = "${cfg.package}/share/static/";
        };

        locations."/api" = {
          proxyPass = "http://${cfg.bind}";
          recommendedProxySettings = true;
        };

        locations."/admin" = {
          proxyPass = "http://${cfg.bind}";
          recommendedProxySettings = true;
        };
      };
    };
  };

  meta = {
    buildDocsInSandbox = false;
    maintainers = [ lib.maintainers.soyouzpanda ];
  };
}
