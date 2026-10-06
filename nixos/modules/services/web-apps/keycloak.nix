{
  config,
  options,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.services.keycloak;
  opt = options.services.keycloak;

  inherit (lib)
    types
    mkMerge
    mkOption
    mkChangedOptionModule
    mkRenamedOptionModule
    mkRemovedOptionModule
    mkPackageOption
    concatStringsSep
    mapAttrsToList
    escapeShellArg
    mkIf
    optionalString
    optionals
    mkDefault
    literalExpression
    isAttrs
    literalMD
    maintainers
    catAttrs
    collect
    hasPrefix
    ;

  inherit (builtins)
    elem
    typeOf
    isInt
    isString
    hashString
    isPath
    ;

  prefixUnlessEmpty = prefix: string: optionalString (string != "") "${prefix}${string}";
in
{
  imports = [
    (mkRenamedOptionModule
      [ "services" "keycloak" "bindAddress" ]
      [ "services" "keycloak" "settings" "http-host" ]
    )
    (mkRenamedOptionModule
      [ "services" "keycloak" "forceBackendUrlToFrontendUrl" ]
      [ "services" "keycloak" "settings" "hostname-strict-backchannel" ]
    )
    (mkChangedOptionModule
      [ "services" "keycloak" "httpPort" ]
      [ "services" "keycloak" "settings" "http-port" ]
      (config: builtins.fromJSON config.services.keycloak.httpPort)
    )
    (mkChangedOptionModule
      [ "services" "keycloak" "httpsPort" ]
      [ "services" "keycloak" "settings" "https-port" ]
      (config: builtins.fromJSON config.services.keycloak.httpsPort)
    )
    (mkRemovedOptionModule [ "services" "keycloak" "frontendUrl" ] ''
      Set `services.keycloak.settings.hostname' and `services.keycloak.settings.http-relative-path' instead.
      NOTE: You likely want to set 'http-relative-path' to '/auth' to keep compatibility with your clients.
            See its description for more information.
    '')
    (mkRemovedOptionModule [
      "services"
      "keycloak"
      "extraConfig"
    ] "Use `services.keycloak.settings' instead.")
  ];

  options.services.keycloak =
    let
      inherit (types)
        bool
        str
        int
        nullOr
        attrsOf
        oneOf
        path
        enum
        package
        port
        listOf
        ;

      assertStringPath =
        optionName: value:
        if isPath value then
          throw ''
            services.keycloak.${optionName}:
              ${toString value}
              is a Nix path, but should be a string, since Nix
              paths are copied into the world-readable Nix store.
          ''
        else
          value;
    in
    {
      enable = mkOption {
        type = bool;
        default = false;
        example = true;
        description = ''
          Whether to enable the Keycloak identity and access management
          server.
        '';
      };

      sslCertificate = mkOption {
        type = nullOr path;
        default = null;
        example = "/run/keys/ssl_cert";
        apply = assertStringPath "sslCertificate";
        description = ''
          The path to a PEM formatted certificate to use for TLS/SSL
          connections.
        '';
      };

      sslCertificateKey = mkOption {
        type = nullOr path;
        default = null;
        example = "/run/keys/ssl_key";
        apply = assertStringPath "sslCertificateKey";
        description = ''
          The path to a PEM formatted private key to use for TLS/SSL
          connections.
        '';
      };

      plugins = lib.mkOption {
        type = lib.types.listOf lib.types.path;
        default = [ ];
        description = ''
          Keycloak plugin jar, ear files or derivations containing
          them. Packaged plugins are available through
          `pkgs.keycloak.plugins`.
        '';
      };

      database = {
        type = mkOption {
          type = enum [
            "mysql"
            "mariadb"
            "postgresql"
          ];
          default = "postgresql";
          example = "mariadb";
          description = ''
            The type of database Keycloak should connect to.
          '';
        };

        host = mkOption {
          type = str;
          default =
            if !cfg.database.createLocally then
              "localhost"
            else if cfg.database.type == "postgresql" then
              "/run/postgresql"
            else
              "/run/mysqld/mysqld.sock";
          defaultText = literalMD ''
            `/run/postgresql` for PostgreSQL or `/run/mysqld/mysqld.sock` for
            MySQL/MariaDB if [](#opt-services.keycloak.database.createLocally)
            is enabled, otherwise `localhost`
          '';
          description = ''
            Hostname of the database to connect to, or the path of a Unix
            socket to connect through using socket authentication.

            For PostgreSQL, a socket path is the directory containing the
            socket (e.g. `/run/postgresql`). For MySQL and MariaDB, it is the
            socket file itself (e.g. `/run/mysqld/mysqld.sock`). The
            `junixsocket` plugins needed for PostgreSQL and MySQL socket
            connections are added automatically.

            Must be a socket path if
            [](#opt-services.keycloak.database.createLocally) is enabled.
          '';
        };

        port =
          let
            dbPorts = {
              postgresql = 5432;
              mariadb = 3306;
              mysql = 3306;
            };
          in
          mkOption {
            type = port;
            default =
              if cfg.database.createLocally && cfg.database.type == "postgresql" then
                config.services.postgresql.settings.port
              else
                dbPorts.${cfg.database.type};
            defaultText = literalMD ''
              [](#opt-services.postgresql.settings.port) for a locally created
              PostgreSQL database, otherwise the default port of the selected database.
            '';
            description = ''
              Port of the database to connect to.

              For PostgreSQL socket connections, this selects the socket file
              (`.s.PGSQL.<port>`) within the socket directory. It is unused for
              MySQL and MariaDB socket connections.
            '';
          };

        useSSL = mkOption {
          type = bool;
          default = cfg.database.host != "localhost" && !hasPrefix "/" cfg.database.host;
          defaultText = literalExpression ''config.${opt.database.host} != "localhost" && !lib.hasPrefix "/" config.${opt.database.host}'';
          description = ''
            Whether the database connection should be secured by SSL / TLS.

            Defaults to `false` for localhost and Unix socket connections.
          '';
        };

        caCert = mkOption {
          type = nullOr path;
          default = null;
          description = ''
            The SSL / TLS CA certificate that verifies the identity of the
            database server.

            Required when PostgreSQL is used and SSL is turned on.

            For MySQL, if left at `null`, the default
            Java keystore is used, which should suffice if the server
            certificate is issued by an official CA.
          '';
        };

        createLocally = mkOption {
          type = bool;
          default = true;
          description = ''
            Whether to create the database and user on the local host. Set
            this to `false` if you use an external database or provision a
            local one yourself.
          '';
        };

        name = mkOption {
          type = str;
          default = "keycloak";
          description = ''
            Name of the database to connect to. Must be `keycloak` if
            [](#opt-services.keycloak.database.createLocally) is enabled.
          '';
        };

        username = mkOption {
          type = str;
          default = "keycloak";
          description = ''
            Username to connect to the database with. Must be `keycloak` if
            [](#opt-services.keycloak.database.createLocally) is enabled.
          '';
        };

        passwordFile = mkOption {
          type = nullOr path;
          default = null;
          example = "/run/keys/db_password";
          apply = assertStringPath "passwordFile";
          description = ''
            The path to a file containing the database password.

            Not required if [](#opt-services.keycloak.database.host) is a Unix
            socket path.
          '';
        };
      };

      package = mkPackageOption pkgs "keycloak" { };

      initialAdminPassword = mkOption {
        type = nullOr str;
        default = null;
        description = ''
          Initial password set for the temporary `admin` user.
          The password is not stored safely and should be changed
          immediately in the admin panel.

          See [Admin bootstrap and recovery](https://www.keycloak.org/server/bootstrap-admin-recovery) for details.
        '';
      };

      themes = mkOption {
        type = attrsOf package;
        default = { };
        description = ''
          Additional theme packages for Keycloak. Each theme is linked into
          subdirectory with a corresponding attribute name.

          Theme packages consist of several subdirectories which provide
          different theme types: for example, `account`,
          `login` etc. After adding a theme to this option you
          can select it by its name in Keycloak administration console.
        '';
      };

      realmFiles = mkOption {
        type = listOf path;
        example = lib.literalExpression ''
          [
            ./some/realm.json
            ./another/realm.json
          ]
        '';
        default = [ ];
        description = ''
          Realm files that the server is going to import during startup.
          If a realm already exists in the server, the import operation is
          skipped. Importing the master realm is not supported. All files are
          expected to be in `json` format. See the
          [documentation](https://www.keycloak.org/server/importExport) for
          further information.
        '';
      };

      settings = mkOption {
        type = lib.types.submodule {
          freeformType = attrsOf (
            nullOr (oneOf [
              str
              int
              bool
              (attrsOf path)
            ])
          );

          options = {
            http-host = mkOption {
              type = str;
              default = "::";
              example = "::1";
              description = ''
                On which address Keycloak should accept new connections.
              '';
            };

            http-port = mkOption {
              type = port;
              default = 80;
              example = 8080;
              description = ''
                On which port Keycloak should listen for new HTTP connections.
              '';
            };

            https-port = mkOption {
              type = port;
              default = 443;
              example = 8443;
              description = ''
                On which port Keycloak should listen for new HTTPS connections.
              '';
            };

            http-relative-path = mkOption {
              type = str;
              default = "/";
              example = "/auth";
              apply = x: if !(hasPrefix "/") x then "/" + x else x;
              description = ''
                The path relative to `/` for serving
                resources.

                ::: {.note}
                In versions of Keycloak using Wildfly (&lt;17),
                this defaulted to `/auth`. If
                upgrading from the Wildfly version of Keycloak,
                i.e. a NixOS version before 22.05, you'll likely
                want to set this to `/auth` to
                keep compatibility with your clients.

                See <https://www.keycloak.org/migration/migrating-to-quarkus>
                for more information on migrating from Wildfly to Quarkus.
                :::
              '';
            };

            hostname = mkOption {
              type = nullOr str;
              example = "keycloak.example.com";
              description = ''
                The hostname part of the public URL used as base for
                all frontend requests.

                See <https://www.keycloak.org/server/hostname>
                for more information about hostname configuration.
              '';
            };

            hostname-backchannel-dynamic = mkOption {
              type = bool;
              default = false;
              example = true;
              description = ''
                Enables dynamic resolving of backchannel URLs,
                including hostname, scheme, port and context path.

                See <https://www.keycloak.org/server/hostname>
                for more information about hostname configuration.
              '';
            };
          };
        };

        example = literalExpression ''
          {
            hostname = "keycloak.example.com";
            https-key-store-file = "/path/to/file";
            https-key-store-password = { _secret = "/run/keys/store_password"; };
          }
        '';

        description = ''
          Configuration options corresponding to parameters set in
          {file}`conf/keycloak.conf`.

          Most available options are documented at <https://www.keycloak.org/server/all-config>.

          Options containing secret data should be set to an attribute
          set containing the attribute `_secret` - a
          string pointing to a file containing the value the option
          should be set to. See the example to get a better picture of
          this: in the resulting
          {file}`conf/keycloak.conf` file, the
          `https-key-store-password` key will be set
          to the contents of the
          {file}`/run/keys/store_password` file.
        '';
      };
    };

  config =
    let
      # Database connection paths:
      # - createLocally creates the database and user locally, host must be a socket path
      # - createLocally = false with a socket path connects through the socket without a password
      # - createLocally = false with a hostname connects over TCP using passwordFile
      createLocalPostgreSQL = cfg.database.createLocally && cfg.database.type == "postgresql";
      createLocalMySQL =
        cfg.database.createLocally
        && elem cfg.database.type [
          "mysql"
          "mariadb"
        ];
      isUnixSocket = hasPrefix "/" cfg.database.host;

      mySqlCaKeystore = pkgs.runCommand "mysql-ca-keystore" { } ''
        ${pkgs.jre}/bin/keytool -importcert -trustcacerts -alias MySQLCACert -file ${cfg.database.caCert} -keystore $out -storepass notsosecretpassword -noprompt
      '';

      # Both theme and theme type directories need to be actual
      # directories in one hierarchy to pass Keycloak checks.
      themesBundle = pkgs.runCommand "keycloak-themes" { } ''
        linkTheme() {
          theme="$1"
          name="$2"

          mkdir "$out/$name"
          for typeDir in "$theme"/*; do
            if [ -d "$typeDir" ]; then
              type="$(basename "$typeDir")"
              mkdir "$out/$name/$type"
              for file in "$typeDir"/*; do
                ln -sn "$file" "$out/$name/$type/$(basename "$file")"
              done
            fi
          done
        }

        mkdir -p "$out"
        for theme in ${keycloakBuild}/themes/*; do
          if [ -d "$theme" ]; then
            linkTheme "$theme" "$(basename "$theme")"
          fi
        done

        ${concatStringsSep "\n" (
          mapAttrsToList (name: theme: "linkTheme ${theme} ${escapeShellArg name}") cfg.themes
        )}
      '';

      keycloakConfig = lib.generators.toKeyValue {
        mkKeyValue = lib.flip lib.generators.mkKeyValueDefault "=" {
          mkValueString =
            v:
            if isInt v then
              toString v
            else if isString v then
              v
            else if true == v then
              "true"
            else if false == v then
              "false"
            else if isSecret v then
              hashString "sha256" v._secret
            else
              throw "unsupported type ${typeOf v}: ${(lib.generators.toPretty { }) v}";
        };
      };

      isSecret = v: isAttrs v && v ? _secret && isString v._secret;
      filteredConfig = lib.converge (lib.filterAttrsRecursive (
        _: v:
        !elem v [
          { }
          null
        ]
      )) cfg.settings;
      confFile = pkgs.writeText "keycloak.conf" (keycloakConfig filteredConfig);
      keycloakBuild = cfg.package.override {
        inherit confFile;
        plugins =
          cfg.package.enabledPlugins
          ++ cfg.plugins
          ++ (with cfg.package.plugins; [
            quarkus-systemd-notify
            quarkus-systemd-notify-deployment
          ])
          # the MariaDB driver supports Unix sockets natively
          ++ optionals (isUnixSocket && cfg.database.type != "mariadb") (
            with cfg.package.plugins;
            [
              junixsocket-common
              junixsocket-native-common
            ]
            ++ optionals (cfg.database.type == "mysql") [ junixsocket-mysql ]
          );
      };
    in
    mkIf cfg.enable {
      assertions = [
        {
          assertion =
            (cfg.database.useSSL && cfg.database.type == "postgresql") -> (cfg.database.caCert != null);
          message = "A CA certificate must be specified (in 'services.keycloak.database.caCert') when PostgreSQL is used with SSL";
        }
        {
          assertion = cfg.settings.hostname != null || !cfg.settings.hostname-strict or true;
          message = "Setting the Keycloak hostname is required, see `services.keycloak.settings.hostname`";
        }
        {
          assertion = cfg.settings.hostname-url or null == null;
          message = ''
            The option `services.keycloak.settings.hostname-url' has been removed.
            Set `services.keycloak.settings.hostname' instead.
            See [New Hostname options](https://www.keycloak.org/docs/25.0.0/upgrading/#new-hostname-options) for details.
          '';
        }
        {
          assertion = cfg.settings.hostname-strict-backchannel or null == null;
          message = ''
            The option `services.keycloak.settings.hostname-strict-backchannel' has been removed.
            Set `services.keycloak.settings.hostname-backchannel-dynamic' instead.
            See [New Hostname options](https://www.keycloak.org/docs/25.0.0/upgrading/#new-hostname-options) for details.
          '';
        }
        {
          assertion = cfg.settings.proxy or null == null;
          message = ''
            The option `services.keycloak.settings.proxy' has been removed.
            Set `services.keycloak.settings.proxy-headers` in combination
            with other hostname options as needed instead.
            See [Proxy option removed](https://www.keycloak.org/docs/latest/upgrading/index.html#proxy-option-removed)
            for more information.
          '';
        }
        {
          assertion = cfg.database.createLocally -> isUnixSocket;
          message = ''
            services.keycloak.database.host must be a Unix socket path (starting with /)
            when services.keycloak.database.createLocally is enabled. To connect over TCP,
            set services.keycloak.database.createLocally = false.
          '';
        }
        {
          assertion =
            cfg.database.createLocally
            -> cfg.database.name == "keycloak" && cfg.database.username == "keycloak";
          message = ''
            services.keycloak.database.name and services.keycloak.database.username must be
            "keycloak" when services.keycloak.database.createLocally is enabled. To use other
            names, set services.keycloak.database.createLocally = false.
          '';
        }
        {
          assertion = !isUnixSocket -> cfg.database.passwordFile != null;
          message = ''
            services.keycloak.database.passwordFile must be set when connecting over TCP
            (services.keycloak.database.host not starting with /).
          '';
        }
      ];

      environment.systemPackages = [ keycloakBuild ];

      services.keycloak.settings =
        let
          postgresParams = concatStringsSep "&" (
            optionals cfg.database.useSSL [
              "ssl=true"
            ]
            ++ optionals (cfg.database.caCert != null) [
              "sslrootcert=${cfg.database.caCert}"
              "sslmode=verify-ca"
            ]
          );
          mariadbParams = concatStringsSep "&" (
            [
              "characterEncoding=UTF-8"
            ]
            ++ optionals cfg.database.useSSL [
              "useSSL=true"
              "requireSSL=true"
              "verifyServerCertificate=true"
            ]
            ++ optionals (cfg.database.caCert != null) [
              "trustCertificateKeyStoreUrl=file:${mySqlCaKeystore}"
              "trustCertificateKeyStorePassword=notsosecretpassword"
            ]
          );

          dbName = cfg.database.name;
          dbProps = if cfg.database.type == "postgresql" then postgresParams else mariadbParams;

          unixSocketUrl =
            {
              postgresql = "jdbc:postgresql://localhost/${dbName}?socketFactory=org.newsclub.net.unix.AFUNIXSocketFactory$FactoryArg&socketFactoryArg=${cfg.database.host}/.s.PGSQL.${toString cfg.database.port}&sslMode=disable";
              mariadb = "jdbc:mariadb://address=(localSocket=${cfg.database.host})/${dbName}";
              mysql = "jdbc:mysql://localhost/${dbName}?socketFactory=org.newsclub.net.mysql.AFUNIXDatabaseSocketFactoryCJ&junixsocket.file=${cfg.database.host}&sslMode=DISABLED";
            }
            .${cfg.database.type};
        in
        mkMerge [
          {
            db = if cfg.database.type == "postgresql" then "postgres" else cfg.database.type;
            db-username = cfg.database.username;
            db-password = mkIf (cfg.database.passwordFile != null) {
              _secret = cfg.database.passwordFile;
            };
          }
          (mkIf isUnixSocket {
            db-url = unixSocketUrl;
          })
          (mkIf (!isUnixSocket) {
            db-url-host = cfg.database.host;
            db-url-port = toString cfg.database.port;
            db-url-database = dbName;
            db-url-properties = prefixUnlessEmpty "?" dbProps;
            db-url = null;
          })
          (mkIf (cfg.sslCertificate != null && cfg.sslCertificateKey != null) {
            https-certificate-file = "/run/keycloak/ssl/ssl_cert";
            https-certificate-key-file = "/run/keycloak/ssl/ssl_key";
          })
        ];

      systemd.services.keycloakPostgreSQLInit = mkIf createLocalPostgreSQL {
        after = [ "postgresql.target" ];
        before = [ "keycloak.service" ];
        bindsTo = [ "postgresql.target" ];
        path = [ config.services.postgresql.package ];
        environment.PGPORT = toString config.services.postgresql.settings.port;
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          User = "postgres";
          Group = "postgres";
        };
        script = ''
          set -o errexit -o pipefail -o nounset -o errtrace
          shopt -s inherit_errexit

          psql -tAc "SELECT 1 FROM pg_roles WHERE rolname='keycloak'" | grep -q 1 || psql -tAc 'CREATE ROLE keycloak WITH LOGIN CREATEDB'
          psql -tAc "SELECT 1 FROM pg_database WHERE datname = 'keycloak'" | grep -q 1 || psql -tAc 'CREATE DATABASE "keycloak" OWNER "keycloak"'
        '';
        enableStrictShellChecks = true;
      };

      systemd.services.keycloakMySQLInit =
        let
          account = "'${cfg.database.username}'@'localhost'";
          socketPlugin = if cfg.database.type == "mariadb" then "unix_socket" else "auth_socket";
          identifiedBySocket =
            if cfg.database.type == "mariadb" then "VIA unix_socket" else "WITH auth_socket";
        in
        mkIf createLocalMySQL {
          after = [ "mysql.service" ];
          before = [ "keycloak.service" ];
          bindsTo = [ "mysql.service" ];
          path = [ config.services.mysql.package ];
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
            User = config.services.mysql.user;
            Group = config.services.mysql.group;
          };
          script = ''
            set -o errexit -o pipefail -o nounset -o errtrace
            shopt -s inherit_errexit

            ( echo "CREATE USER IF NOT EXISTS ${account} IDENTIFIED ${identifiedBySocket};"
              echo "CREATE DATABASE IF NOT EXISTS keycloak CHARACTER SET utf8 COLLATE utf8_unicode_ci;"
              echo "GRANT ALL PRIVILEGES ON keycloak.* TO ${account};"
            ) | mysql -N

            plugin="$(mysql -N -e "SELECT plugin FROM mysql.user WHERE user = '${cfg.database.username}' AND host = 'localhost'")"
            if [[ "$plugin" != ${socketPlugin} ]]; then
              echo "Switching ${account} from $plugin to ${socketPlugin} authentication"
              mysql -N -e "ALTER USER ${account} IDENTIFIED ${identifiedBySocket}"
            fi
          '';
          enableStrictShellChecks = true;
        };

      systemd.tmpfiles.settings."10-keycloak" =
        let
          mkTarget =
            file:
            let
              baseName = baseNameOf file;
              name = if lib.hasSuffix ".json" baseName then baseName else "${baseName}.json";
            in
            "/run/keycloak/data/import/${name}";
          settingsList = map (f: {
            name = mkTarget f;
            value = {
              "L+".argument = "${f}";
            };
          }) cfg.realmFiles;
        in
        builtins.listToAttrs settingsList;

      systemd.services.keycloak =
        let
          databaseServices =
            if createLocalPostgreSQL then
              [
                "keycloakPostgreSQLInit.service"
                "postgresql.target"
              ]
            else if createLocalMySQL then
              [
                "keycloakMySQLInit.service"
                "mysql.service"
              ]
            else
              [ ];
          secretPaths = catAttrs "_secret" (collect isSecret cfg.settings);
          mkSecretReplacement = file: ''
            replace-secret ${hashString "sha256" file} "$CREDENTIALS_DIRECTORY/${baseNameOf file}" /run/keycloak/conf/keycloak.conf
          '';
          secretReplacements = lib.concatMapStrings mkSecretReplacement secretPaths;
        in
        {
          after = databaseServices;
          bindsTo = databaseServices;
          wantedBy = [ "multi-user.target" ];
          path = with pkgs; [
            keycloakBuild
            openssl
            replace-secret
          ];
          environment = {
            KC_HOME_DIR = "/run/keycloak";
            KC_CONF_DIR = "/run/keycloak/conf";
          }
          // lib.optionalAttrs (cfg.initialAdminPassword != null) {
            KC_BOOTSTRAP_ADMIN_USERNAME = "admin";
            KC_BOOTSTRAP_ADMIN_PASSWORD = cfg.initialAdminPassword;
          };
          serviceConfig = {
            LoadCredential =
              map (p: "${baseNameOf p}:${p}") secretPaths
              ++ optionals (cfg.sslCertificate != null && cfg.sslCertificateKey != null) [
                "ssl_cert:${cfg.sslCertificate}"
                "ssl_key:${cfg.sslCertificateKey}"
              ];
            User = "keycloak";
            Group = "keycloak";
            DynamicUser = true;
            RuntimeDirectory = "keycloak";
            RuntimeDirectoryMode = "0700";
            AmbientCapabilities = "CAP_NET_BIND_SERVICE";
            Type = "notify"; # Requires quarkus-systemd-notify plugin
            NotifyAccess = "all";
          };
          script = ''
            set -o errexit -o pipefail -o nounset -o errtrace
            shopt -s inherit_errexit

            umask u=rwx,g=,o=

            ln -s ${themesBundle} /run/keycloak/themes
            ln -s ${keycloakBuild}/providers /run/keycloak/
            ln -s ${keycloakBuild}/lib /run/keycloak/

            install -D -m 0600 ${confFile} /run/keycloak/conf/keycloak.conf

            ${secretReplacements}

            # Escape any backslashes in the db parameters, since
            # they're otherwise unexpectedly read as escape
            # sequences.
            sed -i '/db-/ s|\\|\\\\|g' /run/keycloak/conf/keycloak.conf

          ''
          + optionalString (cfg.sslCertificate != null && cfg.sslCertificateKey != null) ''
            mkdir -p /run/keycloak/ssl
            cp "$CREDENTIALS_DIRECTORY"/ssl_{cert,key} /run/keycloak/ssl/
          ''
          + ''
            kc.sh --verbose start --optimized ${lib.optionalString (cfg.realmFiles != [ ]) "--import-realm"}
          '';
          enableStrictShellChecks = true;
        };

      services.postgresql.enable = mkDefault createLocalPostgreSQL;
      services.mysql.enable = mkDefault createLocalMySQL;
      services.mysql.package =
        let
          dbPkg = if cfg.database.type == "mariadb" then pkgs.mariadb else pkgs.mysql84;
        in
        mkIf createLocalMySQL (mkDefault dbPkg);
    };

  meta.doc = ./keycloak.md;
  meta.maintainers = with maintainers; [
    talyz
    anish
  ];
}
