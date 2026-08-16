{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    optionalAttrs
    types
    ;

  cfg = config.services.linkding;
in
{
  options.services.linkding = {
    enable = mkEnableOption "linkding, a self-hosted bookmark manager";

    package = mkPackageOption pkgs "linkding" { };

    user = mkOption {
      type = types.str;
      default = "linkding";
      description = ''
        User account under which linkding runs.

        ::: {.note}
        If left as the default value this user will automatically be created
        on system activation, otherwise you are responsible for ensuring the
        user exists before the linkding service starts.
        :::
      '';
    };

    group = mkOption {
      type = types.str;
      default = "linkding";
      description = ''
        Group under which linkding runs.

        ::: {.note}
        If left as the default value this group will automatically be created
        on system activation, otherwise you are responsible for ensuring the
        group exists before the linkding service starts.
        :::
      '';
    };

    dataDir = mkOption {
      type = types.path;
      default = "/var/lib/linkding";
      description = "Directory used for all mutable state: SQLite database, secret key, favicons, previews, and assets.";
    };

    address = mkOption {
      type = types.str;
      default = "127.0.0.1";
      description = "Address on which linkding listens.";
    };

    port = mkOption {
      type = types.port;
      default = 9090;
      description = "Port on which linkding listens.";
    };

    contextPath = mkOption {
      type = types.str;
      default = "";
      example = "linkding/";
      description = ''
        Configures a URL context path under which linkding is accessible.
        When set, linkding is available at `http://host:<port>/<contextPath>`.
        Must end with a `/` when non-empty.
      '';
    };

    environmentFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      example = "/run/secrets/linkding.env";
      description = ''
        Path to an environment file loaded by all linkding services.
        Useful for injecting secrets that should not appear in the Nix store,
        such as `LD_DB_PASSWORD` or `LD_SUPERUSER_PASSWORD`.
      '';
    };

    settings = mkOption {
      type = types.attrsOf types.str;
      default = { };
      example = {
        LD_DISABLE_BACKGROUND_TASKS = "True";
        LD_DISABLE_URL_VALIDATION = "True";
        LD_ENABLE_OIDC = "True";
      };
      description = ''
        Additional environment variables passed to linkding.
        Refer to the [linkding documentation](https://linkding.link/options/)
        for the full list of supported `LD_*` options.
      '';
    };

    database = {
      type = mkOption {
        type = types.enum [
          "sqlite"
          "postgres"
        ];
        default = "sqlite";
        description = "Database engine to use. Defaults to SQLite.";
      };

      host = mkOption {
        type = types.str;
        default = "localhost";
        description = "PostgreSQL server host.";
      };

      port = mkOption {
        type = types.port;
        default = 5432;
        description = "PostgreSQL server port.";
      };

      name = mkOption {
        type = types.str;
        default = "linkding";
        description = "PostgreSQL database name.";
      };

      user = mkOption {
        type = types.str;
        default = "linkding";
        description = "PostgreSQL user name.";
      };

      createLocally = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to automatically create a local PostgreSQL database and user.";
      };
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = "Open the linkding port in the firewall.";
    };
  };

  config = mkIf cfg.enable (
    let
      pkg = cfg.package;

      usePostgres = cfg.database.type == "postgres";

      pythonPath =
        "${pkg.passthru.python.pkgs.makePythonPath pkg.passthru.dependencies}:${lib.getBin pkg}/${pkg.passthru.python.sitePackages}"
        + lib.strings.optionalString usePostgres ":${pkg.passthru.python.pkgs.makePythonPath pkg.optional-dependencies.postgres}";

      # Build the environment passed to every linkding process.
      environment = {
        DJANGO_SETTINGS_MODULE = "bookmarks.settings.prod";
        _NIXOS_LINKDING_DATA_DIR = cfg.dataDir;
        LD_SERVER_PORT = toString cfg.port;
      }
      // optionalAttrs (cfg.contextPath != "") {
        LD_CONTEXT_PATH = cfg.contextPath;
      }
      // optionalAttrs usePostgres {
        LD_DB_ENGINE = "postgres";
        LD_DB_DATABASE = cfg.database.name;
        LD_DB_USER = cfg.database.user;
        LD_DB_HOST = "/run/postgresql";
      }
      // optionalAttrs (usePostgres && !cfg.database.createLocally) {
        LD_DB_HOST = cfg.database.host;
        LD_DB_PORT = toString cfg.database.port;
      }
      // cfg.settings;

      environmentFile = pkgs.writeText "linkding-environment" (lib.generators.toKeyValue { } environment);

      # Generate a uwsgi.ini for the linkding instance, adapted for NixOS from
      # the upstream uwsgi.ini. The static-map entries serve pre-generated
      # static files from the Nix store as well as the mutable user-data
      # directories (favicons, previews) from the data directory.
      uwsgiIni = pkgs.writeText "linkding-uwsgi.ini" ''
        [uwsgi]
        plugins-dir = ${pkg.passthru.uwsgiWithPython}/lib/uwsgi
        plugin = python3
        module = bookmarks.wsgi:application
        env = DJANGO_SETTINGS_MODULE=bookmarks.settings.prod
        processes = 2
        threads = 2
        buffer-size = 8192
        die-on-term = true
        mime-file = ${pkgs.mailcap}/etc/mime.types
        http = ${cfg.address}:${toString cfg.port}
        static-map = /${cfg.contextPath}static=${pkg}/${pkg.passthru.python.sitePackages}/bookmarks/static
        static-map = /${cfg.contextPath}static=${cfg.dataDir}/favicons
        static-map = /${cfg.contextPath}static=${cfg.dataDir}/previews
        static-map = /${cfg.contextPath}robots.txt=${pkg}/${pkg.passthru.python.sitePackages}/bookmarks/static/robots.txt

        if-env = LD_REQUEST_TIMEOUT
        http-timeout = %(_)
        socket-timeout = %(_)
        harakiri = %(_)
        endif =

        if-env = LD_REQUEST_MAX_CONTENT_LENGTH
        limit-post = %(_)
        endif =

        if-env = LD_LOG_X_FORWARDED_FOR
        log-x-forwarded-for = %(_)
        endif =

        if-env = LD_DISABLE_REQUEST_LOGS=true
        disable-logging = true
        log-4xx = true
        log-5xx = true
        endif =
      '';

      # Manage wrapper script installed into the system PATH so administrators can
      # run Django management commands as the linkding service user.
      linkdingManageScript =
        let
          args = lib.escapeShellArgs (
            [
              "--uid=${cfg.user}"
              "--gid=${cfg.group}"
              "--working-directory=${cfg.dataDir}"
              "--property=EnvironmentFile=${environmentFile}"
            ]
            ++ lib.optional (cfg.environmentFile != null) "--property=EnvironmentFile=${cfg.environmentFile}"
            ++ [
              "--property=ReadWritePaths=${cfg.dataDir}"
              "--setenv=PYTHONPATH=${pythonPath}"
              "--pty"
              "--wait"
              "--collect"
              "--service-type=exec"
              "--quiet"
              "--"
              "${lib.getExe' pkg "linkding"}"
            ]
          );
        in
        pkgs.writeShellScriptBin "linkding-manage" ''
          exec ${lib.getExe' config.systemd.package "systemd-run"} ${args} "$@"
        '';

      commonServiceConfig = {
        Slice = "system-linkding.slice";
        User = cfg.user;
        Group = cfg.group;
        EnvironmentFile = [
          environmentFile
        ]
        ++ lib.optional (cfg.environmentFile != null) cfg.environmentFile;
        Environment = "PYTHONPATH=${pythonPath}";
        WorkingDirectory = cfg.dataDir;
        StateDirectory = [
          "linkding"
          "linkding/favicons"
          "linkding/previews"
          "linkding/assets"
        ];
        StateDirectoryMode = "0750";
        # Hardening
        NoNewPrivileges = true;
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        ReadWritePaths = [ cfg.dataDir ];
        PrivateMounts = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        RemoveIPC = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
      };
    in
    {
      assertions = [
        {
          assertion = cfg.database.createLocally -> usePostgres;
          message = "services.linkding.database.createLocally requires services.linkding.database.type = \"postgres\"";
        }
        {
          assertion =
            cfg.database.createLocally -> cfg.database.host == "localhost" || cfg.database.host == "";
          message = "services.linkding.database.host should be empty or \"localhost\" when createLocally is enabled";
        }
        {
          assertion =
            cfg.database.createLocally
            -> cfg.database.user == cfg.user && cfg.database.user == cfg.database.name;
          message = "services.linkding.database.user must match services.linkding.user and services.linkding.database.name when createLocally is enabled";
        }
        {
          assertion = cfg.contextPath == "" || lib.hasSuffix "/" cfg.contextPath;
          message = "services.linkding.contextPath must end with \"/\" when non-empty";
        }
      ];

      networking.firewall = mkIf cfg.openFirewall {
        allowedTCPPorts = [ cfg.port ];
      };

      environment.systemPackages = [ linkdingManageScript ];

      users.users.${cfg.user} = {
        isSystemUser = true;
        group = cfg.group;
        home = cfg.dataDir;
      };

      users.groups.${cfg.group} = { };

      systemd.slices.system-linkding = {
        description = "linkding bookmark manager System Slice";
        documentation = [ "https://linkding.link/" ];
      };

      # One-shot setup service: run database migrations and first-time
      # initialization steps taken from the upstream bootstrap.sh.
      systemd.services.linkding-setup = {
        description = "linkding database migrations and initialization";
        after = [
          "network.target"
        ]
        ++ lib.optionals (usePostgres && cfg.database.createLocally) [ "postgresql.target" ];
        requires = lib.optionals (usePostgres && cfg.database.createLocally) [ "postgresql.target" ];

        serviceConfig = commonServiceConfig // {
          Type = "oneshot";
          ExecStart = "${lib.getExe' pkg "linkding-bootstrap"}";
        };
      };

      # Main WSGI service — starts after setup completes.
      systemd.services.linkding = {
        description = "linkding bookmark manager";
        wantedBy = [ "multi-user.target" ];
        after = [ "linkding-setup.service" ];
        requires = [ "linkding-setup.service" ];
        startLimitBurst = 5;
        startLimitIntervalSec = 60;
        serviceConfig = commonServiceConfig // {
          Type = "exec";
          ExecStart = "${lib.getExe pkgs.uwsgi} --ini ${uwsgiIni}";
          Restart = "on-failure";
        };
      };

      # Background task processor (Huey). Can be disabled via
      # services.linkding.settings.LD_DISABLE_BACKGROUND_TASKS = "True".
      systemd.services.linkding-background-tasks =
        mkIf ((cfg.settings.LD_DISABLE_BACKGROUND_TASKS or "False") != "True")
          {
            description = "linkding background task processor";
            wantedBy = [ "multi-user.target" ];
            after = [ "linkding-setup.service" ];
            requires = [ "linkding-setup.service" ];

            serviceConfig = commonServiceConfig // {
              Type = "exec";
              ExecStart = "${lib.getExe' pkg "linkding"} run_huey -f";
              Restart = "on-failure";
              RestartSec = "5s";
            };
          };

      # Automatically provision a local PostgreSQL database when requested.
      services.postgresql = mkIf cfg.database.createLocally {
        enable = true;
        ensureDatabases = [ cfg.database.name ];
        ensureUsers = [
          {
            name = cfg.database.user;
            ensureDBOwnership = true;
          }
        ];
      };
    }
  );

  meta.maintainers = with lib.maintainers; [ squat ];
}
