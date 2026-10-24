{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.pollaris;
  webserver = config.services.nginx;
  pollarisUser = "pollaris";
  stateDir = "/var/lib/pollaris";

  # Pollaris writes its cache and logs next to its code, so link them to the state directory.
  package = cfg.package.override {
    dataDir = stateDir;
    inherit (cfg) customCss customJs customHomeTemplate;
  };

  hardening = {
    UMask = "0077";
    NoNewPrivileges = true;
    PrivateTmp = true;
    PrivateDevices = true;
    ProtectSystem = "strict";
    ProtectHome = true;
    ReadWritePaths = [ stateDir ];
    ProtectKernelTunables = true;
    ProtectKernelModules = true;
    ProtectControlGroups = true;
    RestrictNamespaces = true;
    RestrictRealtime = true;
    RestrictSUIDSGID = true;
    LockPersonality = true;
    SystemCallArchitectures = "native";
  };

  # Symfony's Dotenv needs values with spaces or special characters to be double-quoted.
  settingsFile = pkgs.writeText "pollaris.env" (
    lib.generators.toKeyValue {
      mkKeyValue = lib.generators.mkKeyValueDefault {
        mkValueString =
          value:
          if lib.isString value then
            "\"${lib.escape [ "\\" "\"" "$" ] value}\""
          else
            lib.generators.mkValueStringDefault { } value;
      } "=";
    } cfg.settings
  );

  console = "${package}/bin/pollaris-console";
in
{
  options.services.pollaris = {
    enable = lib.mkEnableOption "Pollaris, a polling tool to plan, organise and make decisions";

    package = lib.mkPackageOption pkgs "pollaris" { };

    domain = lib.mkOption {
      type = lib.types.str;
      example = "polls.example.org";
      description = "Domain name under which Pollaris is served.";
    };

    settings = lib.mkOption {
      type =
        with lib.types;
        attrsOf (oneOf [
          str
          int
          bool
        ]);
      default = { };
      example = {
        APP_NAME = "Our polls";
        APP_TIMEZONE = "Europe/Vienna";
        POLL_EXPIRES_COMPLETED = "6 months";
      };
      description = ''
        Environment variables used to configure Pollaris, written to its
        `.env.local` file. See the
        [administrators' guide](https://framagit.org/pollaris/pollaris/-/blob/main/env.sample)
        for the available variables.

        Do not put secrets here, as they would end up in the world-readable
        Nix store. Use {option}`environmentFile` instead.
      '';
    };

    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = "/run/secrets/pollaris.env";
      description = ''
        File with environment variables (in `KEY=value` format) that take
        precedence over {option}`settings`. Use it for secrets, for example
        `MAILER_DSN`, or `DATABASE_URL` when {option}`database.createLocally`
        is disabled.
      '';
    };

    database.createLocally = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Whether to create a local PostgreSQL database and user for Pollaris.
        If disabled, `DATABASE_URL` must be provided through
        {option}`environmentFile`.
      '';
    };

    customCss = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = lib.literalExpression ''pkgs.writeText "custom.css" "body { font-family: serif; }"'';
      description = "CSS file that is loaded on every page, served as `custom.css`.";
    };

    customJs = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = lib.literalExpression ''pkgs.writeText "custom.js" "console.log('Hello');"'';
      description = "JavaScript file that is loaded on every page, served as `custom.js`.";
    };

    customHomeTemplate = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = lib.literalExpression "./home.html.twig";
      description = ''
        Twig template that replaces the home page. Start from the upstream
        [`templates/home/show.html.twig`](https://framagit.org/pollaris/pollaris/-/blob/main/templates/home/show.html.twig).
      '';
    };

    nginx = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      default = { };
      example = {
        enableACME = true;
        forceSSL = true;
      };
      description = ''
        Extra configuration for the nginx virtual host of Pollaris.
        Refer to {option}`services.nginx.virtualHosts` for the available options.
      '';
    };

    poolConfig = lib.mkOption {
      type =
        with lib.types;
        attrsOf (oneOf [
          str
          int
          bool
        ]);
      default = {
        "pm" = "dynamic";
        "pm.max_children" = 32;
        "pm.start_servers" = 2;
        "pm.min_spare_servers" = 2;
        "pm.max_spare_servers" = 4;
        "pm.max_requests" = 500;
      };
      description = ''
        Options for the Pollaris PHP-FPM pool. See the documentation of
        `php-fpm.conf` for details.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    services.postgresql = lib.mkIf cfg.database.createLocally {
      enable = true;
      ensureDatabases = [ "pollaris" ];
      ensureUsers = [
        {
          name = pollarisUser;
          ensureDBOwnership = true;
        }
      ];
    };

    services.pollaris.settings = {
      APP_ENV = lib.mkDefault "prod";
      APP_BASE_URL = lib.mkDefault "https://${cfg.domain}";
    };

    services.phpfpm.pools.pollaris = {
      user = pollarisUser;
      group = pollarisUser;
      phpPackage = cfg.package.php;
      settings = {
        "listen.owner" = webserver.user;
        "listen.group" = webserver.group;
      }
      // cfg.poolConfig;
    };

    systemd.tmpfiles.rules = [ "d '${stateDir}' 0700 ${pollarisUser} ${pollarisUser} - -" ];

    systemd.services.pollaris-setup = {
      description = "Pollaris setup (configuration and database migrations)";
      documentation = [
        "https://framagit.org/pollaris/pollaris/-/blob/${cfg.package.version}/docs/administrators/install.md#configure-the-application"
        "https://framagit.org/pollaris/pollaris/-/blob/${cfg.package.version}/docs/administrators/install.md#setup-the-database"
        "https://framagit.org/pollaris/pollaris/-/blob/${cfg.package.version}/env.sample"
      ];
      wantedBy = [ "multi-user.target" ];
      before = [
        "phpfpm-pollaris.service"
        "pollaris-worker.service"
      ];
      requiredBy = [
        "phpfpm-pollaris.service"
        "pollaris-worker.service"
      ];
      after = lib.optional cfg.database.createLocally "postgresql.target";
      requires = lib.optional cfg.database.createLocally "postgresql.target";
      restartTriggers = [
        package
        settingsFile
      ];
      path = [ cfg.package.php ];
      script = ''
        # The umask in `hardening` makes sure that only the service user can read the secrets.
        secretFile=${stateDir}/app_secret
        if ! [ -e "$secretFile" ]; then
          ${pkgs.openssl}/bin/openssl rand -hex 32 > "$secretFile"
        fi

        {
          cat ${settingsFile}
          echo "APP_SECRET=$(cat "$secretFile")"
          ${lib.optionalString cfg.database.createLocally ''
            echo "DATABASE_URL=\"postgresql://${pollarisUser}@localhost/pollaris?host=/run/postgresql&serverVersion=${lib.versions.major config.services.postgresql.package.version}&charset=utf8\""
          ''}
        } > ${stateDir}/.env.local

        # Drop the cache of previous versions before running any command.
        rm -rf ${stateDir}/cache
        ${console} doctrine:migrations:migrate --no-interaction
        ${console} cache:warmup
      '';
      serviceConfig = hardening // {
        # The network is only needed to reach a remote database.
        RestrictAddressFamilies = [
          "AF_UNIX"
        ]
        ++ lib.optionals (!cfg.database.createLocally) [
          "AF_INET"
          "AF_INET6"
        ];
        Type = "oneshot";
        RemainAfterExit = true;
        User = pollarisUser;
        Group = pollarisUser;
        EnvironmentFile = cfg.environmentFile;
      };
    };

    systemd.services.phpfpm-pollaris = {
      documentation = [
        "https://framagit.org/pollaris/pollaris/-/blob/${cfg.package.version}/docs/administrators/install.md#configure-the-webserver"
        "https://www.php.net/manual/en/install.fpm.php"
      ];
      serviceConfig.EnvironmentFile = cfg.environmentFile;
    };

    systemd.services.pollaris-worker = {
      description = "Pollaris Messenger worker";
      documentation = [
        "https://framagit.org/pollaris/pollaris/-/blob/${cfg.package.version}/docs/administrators/install.md#setup-the-messenger-worker"
      ];
      wantedBy = [ "multi-user.target" ];
      after = [ "pollaris-setup.service" ];
      path = [ cfg.package.php ];
      serviceConfig = hardening // {
        # The network is needed to deliver emails and to reach a remote database.
        RestrictAddressFamilies = [
          "AF_UNIX"
          "AF_INET"
          "AF_INET6"
        ];
        ExecStart = "${console} messenger:consume async scheduler_default --time-limit=3600";
        User = pollarisUser;
        Group = pollarisUser;
        Restart = "always";
        RestartSec = 30;
        EnvironmentFile = cfg.environmentFile;
      };
    };

    services.nginx = {
      enable = true;
      virtualHosts.${cfg.domain} = lib.mkMerge [
        cfg.nginx
        {
          # see https://framagit.org/pollaris/pollaris/-/blob/main/docs/administrators/install.md#configure-the-webserver
          root = "${package}/share/php/pollaris/public";
          locations = {
            "/" = {
              priority = 200;
              extraConfig = "try_files $uri /index.php$is_args$args;";
            };
            "~ ^/index\\.php(/|$)" = {
              priority = 500;
              extraConfig = ''
                fastcgi_pass unix:${config.services.phpfpm.pools.pollaris.socket};
                fastcgi_split_path_info ^(.+\.php)(/.*)$;
                include ${config.services.nginx.package}/conf/fastcgi.conf;

                fastcgi_param SCRIPT_FILENAME $realpath_root$fastcgi_script_name;
                fastcgi_param DOCUMENT_ROOT $realpath_root;

                internal;
              '';
            };
            "~ \\.php$" = {
              priority = 800;
              extraConfig = "return 404;";
            };
          };
        }
      ];
    };

    # Run the console as the service user with the same environment as the services (needs root),
    # e.g. `pollaris-console app:user:create`.
    environment.systemPackages = [
      (pkgs.writeShellScriptBin "pollaris-console" ''
        exec ${config.systemd.package}/bin/systemd-run --quiet --pty --wait --collect \
          --property=User=${pollarisUser} --property=Group=${pollarisUser} --property=UMask=0077 \
          --setenv=PATH=${lib.makeBinPath [ pkgs.coreutils ]} \
          ${
            lib.optionalString (cfg.environmentFile != null) "--property=EnvironmentFile=${cfg.environmentFile}"
          } \
          ${console} "$@"
      '')
    ];

    users.users.${pollarisUser} = {
      isSystemUser = true;
      group = pollarisUser;
    };
    users.groups.${pollarisUser} = { };
  };

  meta.maintainers = with lib.maintainers; [ haansn08 ];
}
