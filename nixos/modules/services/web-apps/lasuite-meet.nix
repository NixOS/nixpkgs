{
  config,
  lib,
  pkgs,
  utils,
  ...
}:
let
  inherit (lib)
    getExe
    mapAttrs
    mkEnableOption
    mkIf
    mkPackageOption
    mkOption
    types
    optional
    optionalString
    ;

  cfg = config.services.lasuite-meet;

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
    RuntimeDirectory = "lasuite-meet";
    StateDirectory = "lasuite-meet";
    WorkingDirectory = "/var/lib/lasuite-meet";

    User = "lasuite-meet";
    DynamicUser = true;
    SupplementaryGroups = mkIf cfg.redis.createLocally [
      config.services.redis.servers.lasuite-meet.group
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
    RestrictAddressFamilies = [
      "AF_INET"
      "AF_INET6"
      "AF_UNIX"
    ];
    RestrictNamespaces = true;
    RestrictRealtime = true;
    RestrictSUIDSGID = true;
    SystemCallArchitectures = "native";
    MemoryDenyWriteExecute = true;
    EnvironmentFile = optional (cfg.environmentFile != null) cfg.environmentFile;
    UMask = "0077";
  };
in
{
  options.services.lasuite-meet = {
    enable = mkEnableOption "SuiteNumérique Meet";

    backendPackage = mkPackageOption pkgs "lasuite-meet" { };

    frontendPackage = mkPackageOption pkgs "lasuite-meet-frontend" { };

    bind = mkOption {
      type = types.str;
      default = "unix:/run/lasuite-meet/gunicorn.sock";
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

        If not set, the secret key will be automatically generated.
      '';
    };

    postgresql = {
      createLocally = mkEnableOption "Configure local PostgreSQL database server for meet";
    };

    redis = {
      createLocally = mkEnableOption "Configure local Redis cache server for meet";
    };

    livekit = {
      enable = mkEnableOption "Configure local livekit server" // {
        default = true;
      };

      openFirewall = mkEnableOption "Open firewall ports for livekit";

      keyFile = mkOption {
        type = lib.types.path;
        description = ''
          LiveKit key file holding one or multiple application secrets.
          Use `livekit-server generate-keys` to generate a random key name and secret.

          The file should have the YAML format `<keyname>: <secret>`.
          Example:
          `lasuite-meet: f6lQGaHtM5HfgZjIcec3cOCRfiDqIine4CpZZnqdT5cE`

          Individual key/secret pairs need to be passed to clients to connect to this instance.
        '';

      };

      settings = mkOption {
        type = types.attrs;
        default = { };
        description = ''
          Settings to pass to the livekit server.

          See `services.livekit.settings` for more details.
        '';
      };
    };

    gunicorn = {
      extraArgs = mkOption {
        type = types.listOf types.str;
        default = [
          "--name=meet"
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
        Domain name of the meet instance.
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
            default = "meet.settings";
            description = "The configuration module that Django will use";
          };

          DJANGO_SECRET_KEY_FILE = mkOption {
            type = types.path;
            default =
              if cfg.secretKeyPath == null then "/var/lib/lasuite-meet/django_secret_key" else cfg.secretKeyPath;
            description = "The path to the file containing Django's secret key";
          };

          DJANGO_DATA_DIR = mkOption {
            type = types.path;
            default = "/var/lib/lasuite-meet";
            description = "Path to the data directory";
          };

          DJANGO_ALLOWED_HOSTS = mkOption {
            type = types.str;
            default = if cfg.enableNginx then "localhost,127.0.0.1,${cfg.domain}" else "";
            defaultText = lib.literalExpression ''
              if cfg.enableNginx then "localhost,127.0.0.1,''${cfg.domain}" else ""
            '';
            description = "Comma-separated list of hosts that are able to connect to the server";
          };

          DB_NAME = mkOption {
            type = types.str;
            default = "lasuite-meet";
            description = "Name of the database";
          };

          DB_USER = mkOption {
            type = types.str;
            default = "lasuite-meet";
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
                "unix://${config.services.redis.servers.lasuite-meet.unixSocket}?db=0"
              else
                null;
            description = "URL of the redis backend";
          };

          CELERY_BROKER_URL = mkOption {
            type = types.nullOr types.str;
            default =
              if cfg.redis.createLocally then
                "redis+socket://${config.services.redis.servers.lasuite-meet.unixSocket}?db=1"
              else
                null;
            description = "URL of the redis backend for celery";
          };

          LIVEKIT_API_URL = mkOption {
            type = types.nullOr types.str;
            default = if cfg.enableNginx && cfg.livekit.enable then "http://${cfg.domain}/livekit" else null;
            defaultText = lib.literalExpression ''
              if cfg.enableNginx && cfg.livekit.enable then
                "http://$${cfg.domain}/livekit"
              else
                null
            '';
            description = "URL to the livekit server";
          };
        };
      };

      default = { };
      example = ''
        {
          DJANGO_ALLOWED_HOSTS = "*";
        }
      '';
      description = ''
        Configuration options of meet.
        See https://github.com/suitenumerique/meet/blob/v${cfg.backendPackage.version}/docs/env.md
        `REDIS_URL` and `CELERY_BROKER_URL` are set if `services.lasuite-meet.redis.createLocally` is true.
        `DB_NAME` `DB_USER` and `DB_HOST` are set if `services.lasuite-meet.postgresql.createLocally` is true.
      '';
    };

    environmentFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        Path to environment file.

        This can be useful to pass secrets to meet via tools like `agenix` or `sops`.
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.services.lasuite-meet = {
      description = "Meet from SuiteNumérique";
      after = [
        "network.target"
      ]
      ++ (optional cfg.postgresql.createLocally "postgresql.service")
      ++ (optional cfg.redis.createLocally "redis-lasuite-meet.service");

      wants =
        (optional cfg.postgresql.createLocally "postgresql.service")
        ++ (optional cfg.redis.createLocally "redis-lasuite-meet.service");

      wantedBy = [ "multi-user.target" ];

      preStart = ''
        if [ ! -f .version ]; then
          touch .version
        fi

        ${optionalString (cfg.secretKeyPath == null) ''
          if [[ ! -f /var/lib/lasuite-meet/django_secret_key ]]; then
            (
              umask 0377
              tr -dc A-Za-z0-9 < /dev/urandom | head -c64 | ${pkgs.moreutils}/bin/sponge /var/lib/lasuite-meet/django_secret_key
            )
          fi
        ''}
        if [ "${cfg.backendPackage.version}" != "$(cat .version)" ]; then
          ${getExe cfg.backendPackage} migrate
          echo -n "${cfg.backendPackage.version}" > .version
        fi
      '';

      environment = pythonEnvironment;

      serviceConfig = {
        BindReadOnlyPaths = "${cfg.backendPackage}/share/static:/var/lib/lasuite-meet/static";

        ExecStart = utils.escapeSystemdExecArgs (
          [
            (lib.getExe' cfg.backendPackage "gunicorn")
            "--bind=${cfg.bind}"
          ]
          ++ cfg.gunicorn.extraArgs
          ++ [ "meet.wsgi:application" ]
        );
      }
      // commonServiceConfig;
    };

    systemd.services.lasuite-meet-celery = {
      description = "Meet Celery broker from SuiteNumérique";
      after = [
        "network.target"
      ]
      ++ (optional cfg.postgresql.createLocally "postgresql.service")
      ++ (optional cfg.redis.createLocally "redis-lasuite-meet.service");

      wants =
        (optional cfg.postgresql.createLocally "postgresql.service")
        ++ (optional cfg.redis.createLocally "redis-lasuite-meet.service");

      wantedBy = [ "multi-user.target" ];

      environment = pythonEnvironment;

      serviceConfig = {
        ExecStart = utils.escapeSystemdExecArgs (
          [ (lib.getExe' cfg.backendPackage "celery") ]
          ++ cfg.celery.extraArgs
          ++ [
            "--app=meet.celery_app"
            "worker"
          ]
        );
      }
      // commonServiceConfig;
    };

    services.postgresql = mkIf cfg.postgresql.createLocally {
      enable = true;
      ensureDatabases = [ "lasuite-meet" ];
      ensureUsers = [
        {
          name = "lasuite-meet";
          ensureDBOwnership = true;
        }
      ];
    };

    services.redis.servers.lasuite-meet = mkIf cfg.redis.createLocally { enable = true; };

    services.livekit = mkIf cfg.livekit.enable {
      inherit (cfg.livekit)
        enable
        settings
        keyFile
        openFirewall
        ;
    };

    services.nginx = mkIf cfg.enableNginx {
      enable = true;

      virtualHosts.${cfg.domain} = {
        root = cfg.frontendPackage;

        extraConfig = ''
          error_page 404 = /index.html;
        '';

        locations."/api" = {
          proxyPass = "http://${cfg.bind}";
          recommendedProxySettings = true;
        };

        locations."/admin" = {
          proxyPass = "http://${cfg.bind}";
          recommendedProxySettings = true;
        };

        locations."/static" = {
          root = "${cfg.backendPackage}/share";
        };

        locations."/livekit" = mkIf cfg.livekit.enable {
          proxyPass = "http://localhost:${toString config.services.livekit.settings.port}";
          recommendedProxySettings = true;
          proxyWebsockets = true;
          extraConfig = ''
            rewrite ^/livekit/(.*)$ /$1 break;
          '';
        };
      };
    };
  };

  meta = {
    buildDocsInSandbox = false;
    maintainers = [ lib.maintainers.soyouzpanda ];
  };
}
