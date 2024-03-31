{ config
, lib
, pkgs
, ...
}:
let
  inherit (lib)
    concatStringsSep literalExpression mapAttrs mapAttrsToList mkMerge mkIf mkOption optionalAttrs
    optional replaceStrings toShellVar toUpper types;

  cfg = config.services.linkding;
  pkg = cfg.package;

  jsonFormat = pkgs.formats.json { };

  customSettings = pkgs.writeTextFile {
    name = "custom.py";
    text = ''
      from siteroot.settings.prod import *

      # The default sqlite db path is hardcoded inside the linkding source tree
      if LD_DB_ENGINE == "sqlite":
        DATABASES["default"]["NAME"] = LD_DB_DATABASE or "db.sqlite3"
      HUEY["filename"] = "tasks.sqlite3"

      ${cfg.extraPythonConfig}
    '';
    destination = "/nixos_settings/custom.py";
    checkPhase = ''
      ${pkg.python}/bin/python -m py_compile "$target"
    '';
  };

  # Bool option format expected by linkding
  fmtBoolEnv = x: if x then "1" else "0";
  commonEnv =
    mapAttrs
      (_: v: if builtins.typeOf v == "bool" then fmtBoolEnv v else v)
      (
        {
          DJANGO_SETTINGS_MODULE = "nixos_settings.custom";
          PYTHONPATH = "${pkg.python.pkgs.makePythonPath pkg.propagatedBuildInputs}:${pkg}/lib/linkding:${customSettings}";

          LD_DB_ENGINE = cfg.database.engine;
          LD_DB_HOST = cfg.database.host;
          LD_DB_USER = cfg.database.user;

          LD_FAVICON_PROVIDER = cfg.faviconProvider;

          LD_DISABLE_URL_VALIDATION = cfg.disableURLValidation;
          LD_DISABLE_BACKGROUND_TASKS = cfg.disableBackgroundTasks;

          LD_ENABLE_AUTH_PROXY = cfg.authProxy.enable;
          # Request headers are rewritten in linkding: all HTTP headers are prefixed with HTTP_, all
          # letters are in uppercase, and dashes are replaced with underscores.
          LD_AUTH_PROXY_USERNAME_HEADER =
            "HTTP_${toUpper (replaceStrings [ "-" ] [ "_" ] cfg.authProxy.usernameHeader)}";

          LD_CSRF_TRUSTED_ORIGINS = concatStringsSep "," cfg.csrfTrustedOrigins;

          LD_DB_OPTIONS = builtins.toJSON cfg.database.options;
        } // optionalAttrs (cfg.superuser.name != null) {
          LD_SUPERUSER_NAME = cfg.superuser.name;
        } // optionalAttrs (cfg.database.database != null) {
          LD_DB_DATABASE = cfg.database.database;
        } // optionalAttrs (cfg.database.port != null) {
          LD_DB_PORT = toString cfg.database.port;
        } // optionalAttrs (cfg.contextPath != null) {
          LD_CONTEXT_PATH = cfg.contextPath;
        } // optionalAttrs (cfg.authProxy.logoutUrl != null) {
          LD_AUTH_PROXY_LOGOUT_URL = cfg.authProxy.logoutUrl;
        } // cfg.extraConfig
      );

  manage =
    let
      setupEnv = concatStringsSep "\n"
        (mapAttrsToList (name: val: "export ${toShellVar name val}") commonEnv);

    in
    pkgs.writeShellScript "manage" ''
      ${setupEnv}
      # Required to use default sqlite db
      cd /var/lib/linkding
      exec ${pkg}/bin/linkding "$@"
    '';

  isLocalPostgres = cfg.database.engine == "postgres"
    && (cfg.database.host == "" || cfg.database.host == "localhost");

  mkService = svc: mkMerge [
    {
      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;

        # Hardening
        StateDirectory = "linkding";
        WorkingDirectory = "/var/lib/linkding";
        BindPaths = optional
          (cfg.database.engine == "postgres" && cfg.database.host == "")
          "/run/postgresql/.s.PGSQL.${toString config.services.postgresql.port}";
        BindReadOnlyPaths = [
          "${config.environment.etc."ssl/certs/ca-certificates.crt".source}:/etc/ssl/certs/ca-certificates.crt"
          "${builtins.storeDir}"
          "-/etc/resolv.conf"
          "-/etc/nsswitch.conf"
          "-/etc/hosts"
          "-/etc/localtime"
        ];
        CapabilityBoundingSet = "";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateUsers = true;
        PrivateTmp = true;
        ProcSubset = "pid";
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = true;
        RestrictAddressFamilies = [ "AF_UNIX" "AF_INET" "AF_INET6" ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [ "@system-service" "@resources" "~@privileged" "@keyring" ];
        UMask = "0077";
      } // optionalAttrs (cfg.extraConfigFile != null) {
        EnvironmentFile = cfg.extraConfigFile;
      };

      environment = commonEnv;
    }

    svc
  ];
in
{
  meta.maintainers = with lib.maintainers; [ rogryza ];

  options = {
    services.linkding = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Enable Linkding.

          When started, the Linkding database is automatically updated if the package has changed by
          running a Django migration.

          A script to manage the instance (by wrapping Django's manage.py) is linked to
          `/var/lib/linkding/linkding-manage`.
        '';
      };

      package = mkOption {
        type = types.package;
        default = pkgs.linkding;
        defaultText = literalExpression "pkgs.linkding";
        description = lib.mdDoc "The linkding package to use.";
      };

      user = mkOption {
        type = types.str;
        default = "linkding";
        description = lib.mdDoc ''
          User to run the service as. The user is automatically created if left as the default.
        '';
      };

      group = mkOption {
        type = types.str;
        default = "linkding";
        description = lib.mdDoc ''
          Group to run the service as. The group is automatically created if left as the default.
        '';
      };

      extraConfig = mkOption {
        type = types.attrsOf types.str;
        default = { };
        description = lib.mdDoc ''
          Extra linkding config options.
          See [the options documentation](https://github.com/sissbruecker/linkding/blob/master/docs/Options.md)
          for available options.

          Note that some options, like {env}`LD_REQUEST_TIMEOUT`, are specific to the default
          project setup with Docker + uwsgi, so they have no effect on NixOS.
        '';
      };

      extraConfigFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = lib.mdDoc ''
          Path to a file with extra linkding config options. You can use it to set sensitive options
          like {env}`LD_SUPERUSER_PASSWORD`. See
          [the options documentation](https://github.com/sissbruecker/linkding/blob/master/docs/Options.md)
          for available options.

          Note that some options, like {env}`LD_REQUEST_TIMEOUT`, are specific to the default
          project setup with Docker + uwsgi, so they have no effect on NixOS.
        '';
      };

      extraPythonConfig = mkOption {
        type = types.lines;
        default = "";
        description = lib.mdDoc ''
          Custom django settings python module. All definitions from
          [prod.py](https://github.com/sissbruecker/linkding/blob/master/siteroot/settings/prod.py)
          are automatically imported.
        '';
      };

      virtualHost = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = lib.mdDoc ''
          Name of the nginx virtual host to use and setup. If null, do not setup anything.

          If you are setting up your own proxy, the service is set up to run on socket
          /run/linkding.sock. You may want to set up your proxy to serve `data` and `static` URLs
          from `''${services.linkding.package}/lib/linkding/data/"` and
          `''${services.linkding.package}/lib/linkding/static/"` for improved performance,
          this is the default nginx configuration:

          ```
          location /data {
            alias ".../lib/linkding/data/"
          }

          location /static {
            alias ".../lib/linkding/static/"
          }
          ```
        '';
      };

      contextPath = mkOption {
        type = types.nullOr (types.strMatching ".+/") // { description = "string ending in a /"; };
        default = null;
        description = lib.mdDoc ''
          Allows configuring the context path of the website. Useful for setting up Nginx reverse
          proxy.
        '';
      };

      disableURLValidation = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Completely disables URL validation for bookmarks. This can be useful if you intend to
          store non fully qualified domain name URLs, such as network paths, or you want to store
          URLs that use another protocol than http or https.
        '';
      };

      disableBackgroundTasks = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Disables background tasks, such as creating snapshots for bookmarks on the the Internet
          Archive Wayback Machine. Enabling this flag will prevent the background task processor
          from starting up, and prevents scheduling tasks. This might be useful if you are
          experiencing performance issues or other problematic behaviour due to background task
          processing.
        '';
      };

      faviconProvider = mkOption {
        type = types.str;
        default = "https://t1.gstatic.com/faviconV2?client=SOCIAL&type=FAVICON&fallback_opts=TYPE,SIZE,URL&url={url}&size=32";
        description = lib.mdDoc ''
          The favicon provider used for downloading icons if they are enabled in the user profile
          settings. The default provider is a Google service that automatically detects the correct
          favicon for a website, and provides icons in consistent image format (PNG) and in a
          consistent image size.

          This setting allows to configure a custom provider in form of a URL. When calling the
          provider with the URL of a website, it must return the image data for the favicon of that
          website. The configured favicon provider URL must contain a placeholder that will be
          replaced with the URL of the website for which to download the favicon. The available
          placeholders are:

          * {url} - Includes the scheme and hostname of the website, for example
          https://example.com {domain} - Includes only the hostname of the website, for example
          example.com
          * Which placeholder you need to use depends on the respective favicon provider, please
          check their documentation or usage examples. See the default URL for how to insert the
          placeholder to the favicon provider URL.

          Alternative favicon providers:
          * DuckDuckGo: https://icons.duckduckgo.com/ip3/{domain}.ico
        '';
      };

      authProxy.enable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Enables support for authentication proxies such as Authelia. This effectively disables
          credentials-based authentication and instead authenticates users if a specific request
          header contains a known username. You must make sure that your proxy (nginx, Traefik,
          Caddy, ...) forwards this header from your auth proxy to linkding. Check the documentation
          of your auth proxy and your reverse proxy on how to correctly set this up.

          Note that this automatically creates new users in the database if they do not already
          exist.
        '';
      };

      authProxy.usernameHeader = mkOption {
        type = types.str;
        default = "Remote-User";
        description = lib.mdDoc ''
          The name of the request header that the auth proxy passes to the proxied application
          (linkding in this case), so that the application can identify the user. Check the
          documentation of your auth proxy to get this information.
        '';
      };

      authProxy.logoutUrl = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = lib.mdDoc ''
          The URL that linkding should redirect to after a logout. By default, the logout redirects
          to the login URL, which means the user will be automatically authenticated again. Instead,
          you might want to configure the logout URL of the auth proxy here.
        '';
      };

      csrfTrustedOrigins = mkOption {
        type = types.listOf (types.strMatching "https?://.+");
        default = [ ];
        description = lib.mdDoc ''
          List of trusted origins / host names to allow for POST requests, for example when logging
          in, or saving bookmarks. For these type of requests, the Origin header must match the Host
          header, otherwise the request will fail with a 403 status code, and the message CSRF
          verification failed.

          This option allows to declare a list of trusted origins that will be accepted even if the
          headers do not match. This can be the case when using a reverse proxy that rewrites the
          Host header, such as Nginx.

          For example, to allow requests to https://linkding.mydomain.com, configure the setting to
          https://linkding.mydomain.com. Note that the setting must include the correct protocol
          (https or http), and must not include the application / context path.

          This setting is adopted from the Django framework used by linkding, more information on
          the setting is available in the
          [Django documentation](https://docs.djangoproject.com/en/4.0/ref/settings/#std-setting-CSRF_TRUSTED_ORIGINS).
        '';
      };

      database.engine = mkOption {
        type = types.enum [ "postgres" "sqlite" ];
        default = "sqlite";
        description = lib.mdDoc ''
          Database engine used by linkding to store data. By default, linkding uses SQLite, for
          which you don't need to configure anything.

          If set to `postgres` and {option}`services.linkding.database.host` is an empty string or
          `localhost`, enables the postgresql service but the postgres user and database are not
          created automatically.
        '';
      };

      database.database = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = lib.mdDoc ''
          Path of sqlite database or name of postgres database.
        '';
      };

      database.user = mkOption {
        type = types.str;
        default = "linkding";
        description = lib.mdDoc ''
          The name of the user to connect to the database server.

          If you wish to set a password, pass {env}`LD_DB_PASSWORD` in
          {option}`services.linkding.extraConfigFile`.
        '';
      };

      database.host = mkOption {
        type = types.str;
        default = "";
        description = lib.mdDoc ''
          Hostname or IP of the postgres database server. If set to an empty string (the default),
          connects to the default local postgres unix socket.
        '';
      };

      database.port = mkOption {
        type = types.nullOr types.port;
        default = null;
        description = lib.mdDoc ''
          The port of the database server. Should use the default port if left empty, for example 5432 for PostgresSQL.
        '';
      };

      database.options = mkOption {
        type = jsonFormat.type;
        default = { };
        description = ''
          Additional options for the database. Passed directly to OPTIONS, see
          [the Django documentation](https://docs.djangoproject.com/en/5.0/ref/settings/#std-setting-OPTIONS).
        '';
      };

      superuser.name = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = lib.mdDoc ''
          When set, creates an initial superuser with the specified username when starting the
          container. Does nothing if the user already exists.

          If you wish to set a superuser password, pass {env}`LD_SUPERUSER_PASSWORD` in
          {option}`services.linkding.extraConfigFile`.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.sockets.linkding = {
      description = "Linkding socket";

      wantedBy = [ "sockets.target" ];

      listenStreams = [ "/run/linkding.sock" ];
    };

    users.users = mkIf (cfg.user == "linkding") {
      linkding = {
        description = "linkding service user";
        isSystemUser = true;
        createHome = false;
        group = cfg.group;
      };
    };

    users.groups = mkIf (cfg.group == "linkding") {
      linkding = { };
    };

    systemd.services.linkding-migrate = mkService {
      description = "Sets up the lindking database and management script";

      unitConfig = {
        StartLimitBurst = 10;
        StartLimitIntervalSec = 60;
      };

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        Restart = "on-failure";
        RestartSec = "5";
      };

      script = ''
        ln -sf ${manage} linkding-manage

        # Let django migrate the DB as needed
        ${pkg}/bin/linkding migrate
        ${pkg}/bin/linkding enable_wal
        ${pkg}/bin/linkding create_initial_superuser
      '';
    };

    services.postgresql.enable = isLocalPostgres;

    systemd.services.linkding = mkService {
      description = "Linkding server";

      requires = [ "linkding-migrate.service" "linkding.socket" ]
        ++ optional isLocalPostgres "postgresql.service";
      after = [ "linkding-migrate.service" ]
        ++ optional isLocalPostgres "postgresql.service";

      unitConfig = {
        StartLimitBurst = 10;
        StartLimitIntervalSec = 60;
      };

      serviceConfig = {
        Type = "notify";
        ExecStart = concatStringsSep " " [
          "${pkg.python.pkgs.gunicorn}/bin/gunicorn"
          "--access-logfile"
          "-"
          "--error-logfile"
          "-"
          "siteroot.wsgi"
        ];
        ExecReload = "kill -s HUP $MAINPID";
        Restart = "on-failure";
        RestartSec = 5;

        # Gunicorn requires setuid
        SystemCallFilter = [ "@setuid" ];
      };
    };

    systemd.services.linkding-background-tasks = mkIf (!cfg.disableBackgroundTasks) (mkService {
      description = "Linkding background tasks processor";

      requires = [ "linkding-migrate.service" ];
      after = [ "linkding-migrate.service" ];
      wantedBy = [ "multi-user.target" ];

      unitConfig = {
        StartLimitBurst = 10;
        StartLimitIntervalSec = 60;
      };

      serviceConfig = {
        Type = "exec";
        Restart = "on-failure";
        RestartSec = 5;
      };

      script = ''
        exec ${pkg}/bin/linkding run_huey -f
      '';
    });

    services.nginx = mkIf (cfg.virtualHost != null) {
      enable = true;
      upstreams.linkding.servers."unix:/run/linkding.sock" = { };
      virtualHosts.${cfg.virtualHost}.locations = {
        "/" = {
          proxyPass = "http://linkding";
          recommendedProxySettings = true;
        };

        "/data/".alias = "${pkg}/lib/linkding/data/";
        "/static/".alias = "${pkg}/lib/linkding/static/";
      };
    };
  };
}
