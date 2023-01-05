{ config, options, pkgs, lib, ... }:

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
    splitString
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
  imports =
    [
      (mkRenamedOptionModule
        [ "services" "keycloak" "bindAddress" ]
        [ "services" "keycloak" "settings" "http-host" ])
      (mkRenamedOptionModule
        [ "services" "keycloak" "forceBackendUrlToFrontendUrl"]
        [ "services" "keycloak" "settings" "hostname-strict-backchannel"])
      (mkChangedOptionModule
        [ "services" "keycloak" "httpPort" ]
        [ "services" "keycloak" "settings" "http-port" ]
        (config:
          builtins.fromJSON config.services.keycloak.httpPort))
      (mkChangedOptionModule
        [ "services" "keycloak" "httpsPort" ]
        [ "services" "keycloak" "settings" "https-port" ]
        (config:
          builtins.fromJSON config.services.keycloak.httpsPort))
      (mkRemovedOptionModule
        [ "services" "keycloak" "frontendUrl" ]
        ''
          Set `services.keycloak.settings.hostname' and `services.keycloak.settings.http-relative-path' instead.
          NOTE: You likely want to set 'http-relative-path' to '/auth' to keep compatibility with your clients.
                See its description for more information.
        '')
      (mkRemovedOptionModule
        [ "services" "keycloak" "extraConfig" ]
        "Use `services.keycloak.settings' instead.")
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
        port;

      assertStringPath = optionName: value:
        if isPath value then
          throw ''
            services.keycloak.${optionName}:
              ${toString value}
              is a Nix path, but should be a string, since Nix
              paths are copied into the world-readable Nix store.
          ''
        else value;
    in
    {
      enable = mkOption {
        type = bool;
        default = false;
        example = true;
        description = lib.mdDoc ''
          Whether to enable the Keycloak identity and access management
          server.
        '';
      };

      sslCertificate = mkOption {
        type = nullOr path;
        default = null;
        example = "/run/keys/ssl_cert";
        apply = assertStringPath "sslCertificate";
        description = lib.mdDoc ''
          The path to a PEM formatted certificate to use for TLS/SSL
          connections.
        '';
      };

      sslCertificateKey = mkOption {
        type = nullOr path;
        default = null;
        example = "/run/keys/ssl_key";
        apply = assertStringPath "sslCertificateKey";
        description = lib.mdDoc ''
          The path to a PEM formatted private key to use for TLS/SSL
          connections.
        '';
      };

      plugins = lib.mkOption {
        type = lib.types.listOf lib.types.path;
        default = [ ];
        description = lib.mdDoc ''
          Keycloak plugin jar, ear files or derivations containing
          them. Packaged plugins are available through
          `pkgs.keycloak.plugins`.
        '';
      };

      database = {
        type = mkOption {
          type = enum [ "mysql" "mariadb" "postgresql" ];
          default = "postgresql";
          example = "mariadb";
          description = lib.mdDoc ''
            The type of database Keycloak should connect to.
          '';
        };

        host = mkOption {
          type = str;
          default = "localhost";
          description = lib.mdDoc ''
            Hostname of the database to connect to.
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
            default = dbPorts.${cfg.database.type};
            defaultText = literalMD "default port of selected database";
            description = lib.mdDoc ''
              Port of the database to connect to.
            '';
          };

        useSSL = mkOption {
          type = bool;
          default = cfg.database.host != "localhost";
          defaultText = literalExpression ''config.${opt.database.host} != "localhost"'';
          description = lib.mdDoc ''
            Whether the database connection should be secured by SSL /
            TLS.
          '';
        };

        caCert = mkOption {
          type = nullOr path;
          default = null;
          description = lib.mdDoc ''
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
          description = lib.mdDoc ''
            Whether a database should be automatically created on the
            local host. Set this to false if you plan on provisioning a
            local database yourself. This has no effect if
            services.keycloak.database.host is customized.
          '';
        };

        name = mkOption {
          type = str;
          default = "keycloak";
          description = lib.mdDoc ''
            Database name to use when connecting to an external or
            manually provisioned database; has no effect when a local
            database is automatically provisioned.

            To use this with a local database, set [](#opt-services.keycloak.database.createLocally) to
            `false` and create the database and user
            manually.
          '';
        };

        username = mkOption {
          type = str;
          default = "keycloak";
          description = lib.mdDoc ''
            Username to use when connecting to an external or manually
            provisioned database; has no effect when a local database is
            automatically provisioned.

            To use this with a local database, set [](#opt-services.keycloak.database.createLocally) to
            `false` and create the database and user
            manually.
          '';
        };

        passwordFile = mkOption {
          type = path;
          example = "/run/keys/db_password";
          apply = assertStringPath "passwordFile";
          description = lib.mdDoc ''
            The path to a file containing the database password.
          '';
        };
      };

      package = mkOption {
        type = package;
        default = pkgs.keycloak;
        defaultText = literalExpression "pkgs.keycloak";
        description = lib.mdDoc ''
          Keycloak package to use.
        '';
      };

      initialAdminPassword = mkOption {
        type = str;
        default = "changeme";
        description = lib.mdDoc ''
          Initial password set for the `admin`
          user. The password is not stored safely and should be changed
          immediately in the admin panel.
        '';
      };

      themes = mkOption {
        type = attrsOf package;
        default = { };
        description = lib.mdDoc ''
          Additional theme packages for Keycloak. Each theme is linked into
          subdirectory with a corresponding attribute name.

          Theme packages consist of several subdirectories which provide
          different theme types: for example, `account`,
          `login` etc. After adding a theme to this option you
          can select it by its name in Keycloak administration console.
        '';
      };

      settings = mkOption {
        type = lib.types.submodule {
          freeformType = attrsOf (nullOr (oneOf [ str int bool (attrsOf path) ]));

          options = {
            http-host = mkOption {
              type = str;
              default = "0.0.0.0";
              example = "127.0.0.1";
              description = lib.mdDoc ''
                On which address Keycloak should accept new connections.
              '';
            };

            http-port = mkOption {
              type = port;
              default = 80;
              example = 8080;
              description = lib.mdDoc ''
                On which port Keycloak should listen for new HTTP connections.
              '';
            };

            https-port = mkOption {
              type = port;
              default = 443;
              example = 8443;
              description = lib.mdDoc ''
                On which port Keycloak should listen for new HTTPS connections.
              '';
            };

            http-relative-path = mkOption {
              type = str;
              default = "/";
              example = "/auth";
              apply = x: if !(hasPrefix "/") x then "/" + x else x;
              description = lib.mdDoc ''
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
              type = str;
              example = "keycloak.example.com";
              description = lib.mdDoc ''
                The hostname part of the public URL used as base for
                all frontend requests.

                See <https://www.keycloak.org/server/hostname>
                for more information about hostname configuration.
              '';
            };

            hostname-strict-backchannel = mkOption {
              type = bool;
              default = false;
              example = true;
              description = lib.mdDoc ''
                Whether Keycloak should force all requests to go
                through the frontend URL. By default, Keycloak allows
                backend requests to instead use its local hostname or
                IP address and may also advertise it to clients
                through its OpenID Connect Discovery endpoint.

                See <https://www.keycloak.org/server/hostname>
                for more information about hostname configuration.
              '';
            };

            proxy = mkOption {
              type = enum [ "edge" "reencrypt" "passthrough" "none" ];
              default = "none";
              example = "edge";
              description = lib.mdDoc ''
                The proxy address forwarding mode if the server is
                behind a reverse proxy.

                - `edge`:
                  Enables communication through HTTP between the
                  proxy and Keycloak.
                - `reencrypt`:
                  Requires communication through HTTPS between the
                  proxy and Keycloak.
                - `passthrough`:
                  Enables communication through HTTP or HTTPS between
                  the proxy and Keycloak.

                See <https://www.keycloak.org/server/reverseproxy> for more information.
              '';
            };
          };
        };

        example = literalExpression ''
          {
            hostname = "keycloak.example.com";
            proxy = "reencrypt";
            https-key-store-file = "/path/to/file";
            https-key-store-password = { _secret = "/run/keys/store_password"; };
          }
        '';

        description = lib.mdDoc ''
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
      # We only want to create a database if we're actually going to
      # connect to it.
      databaseActuallyCreateLocally = cfg.database.createLocally && cfg.database.host == "localhost";
      createLocalPostgreSQL = databaseActuallyCreateLocally && cfg.database.type == "postgresql";
      createLocalMySQL = databaseActuallyCreateLocally && elem cfg.database.type [ "mysql" "mariadb" ];

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

        ${concatStringsSep "\n" (mapAttrsToList (name: theme: "linkTheme ${theme} ${escapeShellArg name}") cfg.themes)}
      '';

      keycloakConfig = lib.generators.toKeyValue {
        mkKeyValue = lib.flip lib.generators.mkKeyValueDefault "=" {
          mkValueString = v: with builtins;
            if isInt v then toString v
            else if isString v then v
            else if true == v then "true"
            else if false == v then "false"
            else if isSecret v then hashString "sha256" v._secret
            else throw "unsupported type ${typeOf v}: ${(lib.generators.toPretty {}) v}";
        };
      };

      isSecret = v: isAttrs v && v ? _secret && isString v._secret;
      filteredConfig = lib.converge (lib.filterAttrsRecursive (_: v: ! elem v [{ } null])) cfg.settings;
      confFile = pkgs.writeText "keycloak.conf" (keycloakConfig filteredConfig);
      keycloakBuild = cfg.package.override {
        inherit confFile;
        plugins = cfg.package.enabledPlugins ++ cfg.plugins;
      };
    in
    mkIf cfg.enable
      {
        assertions = [
          {
            assertion = (cfg.database.useSSL && cfg.database.type == "postgresql") -> (cfg.database.caCert != null);
            message = "A CA certificate must be specified (in 'services.keycloak.database.caCert') when PostgreSQL is used with SSL";
          }
          {
            assertion = createLocalPostgreSQL -> config.services.postgresql.settings.standard_conforming_strings or true;
            message = "Setting up a local PostgreSQL db for Keycloak requires `standard_conforming_strings` turned on to work reliably";
          }
        ];

        environment.systemPackages = [ keycloakBuild ];

        services.keycloak.settings =
          let
            postgresParams = concatStringsSep "&" (
              optionals cfg.database.useSSL [
                "ssl=true"
              ] ++ optionals (cfg.database.caCert != null) [
                "sslrootcert=${cfg.database.caCert}"
                "sslmode=verify-ca"
              ]
            );
            mariadbParams = concatStringsSep "&" ([
              "characterEncoding=UTF-8"
            ] ++ optionals cfg.database.useSSL [
              "useSSL=true"
              "requireSSL=true"
              "verifyServerCertificate=true"
            ] ++ optionals (cfg.database.caCert != null) [
              "trustCertificateKeyStoreUrl=file:${mySqlCaKeystore}"
              "trustCertificateKeyStorePassword=notsosecretpassword"
            ]);
            dbProps = if cfg.database.type == "postgresql" then postgresParams else mariadbParams;
          in
          mkMerge [
            {
              db = if cfg.database.type == "postgresql" then "postgres" else cfg.database.type;
              db-username = if databaseActuallyCreateLocally then "keycloak" else cfg.database.username;
              db-password._secret = cfg.database.passwordFile;
              db-url-host = cfg.database.host;
              db-url-port = toString cfg.database.port;
              db-url-database = if databaseActuallyCreateLocally then "keycloak" else cfg.database.name;
              db-url-properties = prefixUnlessEmpty "?" dbProps;
              db-url = null;
            }
            (mkIf (cfg.sslCertificate != null && cfg.sslCertificateKey != null) {
              https-certificate-file = "/run/keycloak/ssl/ssl_cert";
              https-certificate-key-file = "/run/keycloak/ssl/ssl_key";
            })
          ];

        systemd.services.keycloakPostgreSQLInit = mkIf createLocalPostgreSQL {
          after = [ "postgresql.service" ];
          before = [ "keycloak.service" ];
          bindsTo = [ "postgresql.service" ];
          path = [ config.services.postgresql.package ];
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
            User = "postgres";
            Group = "postgres";
            LoadCredential = [ "db_password:${cfg.database.passwordFile}" ];
          };
          script = ''
            set -o errexit -o pipefail -o nounset -o errtrace
            shopt -s inherit_errexit

            create_role="$(mktemp)"
            trap 'rm -f "$create_role"' EXIT

            # Read the password from the credentials directory and
            # escape any single quotes by adding additional single
            # quotes after them, following the rules laid out here:
            # https://www.postgresql.org/docs/current/sql-syntax-lexical.html#SQL-SYNTAX-CONSTANTS
            db_password="$(<"$CREDENTIALS_DIRECTORY/db_password")"
            db_password="''${db_password//\'/\'\'}"

            echo "CREATE ROLE keycloak WITH LOGIN PASSWORD '$db_password' CREATEDB" > "$create_role"
            psql -tAc "SELECT 1 FROM pg_roles WHERE rolname='keycloak'" | grep -q 1 || psql -tA --file="$create_role"
            psql -tAc "SELECT 1 FROM pg_database WHERE datname = 'keycloak'" | grep -q 1 || psql -tAc 'CREATE DATABASE "keycloak" OWNER "keycloak"'
          '';
        };

        systemd.services.keycloakMySQLInit = mkIf createLocalMySQL {
          after = [ "mysql.service" ];
          before = [ "keycloak.service" ];
          bindsTo = [ "mysql.service" ];
          path = [ config.services.mysql.package ];
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
            User = config.services.mysql.user;
            Group = config.services.mysql.group;
            LoadCredential = [ "db_password:${cfg.database.passwordFile}" ];
          };
          script = ''
            set -o errexit -o pipefail -o nounset -o errtrace
            shopt -s inherit_errexit

            # Read the password from the credentials directory and
            # escape any single quotes by adding additional single
            # quotes after them, following the rules laid out here:
            # https://dev.mysql.com/doc/refman/8.0/en/string-literals.html
            db_password="$(<"$CREDENTIALS_DIRECTORY/db_password")"
            db_password="''${db_password//\'/\'\'}"

            ( echo "SET sql_mode = 'NO_BACKSLASH_ESCAPES';"
              echo "CREATE USER IF NOT EXISTS 'keycloak'@'localhost' IDENTIFIED BY '$db_password';"
              echo "CREATE DATABASE IF NOT EXISTS keycloak CHARACTER SET utf8 COLLATE utf8_unicode_ci;"
              echo "GRANT ALL PRIVILEGES ON keycloak.* TO 'keycloak'@'localhost';"
            ) | mysql -N
          '';
        };

        systemd.services.keycloak =
          let
            databaseServices =
              if createLocalPostgreSQL then [
                "keycloakPostgreSQLInit.service"
                "postgresql.service"
              ]
              else if createLocalMySQL then [
                "keycloakMySQLInit.service"
                "mysql.service"
              ]
              else [ ];
            secretPaths = catAttrs "_secret" (collect isSecret cfg.settings);
            mkSecretReplacement = file: ''
              replace-secret ${hashString "sha256" file} $CREDENTIALS_DIRECTORY/${baseNameOf file} /run/keycloak/conf/keycloak.conf
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
            };
            script = ''
              set -o errexit -o pipefail -o nounset -o errtrace
              shopt -s inherit_errexit

              umask u=rwx,g=,o=

              ln -s ${themesBundle} /run/keycloak/themes
              ln -s ${keycloakBuild}/providers /run/keycloak/

              install -D -m 0600 ${confFile} /run/keycloak/conf/keycloak.conf

              ${secretReplacements}

              # Escape any backslashes in the db parameters, since
              # they're otherwise unexpectedly read as escape
              # sequences.
              sed -i '/db-/ s|\\|\\\\|g' /run/keycloak/conf/keycloak.conf

            '' + optionalString (cfg.sslCertificate != null && cfg.sslCertificateKey != null) ''
              mkdir -p /run/keycloak/ssl
              cp $CREDENTIALS_DIRECTORY/ssl_{cert,key} /run/keycloak/ssl/
            '' + ''
              export KEYCLOAK_ADMIN=admin
              export KEYCLOAK_ADMIN_PASSWORD=${escapeShellArg cfg.initialAdminPassword}
              kc.sh start --optimized
            '';
          };

        services.postgresql.enable = mkDefault createLocalPostgreSQL;
        services.mysql.enable = mkDefault createLocalMySQL;
        services.mysql.package =
          let
            dbPkg = if cfg.database.type == "mariadb" then pkgs.mariadb else pkgs.mysql80;
          in
          mkIf createLocalMySQL (mkDefault dbPkg);
      };

  # Don't edit the docbook xml directly, edit the md and generate it using md-to-db.sh
  meta.doc = ./keycloak.xml;
  meta.maintainers = [ maintainers.talyz ];
}
