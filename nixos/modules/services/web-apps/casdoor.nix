{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.casdoor;

  defaultUser = "casdoor";
  defaultGroup = "casdoor";

  settings = cfg.settings;

  # Casdoor only knows how to create a database with "CREATE DATABASE", which
  # SQLite and SQL Server do not support. Passing the flag with those drivers
  # makes the server panic on startup, so it is only passed where it works.
  createDatabase =
    cfg.createDatabase
    && lib.elem settings.driverName [
      "mysql"
      "postgres"
    ];

  # The settings of the web console are compiled into the package, so they are
  # applied by building the package with different attributes.
  package = cfg.package.overrideAttrs (prev: {
    customFooter = cfg.customFooter;
    showCloudPromotion = cfg.showCloudPromotion;
  });

  # Casdoor reads its configuration from the environment first and only falls
  # back to its configuration file, so all settings are passed as environment
  # variables. The values have to be strings, so the typed options are
  # converted here.
  #
  # Two details matter:
  #
  #   - Booleans need special care. Casdoor only reads a setting as true when
  #     the string is exactly "true", so "1" and "yes" are not accepted.
  #
  #   - Settings that are empty are left out of the environment entirely.
  #     Casdoor uses the environment value even when it is empty, so passing
  #     "originFrontend=" would override the value from the configuration file
  #     with an empty string. Leaving the setting out keeps the value from the
  #     configuration file, which is the upstream default.
  environment = lib.mapAttrs (
    _: value: if lib.isBool value then lib.boolToString value else toString value
  ) (lib.filterAttrs (_: value: value != null && value != "") settings);
in
{
  meta.doc = ./casdoor.md;

  options.services.casdoor = {
    enable = lib.mkEnableOption "Casdoor, an identity and access management server";

    package = lib.mkPackageOption pkgs "casdoor" { };

    user = lib.mkOption {
      type = lib.types.str;
      default = defaultUser;
      description = ''
        The user to run Casdoor as. If this is the default value, the user
        will be created as a system user.
      '';
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = defaultGroup;
      description = ''
        The group to run Casdoor as. If this is the default value, the group
        will be created as a system group.
      '';
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8000;
      description = "The port Casdoor listens on.";
    };

    createDatabase = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to create the database if it does not exist yet. This only
        works with the MySQL and PostgreSQL drivers. It is ignored for the
        other drivers, because they either create the database implicitly or
        do not support "CREATE DATABASE" at all.
      '';
    };

    # Web console

    customFooter = lib.mkOption {
      type = lib.types.str;
      default = "";
      example = "<span>Powered by <a href=\"https://example.com\">Example</a></span>";
      description = ''
        An HTML fragment that replaces the "Powered by Casdoor" line in the
        footer of the web console. It is inserted into the page as markup, so
        it can contain links and images. Leave it empty to keep the upstream
        footer.

        This is compiled into the web console when the package is built, so
        changing it replaces the whole Casdoor package instead of only
        reconfiguring the service.
      '';
    };

    showCloudPromotion = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether the web console shows the entries that advertise the hosted
        Casdoor Cloud offering. They are hidden by default.

        The backend can turn them off as well, and its answer overrides this
        option at runtime, so this only sets the default that is used until
        the backend has answered.

        This is compiled into the web console when the package is built, so
        changing it replaces the whole Casdoor package instead of only
        reconfiguring the service.
      '';
    };

    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = "/run/secrets/casdoor.env";
      description = ''
        Path to an environment file read by systemd for the Casdoor service.
        Use it for secrets such as `initAdminPassword`, `dataSourceName` and
        database passwords instead of the corresponding options, which pass
        their values through the Nix store. The file is loaded by systemd as
        root, so it can be readable by root only; values from this file
        override the service environment.

        Setting this option also satisfies the requirement that
        {option}`services.casdoor.settings.dataSourceName` be set, because the
        file can provide it as the `dataSourceName` variable.
      '';
    };

    extraConfig = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      example = lib.literalExpression ''
        {
          webAuthnRpId = "example.com";
          webAuthnRpOrigins = "https://example.com";
        }
      '';
      description = ''
        Additional Casdoor configuration options, as a mapping from the
        configuration key to its value. Every key that Casdoor reads through
        its configuration loader is accepted, see {file}`conf/app.conf` in the
        Casdoor source tree for examples. Values are passed as strings and are
        applied before the options under
        {option}`services.casdoor.settings`, so the dedicated options take
        precedence. Secrets placed here are visible in the Nix store; prefer
        {option}`services.casdoor.environmentFile` for those.
      '';
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to open {option}`services.casdoor.port` in the firewall. The
        LDAP and RADIUS ports are not opened by this option.
      '';
    };

    settings = lib.mkOption {
      type = lib.types.submodule (
        { ... }: {
          options = {
            # Database

            driverName = lib.mkOption {
              type = lib.types.enum [
                "mysql"
                "postgres"
                "sqlite"
                "sqlite3"
                "mssql"
              ];
              default = "sqlite";
              description = ''
                The database driver to use. "sqlite" and "sqlite3" need no
                database server and store the data in a file below the state
                directory, which is a good fit for small installations and for
                testing. Use "mysql", "postgres" or "mssql" (Microsoft SQL
                Server) for anything that has to scale.
              '';
            };

            dataSourceName = lib.mkOption {
              type = lib.types.str;
              default = "";
              description = ''
                The database connection string. Its format depends on
                {option}`services.casdoor.settings.driverName`, for example
                "root:password@tcp(localhost:3306)/" for MySQL or
                "user=casdoor password=secret host=localhost dbname=casdoor" for
                PostgreSQL. It is required for every driver except SQLite; the
                module refuses to evaluate when it is empty for another driver
                and no other source provides it. If the string contains a
                password, prefer {option}`services.casdoor.environmentFile` so it
                does not end up in the Nix store.

                The connection string can also be set in the file referenced by
                {option}`services.casdoor.environmentFile`, as
                "dataSourceName=...". Casdoor reads it from the environment
                first, so the file takes precedence over this option.
              '';
            };

            dbName = lib.mkOption {
              type = lib.types.str;
              default = "casdoor";
              description = "The name of the database to use.";
            };

            tableNamePrefix = lib.mkOption {
              type = lib.types.str;
              default = "";
              description = ''
                A prefix for the names of the database tables. Leave it empty to
                use the upstream names.
              '';
            };

            # Cache

            redisEndpoint = lib.mkOption {
              type = lib.types.str;
              default = "";
              description = ''
                The address of the Redis server to use for caching and for the
                session store, for example "localhost:6379". It is required when
                running more than one Casdoor replica, because the replicas have
                to share their sessions. Leave it empty to use the built-in
                file-based session store, which does not work with more than one
                replica.

                Several addresses can be given, separated by semicolons, to use
                Redis Cluster. A single address can carry the pool size, the
                password and the database number after commas, for example
                "localhost:6379,10,secret,1".
              '';
            };

            # Session and behaviour

            sessionCookieLifeTime = lib.mkOption {
              type = lib.types.int;
              default = 30 * 24 * 60 * 60;
              description = ''
                The lifetime of the session cookie in seconds. The default is 30
                days.
              '';
            };

            inactiveTimeoutMinutes = lib.mkOption {
              type = lib.types.int;
              default = 0;
              description = ''
                How long a user may be inactive before their session is
                invalidated, in minutes. Zero disables the timeout.
              '';
            };

            defaultLanguage = lib.mkOption {
              type = lib.types.str;
              default = "en";
              description = "The default language of the web console.";
            };

            forceLanguage = lib.mkOption {
              type = lib.types.str;
              default = "";
              description = ''
                Force the web console to always use this language, regardless of
                the language the browser asks for. Leave it empty to let the
                browser decide.
              '';
            };

            defaultApplication = lib.mkOption {
              type = lib.types.str;
              default = "app-built-in";
              description = ''
                The application that is opened by default in the web console.
              '';
            };

            isDemoMode = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = ''
                Whether to run in demo mode. In demo mode the web console is
                read-only and the theme showcase is shown. Never enable this in
                production.
              '';
            };

            initAdminPassword = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = ''
                The password to set for the built-in "admin" account on the first
                start. When null, Casdoor creates the account with an empty
                password and the first visitor to the welcome page can claim it,
                so either set this option or complete the welcome flow
                immediately after the first start.

                This value is passed through the systemd environment, which makes
                it visible in the Nix store and to local users. In production,
                put `initAdminPassword=...` in a root-readable environment file
                and set {option}`services.casdoor.environmentFile` instead.
              '';
            };

            initDataFile = lib.mkOption {
              type = lib.types.str;
              default = "";
              description = ''
                Path to a JSON or YAML file with the initial objects, applied on
                startup. The file has to be readable by the Casdoor user and is
                not modified by Casdoor. See
                <https://casdoor.org/docs/deployment/data-initialization>.
              '';
            };

            initDataMerge = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = ''
                Whether to update existing objects from
                {option}`services.casdoor.settings.initDataFile` instead of
                deleting and recreating them. When enabled, objects that already
                exist are merged with the data from the file and masked secrets
                are preserved. The file itself is not written back.
              '';
            };

            initDataNewOnly = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = ''
                Whether to only create objects that do not exist yet, leaving
                existing ones untouched.
              '';
            };

            initDataWatchInterval = lib.mkOption {
              type = lib.types.int;
              default = 0;
              description = ''
                How often to check
                {option}`services.casdoor.settings.initDataFile` for changes, in
                seconds. Zero disables the check. The file is only watched when
                {option}`services.casdoor.settings.initDataFile` is set.
              '';
            };

            logPostOnly = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = ''
                Whether to log only POST requests instead of every request. This
                is the upstream default.
              '';
            };

            showSql = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = ''
                Whether to log every SQL statement. This leaks user data into
                the log, so leave it disabled outside of debugging.
              '';
            };

            enableGzip = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = "Whether to compress responses with gzip.";
            };

            enableErrorMask = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = ''
                Whether to mask the details of internal errors in the responses
                of the API.
              '';
            };

            disableUpgrade = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = ''
                Whether to disable the check for a new Casdoor release. The check
                is enabled by default; set this to true to avoid contacting the
                update server from every instance.
              '';
            };

            # Web console

            origin = lib.mkOption {
              type = lib.types.str;
              default = "";
              description = ''
                The public URL of this Casdoor instance, for example
                "https://casdoor.example.com". It is used to build the URLs in
                the OAuth and OIDC responses, so it has to match the address the
                browser uses. Leaving it empty makes Casdoor derive the issuer
                from the request's Host header.
              '';
            };

            originFrontend = lib.mkOption {
              type = lib.types.str;
              default = "";
              description = ''
                The public URL of the web console, if it is served from a
                different address than the API.
              '';
            };

            staticBaseUrl = lib.mkOption {
              type = lib.types.str;
              default = "https://cdn.casbin.org";
              description = ''
                The base URL that the web console loads its static assets from.
              '';
            };

            showGithubCorner = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = ''
                Whether the web console shows the "GitHub corner" link in its
                top-right corner.
              '';
            };

            themeShowcase = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = ''
                Whether the web console shows the theme showcase.
              '';
            };

            # Additional listeners

            ldapServerPort = lib.mkOption {
              type = lib.types.port;
              default = 389;
              description = ''
                The port the LDAP server listens on. It listens on all
                interfaces. Set this to 0 to disable the LDAP server.
              '';
            };

            ldapsServerPort = lib.mkOption {
              type = lib.types.port;
              default = 636;
              description = ''
                The port the LDAPS server listens on. It listens on all
                interfaces. Set this to 0 to disable the LDAPS server. It
                additionally needs a certificate, which is selected with the
                {option}`services.casdoor.settings.ldapsCertId` option.
              '';
            };

            ldapsCertId = lib.mkOption {
              type = lib.types.str;
              default = "";
              description = ''
                The identifier of the certificate that the LDAPS server uses.
                The certificate has to be uploaded to Casdoor first.
              '';
            };

            radiusServerPort = lib.mkOption {
              type = lib.types.port;
              default = 1812;
              description = ''
                The port the RADIUS server listens on. It listens on all
                interfaces. Unlike the LDAP servers, it cannot be disabled:
                setting this to 0 makes it bind an ephemeral port instead.
              '';
            };

            radiusSecret = lib.mkOption {
              type = lib.types.str;
              default = "secret";
              description = ''
                The shared secret for RADIUS clients. The upstream default is
                "secret"; change it before exposing the RADIUS listener. Prefer
                {option}`services.casdoor.environmentFile` for this value.
              '';
            };

            radiusDefaultOrganization = lib.mkOption {
              type = lib.types.str;
              default = "built-in";
              description = ''
                The organization that RADIUS clients are authenticated against
                when they do not name one.
              '';
            };
          };
        }
      );

      default = { };

      description = ''
        The configuration of the Casdoor server. Every option corresponds to a
        key of the upstream configuration file, see {file}`conf/app.conf` in
        the Casdoor source tree for the full list. The values are passed to
        the server as environment variables, which Casdoor prefers over its
        configuration file.

        Keys that have no dedicated option can be set with
        {option}`services.casdoor.extraConfig`.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        # The connection string can come from the "dataSourceName" option,
        # from "extraConfig" or from the environment file, which is the
        # recommended way to pass a password. Casdoor reads it from the
        # environment first and falls back to its configuration file, so all
        # three are equivalent at runtime.
        assertion =
          lib.elem settings.driverName [
            "sqlite"
            "sqlite3"
          ]
          || settings.dataSourceName != ""
          || (cfg.extraConfig.dataSourceName or "") != ""
          || cfg.environmentFile != null;
        message = ''
          services.casdoor.settings.dataSourceName must be set when using the
          "${settings.driverName}" database driver. It can be set with the
          services.casdoor.settings.dataSourceName option, with the
          services.casdoor.extraConfig option or in the file referenced by
          services.casdoor.environmentFile.
        '';
      }
    ];

    users.users = lib.optionalAttrs (cfg.user == defaultUser) {
      ${defaultUser} = {
        isSystemUser = true;
        group = cfg.group;
      };
    };

    users.groups = lib.optionalAttrs (cfg.group == defaultGroup) {
      ${defaultGroup} = { };
    };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.port ];

    systemd.services.casdoor = {
      description = "Casdoor identity and access management server";
      documentation = [ "https://casdoor.org/docs" ];
      wantedBy = [ "multi-user.target" ];
      after = [
        "network.target"
        "network-online.target"
      ];
      wants = [ "network-online.target" ];

      environment =
        lib.optionalAttrs (cfg.extraConfig != { }) (lib.mapAttrs (_: toString) cfg.extraConfig)
        // {
          CASDOOR_RUNTIME_DIR = "/var/lib/casdoor";
          httpport = toString cfg.port;
          runmode = "prod";
        }
        // environment;

      serviceConfig = {
        ExecStart = lib.escapeShellArgs [
          (lib.getExe package)
          "--createDatabase=${lib.boolToString createDatabase}"
        ];
        User = cfg.user;
        Group = cfg.group;
        Restart = "always";
        RestartSec = 5;
        EnvironmentFile = lib.mkIf (cfg.environmentFile != null) cfg.environmentFile;

        # Casdoor serves the web console and its configuration from the working
        # directory and writes its database, logs and uploads below it, so it
        # needs a writable directory of its own.
        StateDirectory = "casdoor";
        WorkingDirectory = "/var/lib/casdoor";

        # The server binds to a port and, unless it is configured otherwise,
        # also starts an LDAP and a RADIUS listener. Those need the
        # corresponding capabilities to bind to privileged ports.
        AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
        CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ];

        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateTmp = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        SystemCallArchitectures = "native";
        UMask = "0077";
      };
    };
  };
}
