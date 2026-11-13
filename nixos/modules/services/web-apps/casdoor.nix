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
  ) (lib.filterAttrs (name: value: name != "quota" && value != null && value != "") settings);

  # The quota is read from the configuration file when the server starts, so it
  # cannot be passed as an environment variable with the name of the setting.
  # The package refers to the variable "CASDOOR_QUOTA" in the configuration
  # file instead, which keeps the setting changeable at runtime.
  quotaEnvironment = {
    CASDOOR_QUOTA = builtins.toJSON settings.quota;
  };
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
      description = ''
        The port Casdoor listens on.

        Casdoor reads the port from its configuration file, which replaces
        the configuration that the environment provides, so the module passes
        the port in the variable that the configuration file of the package
        refers to.
      '';
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

            enableErrorMask2 = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = ''
                Whether to replace the messages of the errors of the API with
                a generic text. It hides more than
                {option}`services.casdoor.settings.enableErrorMask`, which
                only masks the details of the internal errors.
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

            disableVersionCheck = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = ''
                Whether to disable the check for the version of the running
                release altogether. It is a stricter version of
                {option}`services.casdoor.settings.disableUpgrade`, which only
                disables the check for new releases.
              '';
            };

            allowVendorUpgrade = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = ''
                Whether the instance may upgrade itself to a release of the
                vendor of the licensed edition. It only has an effect on the
                commercial and enterprise editions.
              '';
            };

            releaseDownloadUrl = lib.mkOption {
              type = lib.types.str;
              default = "";
              description = ''
                The address the releases are downloaded from when the instance
                upgrades itself. Leave it empty to use the releases on GitHub.
              '';
            };

            # Server

            appname = lib.mkOption {
              type = lib.types.str;
              default = "casdoor";
              description = ''
                The name of the application. It is shown as the display name of
                the WebAuthn authenticator and used as the name of the log
                file.
              '';
            };

            basePath = lib.mkOption {
              type = lib.types.str;
              default = "";
              description = ''
                The path prefix the instance is served under, for example
                "/casdoor". Leave it empty when the instance is served from the
                root of a host.
              '';
            };

            authState = lib.mkOption {
              type = lib.types.str;
              default = "casdoor";
              description = ''
                The value that the "state" parameter of the sign-in form has
                to carry. It protects the sign-in against cross-site request
                forgery.
              '';
            };

            batchSize = lib.mkOption {
              type = lib.types.int;
              default = 100;
              description = ''
                How many objects are read from or written to the database in one
                operation.
              '';
            };

            verificationCodeTimeout = lib.mkOption {
              type = lib.types.int;
              default = 10;
              description = ''
                How long a verification code stays valid, in minutes.
              '';
            };

            initScore = lib.mkOption {
              type = lib.types.int;
              default = 0;
              description = ''
                The score that new users of an organization get. It is only
                used when the organization does not define a score of its own.
              '';
            };

            isUsernameLowered = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = ''
                Whether usernames are converted to lower case when they are
                created and looked up.
              '';
            };

            logConfig = lib.mkOption {
              type = lib.types.str;
              default = "";
              description = ''
                The configuration of the logger, as a JSON object. The default
                writes the log to the file "logs/casdoor.log" in the state
                directory of the service.

                The value has to be valid JSON, because Casdoor refuses to start
                when it is not.
              '';
            };

            quota = lib.mkOption {
              type = lib.types.submodule (
                { ... }: {
                  options = {
                    organization = lib.mkOption {
                      type = lib.types.int;
                      default = -1;
                      description = "The maximum number of organizations.";
                    };

                    user = lib.mkOption {
                      type = lib.types.int;
                      default = -1;
                      description = "The maximum number of users.";
                    };

                    application = lib.mkOption {
                      type = lib.types.int;
                      default = -1;
                      description = "The maximum number of applications.";
                    };

                    provider = lib.mkOption {
                      type = lib.types.int;
                      default = -1;
                      description = "The maximum number of identity providers.";
                    };
                  };
                }
              );
              default = { };
              description = ''
                The maximum number of objects the instance creates. A negative
                number means that there is no limit.
              '';
            };

            defaultStorageProvider = lib.mkOption {
              type = lib.types.str;
              default = "";
              description = ''
                The name of the storage provider that is used for the uploads
                of an organization that does not name one itself.
              '';
            };

            isCloudIntranet = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = ''
                Whether the instance runs in a cloud intranet, where the
                storage providers are reached through their intranet
                endpoints.
              '';
            };

            socks5Proxy = lib.mkOption {
              type = lib.types.str;
              default = "";
              description = ''
                The SOCKS5 proxy that outgoing connections of the server use,
                for example "127.0.0.1:1080". Leave it empty to connect
                directly.
              '';
            };

            trustedProxies = lib.mkOption {
              type = lib.types.str;
              default = "";
              description = ''
                The addresses of the reverse proxies whose headers are
                believed when the client address is determined, separated by
                commas. Leave it empty to use the address of the connection.
              '';
            };

            fieldEncryptionKey = lib.mkOption {
              type = lib.types.str;
              default = "";
              description = ''
                The key that the sensitive fields of the objects in the
                database are encrypted with. It has to be 32 characters long.

                This value is passed through the systemd environment, which
                makes it visible in the Nix store and to local users. In
                production, put `fieldEncryptionKey=...` in a root-readable
                environment file and set
                {option}`services.casdoor.environmentFile` instead.
              '';
            };

            formCssAllowedUrls = lib.mkOption {
              type = lib.types.str;
              default = "";
              description = ''
                The addresses the custom sign-in forms may load their
                stylesheets from, separated by commas. Leave it empty to
                allow no address at all.
              '';
            };

            ipDbFile = lib.mkOption {
              type = lib.types.str;
              default = "";
              description = ''
                The path of the IP address database in the format of ipip.net,
                which Casdoor uses to name the place of a sign-in. Without it
                the place is derived from the network of the address.
              '';
            };

            webAuthnRpId = lib.mkOption {
              type = lib.types.str;
              default = "";
              example = "example.com";
              description = ''
                The identifier of the WebAuthn relying party. It replaces the
                host of {option}`services.casdoor.settings.origin`, which is
                used by default.

                The identifier is the domain without a scheme and without a
                path, and every origin has to be that domain or a subdomain
                of it.
              '';
            };

            webAuthnRpOrigins = lib.mkOption {
              type = lib.types.str;
              default = "";
              example = "https://example.com,https://www.example.com";
              description = ''
                The addresses the WebAuthn credentials may be used from,
                separated by commas. They are added to the address of
                {option}`services.casdoor.settings.origin`, which is used by
                default.

                Every address has to be within the domain of
                {option}`services.casdoor.settings.webAuthnRpId`.
              '';
            };

            frontendBaseDir = lib.mkOption {
              type = lib.types.str;
              default = "";
              description = ''
                The directory of a frontend that is served instead of the web
                console of the package, for example "/srv/casdoor". The
                directory has to exist on the machine the service runs on.

                Leave it empty to serve the web console of the package.
              '';
            };

            # Additional listeners

            gatewayHttpPort = lib.mkOption {
              type = lib.types.int;
              default = 80;
              description = ''
                The port the site proxy of Casdoor listens on for plain HTTP.
                The proxy is only started when the instance has sites.
              '';
            };

            gatewayHttpsPort = lib.mkOption {
              type = lib.types.int;
              default = 443;
              description = ''
                The port the site proxy of Casdoor listens on for HTTPS. The
                proxy is only started when the instance has sites.
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

            marketplaceUrl = lib.mkOption {
              type = lib.types.str;
              default = "";
              description = ''
                The URL the web console loads the themes of the theme showcase
                from. It is used when
                {option}`services.casdoor.settings.themeShowcase` is enabled
                and when Casdoor runs in demo mode.

                Leave it empty to use the upstream default, which is the
                "casdoor-integrations" repository on jsDelivr.
              '';
            };

            editionDemoUrls = lib.mkOption {
              type = lib.types.str;
              default = "";
              description = ''
                The addresses of the demo sites of the commercial and the
                enterprise edition, as comma-separated pairs of an edition and
                an address, for example
                "Commercial=https://demo-commercial.example.com". The address
                may contain "{domain}", which is replaced with the domain of
                the host without its first label.
              '';
            };

            frontendCdnUrl = lib.mkOption {
              type = lib.types.str;
              default = "";
              description = ''
                The address the assets of the web console are loaded from, with
                "{name}" and "{version}" replaced by the name and the version
                of the frontend package, for example
                "https://cdn.jsdelivr.net/npm/{name}@{version}". It is only
                used by a console that was built from the frontend package.
              '';
            };

            marketplaceServerUrl = lib.mkOption {
              type = lib.types.str;
              default = "";
              description = ''
                The address of the marketplace server that the paid
                integrations are downloaded from. Leave it empty to use the
                upstream servers.
              '';
            };

            maxItemsForFlatMenu = lib.mkOption {
              type = lib.types.int;
              default = 7;
              description = ''
                How many entries the menu of the web console shows before it
                switches to a grouped menu.
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

            # Tracing

            otelEndpoint = lib.mkOption {
              type = lib.types.str;
              default = "";
              example = "http://localhost:4318";
              description = ''
                The address of the OpenTelemetry collector that the traces of
                the server are sent to. Leave it empty to not collect traces.

                Tracing is a feature of the commercial edition.
              '';
            };

            otelHeaders = lib.mkOption {
              type = lib.types.str;
              default = "";
              description = ''
                The headers that are sent to the OpenTelemetry collector, as
                comma-separated pairs of a name and a value, for example
                "authorization=Bearer token".
              '';
            };

            otelServiceName = lib.mkOption {
              type = lib.types.str;
              default = "";
              description = ''
                The name of the service that the traces are reported for. It
                defaults to "casdoor".
              '';
            };

            # Certificate sign-in

            certLoginPort = lib.mkOption {
              type = lib.types.port;
              default = 0;
              description = ''
                The port of the listener that serves the sign-in with a client
                certificate. It is disabled by default.

                The sign-in with a client certificate is a feature of the
                enterprise edition.
              '';
            };

            certLoginCert = lib.mkOption {
              type = lib.types.str;
              default = "";
              description = ''
                The certificate that the listener for the sign-in with a client
                certificate uses. It is either the identifier of a certificate
                in Casdoor, like "admin/cert-login", or the path of a PEM file.
              '';
            };

            certLoginKey = lib.mkOption {
              type = lib.types.str;
              default = "";
              description = ''
                The path of the PEM file with the private key that belongs to
                {option}`services.casdoor.settings.certLoginCert`, when that
                option points at a file.
              '';
            };

            certLoginHeader = lib.mkOption {
              type = lib.types.str;
              default = "";
              description = ''
                The header that a reverse proxy puts the certificate of the
                client in, for example "X-SSL-Client-Cert". Leave it empty to
                use that header.
              '';
            };

            certLoginTrustedProxies = lib.mkOption {
              type = lib.types.str;
              default = "";
              description = ''
                The addresses of the reverse proxies whose headers are believed
                when the certificate of the client is read, separated by
                commas.
              '';
            };

            # Licensed editions

            license = lib.mkOption {
              type = lib.types.str;
              default = "";
              description = ''
                The license of the commercial or the enterprise edition, either
                as the text of the license or as the path of a file that holds
                it.

                This value is passed through the systemd environment, which
                makes it visible in the Nix store and to local users. In
                production, put `license=...` in a root-readable environment
                file and set {option}`services.casdoor.environmentFile`
                instead.
              '';
            };

            licenseServer = lib.mkOption {
              type = lib.types.str;
              default = "";
              example = "none";
              description = ''
                The address of the license server that the instance reports to.
                Set it to "none" for an instance without Internet access.
              '';
            };

            acmeEmail = lib.mkOption {
              type = lib.types.str;
              default = "";
              description = ''
                The email address of the ACME account that the certificates of
                the sites are issued for.
              '';
            };

            acmePrivateKey = lib.mkOption {
              type = lib.types.str;
              default = "";
              description = ''
                The private key of the ACME account that the certificates of
                the sites are issued for.

                This value is passed through the systemd environment, which
                makes it visible in the Nix store and to local users. In
                production, put `acmePrivateKey=...` in a root-readable
                environment file and set
                {option}`services.casdoor.environmentFile` instead.
              '';
            };

            hsmType = lib.mkOption {
              type = lib.types.str;
              default = "";
              example = "pkcs11";
              description = ''
                The type of the hardware security module that holds the
                private keys of the certificates. Only "pkcs11" is supported.
                Leave it empty to not use a hardware security module.
              '';
            };

            hsmLibrary = lib.mkOption {
              type = lib.types.str;
              default = "";
              description = ''
                The path of the library of the hardware security module.
              '';
            };

            hsmSlot = lib.mkOption {
              type = lib.types.str;
              default = "";
              description = ''
                The slot of the token of the hardware security module that
                holds the keys.
              '';
            };

            hsmTokenLabel = lib.mkOption {
              type = lib.types.str;
              default = "";
              description = ''
                The label of the token of the hardware security module that
                holds the keys.
              '';
            };

            hsmPin = lib.mkOption {
              type = lib.types.str;
              default = "";
              description = ''
                The PIN of the token of the hardware security module.

                This value is passed through the systemd environment, which
                makes it visible in the Nix store and to local users. In
                production, put `hsmPin=...` in a root-readable environment
                file and set {option}`services.casdoor.environmentFile`
                instead.
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
          # Casdoor reads the port from its configuration file, which replaces
          # the configuration that the environment provides, so the file refers
          # to this variable instead.
          CASDOOR_HTTP_PORT = toString cfg.port;
          runmode = "prod";
        }
        // environment
        // quotaEnvironment;

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
