{ config, options, pkgs, lib, ... }:

let
  cfg = config.services.keycloak;
  opt = options.services.keycloak;
in
{
  options.services.keycloak = {

    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      example = true;
      description = ''
        Whether to enable the Keycloak identity and access management
        server.
      '';
    };

    bindAddress = lib.mkOption {
      type = lib.types.str;
      default = "\${jboss.bind.address:0.0.0.0}";
      example = "127.0.0.1";
      description = ''
        On which address Keycloak should accept new connections.

        A special syntax can be used to allow command line Java system
        properties to override the value: ''${property.name:value}
      '';
    };

    httpPort = lib.mkOption {
      type = lib.types.str;
      default = "\${jboss.http.port:80}";
      example = "8080";
      description = ''
        On which port Keycloak should listen for new HTTP connections.

        A special syntax can be used to allow command line Java system
        properties to override the value: ''${property.name:value}
      '';
    };

    httpsPort = lib.mkOption {
      type = lib.types.str;
      default = "\${jboss.https.port:443}";
      example = "8443";
      description = ''
        On which port Keycloak should listen for new HTTPS connections.

        A special syntax can be used to allow command line Java system
        properties to override the value: ''${property.name:value}
      '';
    };

    frontendUrl = lib.mkOption {
      type = lib.types.str;
      apply = x: if lib.hasSuffix "/" x then x else x + "/";
      example = "keycloak.example.com/auth";
      description = ''
        The public URL used as base for all frontend requests. Should
        normally include a trailing <literal>/auth</literal>.

        See <link xlink:href="https://www.keycloak.org/docs/latest/server_installation/#_hostname">the
        Hostname section of the Keycloak server installation
        manual</link> for more information.
      '';
    };

    forceBackendUrlToFrontendUrl = lib.mkOption {
      type = lib.types.bool;
      default = false;
      example = true;
      description = ''
        Whether Keycloak should force all requests to go through the
        frontend URL configured in <xref
        linkend="opt-services.keycloak.frontendUrl" />. By default,
        Keycloak allows backend requests to instead use its local
        hostname or IP address and may also advertise it to clients
        through its OpenID Connect Discovery endpoint.

        See <link
        xlink:href="https://www.keycloak.org/docs/latest/server_installation/#_hostname">the
        Hostname section of the Keycloak server installation
        manual</link> for more information.
      '';
    };

    sslCertificate = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = "/run/keys/ssl_cert";
      description = ''
        The path to a PEM formatted certificate to use for TLS/SSL
        connections.

        This should be a string, not a Nix path, since Nix paths are
        copied into the world-readable Nix store.
      '';
    };

    sslCertificateKey = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = "/run/keys/ssl_key";
      description = ''
        The path to a PEM formatted private key to use for TLS/SSL
        connections.

        This should be a string, not a Nix path, since Nix paths are
        copied into the world-readable Nix store.
      '';
    };

    database = {
      type = lib.mkOption {
        type = lib.types.enum [ "mysql" "postgresql" ];
        default = "postgresql";
        example = "mysql";
        description = ''
          The type of database Keycloak should connect to.
        '';
      };

      host = lib.mkOption {
        type = lib.types.str;
        default = "localhost";
        description = ''
          Hostname of the database to connect to.
        '';
      };

      port =
        let
          dbPorts = {
            postgresql = 5432;
            mysql = 3306;
          };
        in
          lib.mkOption {
            type = lib.types.port;
            default = dbPorts.${cfg.database.type};
            description = ''
              Port of the database to connect to.
            '';
          };

      useSSL = lib.mkOption {
        type = lib.types.bool;
        default = cfg.database.host != "localhost";
        defaultText = lib.literalExpression ''config.${opt.database.host} != "localhost"'';
        description = ''
          Whether the database connection should be secured by SSL /
          TLS.
        '';
      };

      caCert = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = ''
          The SSL / TLS CA certificate that verifies the identity of the
          database server.

          Required when PostgreSQL is used and SSL is turned on.

          For MySQL, if left at <literal>null</literal>, the default
          Java keystore is used, which should suffice if the server
          certificate is issued by an official CA.
        '';
      };

      createLocally = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Whether a database should be automatically created on the
          local host. Set this to false if you plan on provisioning a
          local database yourself. This has no effect if
          services.keycloak.database.host is customized.
        '';
      };

      username = lib.mkOption {
        type = lib.types.str;
        default = "keycloak";
        description = ''
          Username to use when connecting to an external or manually
          provisioned database; has no effect when a local database is
          automatically provisioned.

          To use this with a local database, set <xref
          linkend="opt-services.keycloak.database.createLocally" /> to
          <literal>false</literal> and create the database and user
          manually. The database should be called
          <literal>keycloak</literal>.
        '';
      };

      passwordFile = lib.mkOption {
        type = lib.types.path;
        example = "/run/keys/db_password";
        description = ''
          File containing the database password.

          This should be a string, not a Nix path, since Nix paths are
          copied into the world-readable Nix store.
        '';
      };
    };

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.keycloak;
      defaultText = lib.literalExpression "pkgs.keycloak";
      description = ''
        Keycloak package to use.
      '';
    };

    initialAdminPassword = lib.mkOption {
      type = lib.types.str;
      default = "changeme";
      description = ''
        Initial password set for the <literal>admin</literal>
        user. The password is not stored safely and should be changed
        immediately in the admin panel.
      '';
    };

    extraConfig = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      example = lib.literalExpression ''
        {
          "subsystem=keycloak-server" = {
            "spi=hostname" = {
              "provider=default" = null;
              "provider=fixed" = {
                enabled = true;
                properties.hostname = "keycloak.example.com";
              };
              default-provider = "fixed";
            };
          };
        }
      '';
      description = ''
        Additional Keycloak configuration options to set in
        <literal>standalone.xml</literal>.

        Options are expressed as a Nix attribute set which matches the
        structure of the jboss-cli configuration. The configuration is
        effectively overlayed on top of the default configuration
        shipped with Keycloak. To remove existing nodes and undefine
        attributes from the default configuration, set them to
        <literal>null</literal>.

        The example configuration does the equivalent of the following
        script, which removes the hostname provider
        <literal>default</literal>, adds the deprecated hostname
        provider <literal>fixed</literal> and defines it the default:

        <programlisting>
        /subsystem=keycloak-server/spi=hostname/provider=default:remove()
        /subsystem=keycloak-server/spi=hostname/provider=fixed:add(enabled = true, properties = { hostname = "keycloak.example.com" })
        /subsystem=keycloak-server/spi=hostname:write-attribute(name=default-provider, value="fixed")
        </programlisting>

        You can discover available options by using the <link
        xlink:href="http://docs.wildfly.org/21/Admin_Guide.html#Command_Line_Interface">jboss-cli.sh</link>
        program and by referring to the <link
        xlink:href="https://www.keycloak.org/docs/latest/server_installation/index.html">Keycloak
        Server Installation and Configuration Guide</link>.
      '';
    };

  };

  config =
    let
      # We only want to create a database if we're actually going to connect to it.
      databaseActuallyCreateLocally = cfg.database.createLocally && cfg.database.host == "localhost";
      createLocalPostgreSQL = databaseActuallyCreateLocally && cfg.database.type == "postgresql";
      createLocalMySQL = databaseActuallyCreateLocally && cfg.database.type == "mysql";

      mySqlCaKeystore = pkgs.runCommand "mysql-ca-keystore" {} ''
        ${pkgs.jre}/bin/keytool -importcert -trustcacerts -alias MySQLCACert -file ${cfg.database.caCert} -keystore $out -storepass notsosecretpassword -noprompt
      '';

      keycloakConfig' = builtins.foldl' lib.recursiveUpdate {
        "interface=public".inet-address = cfg.bindAddress;
        "socket-binding-group=standard-sockets"."socket-binding=http".port = cfg.httpPort;
        "subsystem=keycloak-server"."spi=hostname" = {
          "provider=default" = {
            enabled = true;
            properties = {
              inherit (cfg) frontendUrl forceBackendUrlToFrontendUrl;
            };
          };
        };
        "subsystem=datasources"."data-source=KeycloakDS" = {
          max-pool-size = "20";
          user-name = if databaseActuallyCreateLocally then "keycloak" else cfg.database.username;
          password = "@db-password@";
        };
      } [
        (lib.optionalAttrs (cfg.database.type == "postgresql") {
          "subsystem=datasources" = {
            "jdbc-driver=postgresql" = {
              driver-module-name = "org.postgresql";
              driver-name = "postgresql";
              driver-xa-datasource-class-name = "org.postgresql.xa.PGXADataSource";
            };
            "data-source=KeycloakDS" = {
              connection-url = "jdbc:postgresql://${cfg.database.host}:${builtins.toString cfg.database.port}/keycloak";
              driver-name = "postgresql";
              "connection-properties=ssl".value = lib.boolToString cfg.database.useSSL;
            } // (lib.optionalAttrs (cfg.database.caCert != null) {
              "connection-properties=sslrootcert".value = cfg.database.caCert;
              "connection-properties=sslmode".value = "verify-ca";
            });
          };
        })
        (lib.optionalAttrs (cfg.database.type == "mysql") {
          "subsystem=datasources" = {
            "jdbc-driver=mysql" = {
              driver-module-name = "com.mysql";
              driver-name = "mysql";
              driver-class-name = "com.mysql.jdbc.Driver";
            };
            "data-source=KeycloakDS" = {
              connection-url = "jdbc:mysql://${cfg.database.host}:${builtins.toString cfg.database.port}/keycloak";
              driver-name = "mysql";
              "connection-properties=useSSL".value = lib.boolToString cfg.database.useSSL;
              "connection-properties=requireSSL".value = lib.boolToString cfg.database.useSSL;
              "connection-properties=verifyServerCertificate".value = lib.boolToString cfg.database.useSSL;
              "connection-properties=characterEncoding".value = "UTF-8";
              valid-connection-checker-class-name = "org.jboss.jca.adapters.jdbc.extensions.mysql.MySQLValidConnectionChecker";
              validate-on-match = true;
              exception-sorter-class-name = "org.jboss.jca.adapters.jdbc.extensions.mysql.MySQLExceptionSorter";
            } // (lib.optionalAttrs (cfg.database.caCert != null) {
              "connection-properties=trustCertificateKeyStoreUrl".value = "file:${mySqlCaKeystore}";
              "connection-properties=trustCertificateKeyStorePassword".value = "notsosecretpassword";
            });
          };
        })
        (lib.optionalAttrs (cfg.sslCertificate != null && cfg.sslCertificateKey != null) {
          "socket-binding-group=standard-sockets"."socket-binding=https".port = cfg.httpsPort;
          "core-service=management"."security-realm=UndertowRealm"."server-identity=ssl" = {
            keystore-path = "/run/keycloak/ssl/certificate_private_key_bundle.p12";
            keystore-password = "notsosecretpassword";
          };
          "subsystem=undertow"."server=default-server"."https-listener=https".security-realm = "UndertowRealm";
        })
        cfg.extraConfig
      ];


      /* Produces a JBoss CLI script that creates paths and sets
         attributes matching those described by `attrs`. When the
         script is run, the existing settings are effectively overlayed
         by those from `attrs`. Existing attributes can be unset by
         defining them `null`.

         JBoss paths and attributes / maps are distinguished by their
         name, where paths follow a `key=value` scheme.

         Example:
           mkJbossScript {
             "subsystem=keycloak-server"."spi=hostname" = {
               "provider=fixed" = null;
               "provider=default" = {
                 enabled = true;
                 properties = {
                   inherit frontendUrl;
                   forceBackendUrlToFrontendUrl = false;
                 };
               };
             };
           }
           => ''
             if (outcome != success) of /:read-resource()
                 /:add()
             end-if
             if (outcome != success) of /subsystem=keycloak-server:read-resource()
                 /subsystem=keycloak-server:add()
             end-if
             if (outcome != success) of /subsystem=keycloak-server/spi=hostname:read-resource()
                 /subsystem=keycloak-server/spi=hostname:add()
             end-if
             if (outcome != success) of /subsystem=keycloak-server/spi=hostname/provider=default:read-resource()
                 /subsystem=keycloak-server/spi=hostname/provider=default:add(enabled = true, properties = { forceBackendUrlToFrontendUrl = false, frontendUrl = "https://keycloak.example.com/auth" })
             end-if
             if (result != true) of /subsystem=keycloak-server/spi=hostname/provider=default:read-attribute(name="enabled")
               /subsystem=keycloak-server/spi=hostname/provider=default:write-attribute(name=enabled, value=true)
             end-if
             if (result != false) of /subsystem=keycloak-server/spi=hostname/provider=default:read-attribute(name="properties.forceBackendUrlToFrontendUrl")
               /subsystem=keycloak-server/spi=hostname/provider=default:write-attribute(name=properties.forceBackendUrlToFrontendUrl, value=false)
             end-if
             if (result != "https://keycloak.example.com/auth") of /subsystem=keycloak-server/spi=hostname/provider=default:read-attribute(name="properties.frontendUrl")
               /subsystem=keycloak-server/spi=hostname/provider=default:write-attribute(name=properties.frontendUrl, value="https://keycloak.example.com/auth")
             end-if
             if (outcome != success) of /subsystem=keycloak-server/spi=hostname/provider=fixed:read-resource()
                 /subsystem=keycloak-server/spi=hostname/provider=fixed:remove()
             end-if
           ''
      */
      mkJbossScript = attrs:
        let
          /* From a JBoss path and an attrset, produces a JBoss CLI
             snippet that writes the corresponding attributes starting
             at `path`. Recurses down into subattrsets as necessary,
             producing the variable name from its full path in the
             attrset.

             Example:
               writeAttributes "/subsystem=keycloak-server/spi=hostname/provider=default" {
                 enabled = true;
                 properties = {
                   forceBackendUrlToFrontendUrl = false;
                   frontendUrl = "https://keycloak.example.com/auth";
                 };
               }
               => ''
                 if (result != true) of /subsystem=keycloak-server/spi=hostname/provider=default:read-attribute(name="enabled")
                   /subsystem=keycloak-server/spi=hostname/provider=default:write-attribute(name=enabled, value=true)
                 end-if
                 if (result != false) of /subsystem=keycloak-server/spi=hostname/provider=default:read-attribute(name="properties.forceBackendUrlToFrontendUrl")
                   /subsystem=keycloak-server/spi=hostname/provider=default:write-attribute(name=properties.forceBackendUrlToFrontendUrl, value=false)
                 end-if
                 if (result != "https://keycloak.example.com/auth") of /subsystem=keycloak-server/spi=hostname/provider=default:read-attribute(name="properties.frontendUrl")
                   /subsystem=keycloak-server/spi=hostname/provider=default:write-attribute(name=properties.frontendUrl, value="https://keycloak.example.com/auth")
                 end-if
               ''
          */
          writeAttributes = path: set:
            let
              # JBoss expressions like `${var}` need to be prefixed
              # with `expression` to evaluate.
              prefixExpression = string:
                let
                  match = (builtins.match ''"\$\{.*}"'' string);
                in
                  if match != null then
                    "expression " + string
                  else
                    string;

              writeAttribute = attribute: value:
                let
                  type = builtins.typeOf value;
                in
                  if type == "set" then
                    let
                      names = builtins.attrNames value;
                    in
                      builtins.foldl' (text: name: text + (writeAttribute "${attribute}.${name}" value.${name})) "" names
                  else if value == null then ''
                    if (outcome == success) of ${path}:read-attribute(name="${attribute}")
                        ${path}:undefine-attribute(name="${attribute}")
                    end-if
                  ''
                  else if builtins.elem type [ "string" "path" "bool" ] then
                    let
                      value' = if type == "bool" then lib.boolToString value else ''"${value}"'';
                    in ''
                      if (result != ${prefixExpression value'}) of ${path}:read-attribute(name="${attribute}")
                        ${path}:write-attribute(name=${attribute}, value=${value'})
                      end-if
                    ''
                  else throw "Unsupported type '${type}' for path '${path}'!";
            in
              lib.concatStrings
                (lib.mapAttrsToList
                  (attribute: value: (writeAttribute attribute value))
                  set);


          /* Produces an argument list for the JBoss `add()` function,
             which adds a JBoss path and takes as its arguments the
             required subpaths and attributes.

             Example:
               makeArgList {
                 enabled = true;
                 properties = {
                   forceBackendUrlToFrontendUrl = false;
                   frontendUrl = "https://keycloak.example.com/auth";
                 };
               }
               => ''
                 enabled = true, properties = { forceBackendUrlToFrontendUrl = false, frontendUrl = "https://keycloak.example.com/auth" }
               ''
          */
          makeArgList = set:
            let
              makeArg = attribute: value:
                let
                  type = builtins.typeOf value;
                in
                  if type == "set" then
                    "${attribute} = { " + (makeArgList value) + " }"
                  else if builtins.elem type [ "string" "path" "bool" ] then
                    "${attribute} = ${if type == "bool" then lib.boolToString value else ''"${value}"''}"
                  else if value == null then
                    ""
                  else
                    throw "Unsupported type '${type}' for attribute '${attribute}'!";
            in
              lib.concatStringsSep ", " (lib.mapAttrsToList makeArg set);


          /* Recurses into the `attrs` attrset, beginning at the path
             resolved from `state.path ++ node`; if `node` is `null`,
             starts from `state.path`. Only subattrsets that are JBoss
             paths, i.e. follows the `key=value` format, are recursed
             into - the rest are considered JBoss attributes / maps.
          */
          recurse = state: node:
            let
              path = state.path ++ (lib.optional (node != null) node);
              isPath = name:
                let
                  value = lib.getAttrFromPath (path ++ [ name ]) attrs;
                in
                  if (builtins.match ".*([=]).*" name) == [ "=" ] then
                    if builtins.isAttrs value || value == null then
                      true
                    else
                      throw "Parsing path '${lib.concatStringsSep "." (path ++ [ name ])}' failed: JBoss attributes cannot contain '='!"
                  else
                    false;
              jbossPath = "/" + (lib.concatStringsSep "/" path);
              nodeValue = lib.getAttrFromPath path attrs;
              children = if !builtins.isAttrs nodeValue then {} else nodeValue;
              subPaths = builtins.filter isPath (builtins.attrNames children);
              jbossAttrs = lib.filterAttrs (name: _: !(isPath name)) children;
            in
              state // {
                text = state.text + (
                  if nodeValue != null then ''
                    if (outcome != success) of ${jbossPath}:read-resource()
                        ${jbossPath}:add(${makeArgList jbossAttrs})
                    end-if
                  '' + (writeAttributes jbossPath jbossAttrs)
                  else ''
                    if (outcome == success) of ${jbossPath}:read-resource()
                        ${jbossPath}:remove()
                    end-if
                  '') + (builtins.foldl' recurse { text = ""; inherit path; } subPaths).text;
              };
        in
          (recurse { text = ""; path = []; } null).text;


      jbossCliScript = pkgs.writeText "jboss-cli-script" (mkJbossScript keycloakConfig');

      keycloakConfig = pkgs.runCommand "keycloak-config" {
        nativeBuildInputs = [ cfg.package ];
      } ''
        export JBOSS_BASE_DIR="$(pwd -P)";
        export JBOSS_MODULEPATH="${cfg.package}/modules";
        export JBOSS_LOG_DIR="$JBOSS_BASE_DIR/log";

        cp -r ${cfg.package}/standalone/configuration .
        chmod -R u+rwX ./configuration

        mkdir -p {deployments,ssl}

        standalone.sh&

        attempt=1
        max_attempts=30
        while ! jboss-cli.sh --connect ':read-attribute(name=server-state)'; do
            if [[ "$attempt" == "$max_attempts" ]]; then
                echo "ERROR: Could not connect to Keycloak after $attempt attempts! Failing.." >&2
                exit 1
            fi
            echo "Keycloak not fully started yet, retrying.. ($attempt/$max_attempts)"
            sleep 1
            (( attempt++ ))
        done

        jboss-cli.sh --connect --file=${jbossCliScript} --echo-command

        cp configuration/standalone.xml $out
      '';
    in
      lib.mkIf cfg.enable {

        assertions = [
          {
            assertion = (cfg.database.useSSL && cfg.database.type == "postgresql") -> (cfg.database.caCert != null);
            message = "A CA certificate must be specified (in 'services.keycloak.database.caCert') when PostgreSQL is used with SSL";
          }
        ];

        environment.systemPackages = [ cfg.package ];

        systemd.services.keycloakPostgreSQLInit = lib.mkIf createLocalPostgreSQL {
          after = [ "postgresql.service" ];
          before = [ "keycloak.service" ];
          bindsTo = [ "postgresql.service" ];
          path = [ config.services.postgresql.package ];
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
            User = "postgres";
            Group = "postgres";
          };
          script = ''
            set -o errexit -o pipefail -o nounset -o errtrace
            shopt -s inherit_errexit

            create_role="$(mktemp)"
            trap 'rm -f "$create_role"' ERR EXIT

            echo "CREATE ROLE keycloak WITH LOGIN PASSWORD '$(<'${cfg.database.passwordFile}')' CREATEDB" > "$create_role"
            psql -tAc "SELECT 1 FROM pg_roles WHERE rolname='keycloak'" | grep -q 1 || psql -tA --file="$create_role"
            psql -tAc "SELECT 1 FROM pg_database WHERE datname = 'keycloak'" | grep -q 1 || psql -tAc 'CREATE DATABASE "keycloak" OWNER "keycloak"'
          '';
        };

        systemd.services.keycloakMySQLInit = lib.mkIf createLocalMySQL {
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

            db_password="$(<'${cfg.database.passwordFile}')"
            ( echo "CREATE USER IF NOT EXISTS 'keycloak'@'localhost' IDENTIFIED BY '$db_password';"
              echo "CREATE DATABASE keycloak CHARACTER SET utf8 COLLATE utf8_unicode_ci;"
              echo "GRANT ALL PRIVILEGES ON keycloak.* TO 'keycloak'@'localhost';"
            ) | mysql -N
          '';
        };

        systemd.services.keycloak =
          let
            databaseServices =
              if createLocalPostgreSQL then [
                "keycloakPostgreSQLInit.service" "postgresql.service"
              ]
              else if createLocalMySQL then [
                "keycloakMySQLInit.service" "mysql.service"
              ]
              else [ ];
          in {
            after = databaseServices;
            bindsTo = databaseServices;
            wantedBy = [ "multi-user.target" ];
            path = with pkgs; [
              cfg.package
              openssl
              replace-secret
            ];
            environment = {
              JBOSS_LOG_DIR = "/var/log/keycloak";
              JBOSS_BASE_DIR = "/run/keycloak";
              JBOSS_MODULEPATH = "${cfg.package}/modules";
            };
            serviceConfig = {
              ExecStartPre = let
                startPreFullPrivileges = ''
                  set -o errexit -o pipefail -o nounset -o errtrace
                  shopt -s inherit_errexit

                  umask u=rwx,g=,o=

                  install -T -m 0400 -o keycloak -g keycloak '${cfg.database.passwordFile}' /run/keycloak/secrets/db_password
                '' + lib.optionalString (cfg.sslCertificate != null && cfg.sslCertificateKey != null) ''
                  install -T -m 0400 -o keycloak -g keycloak '${cfg.sslCertificate}' /run/keycloak/secrets/ssl_cert
                  install -T -m 0400 -o keycloak -g keycloak '${cfg.sslCertificateKey}' /run/keycloak/secrets/ssl_key
                '';
                startPre = ''
                  set -o errexit -o pipefail -o nounset -o errtrace
                  shopt -s inherit_errexit

                  umask u=rwx,g=,o=

                  install -m 0600 ${cfg.package}/standalone/configuration/*.properties /run/keycloak/configuration
                  install -T -m 0600 ${keycloakConfig} /run/keycloak/configuration/standalone.xml

                  replace-secret '@db-password@' '/run/keycloak/secrets/db_password' /run/keycloak/configuration/standalone.xml

                  export JAVA_OPTS=-Djboss.server.config.user.dir=/run/keycloak/configuration
                  add-user-keycloak.sh -u admin -p '${cfg.initialAdminPassword}'
                '' + lib.optionalString (cfg.sslCertificate != null && cfg.sslCertificateKey != null) ''
                  pushd /run/keycloak/ssl/
                  cat /run/keycloak/secrets/ssl_cert <(echo) \
                      /run/keycloak/secrets/ssl_key <(echo) \
                      /etc/ssl/certs/ca-certificates.crt \
                      > allcerts.pem
                  openssl pkcs12 -export -in /run/keycloak/secrets/ssl_cert -inkey /run/keycloak/secrets/ssl_key -chain \
                                 -name "${cfg.frontendUrl}" -out certificate_private_key_bundle.p12 \
                                 -CAfile allcerts.pem -passout pass:notsosecretpassword
                  popd
                '';
              in [
                "+${pkgs.writeShellScript "keycloak-start-pre-full-privileges" startPreFullPrivileges}"
                "${pkgs.writeShellScript "keycloak-start-pre" startPre}"
              ];
              ExecStart = "${cfg.package}/bin/standalone.sh";
              User = "keycloak";
              Group = "keycloak";
              DynamicUser = true;
              RuntimeDirectory = map (p: "keycloak/" + p) [
                "secrets"
                "configuration"
                "deployments"
                "data"
                "ssl"
                "log"
                "tmp"
              ];
              RuntimeDirectoryMode = 0700;
              LogsDirectory = "keycloak";
              AmbientCapabilities = "CAP_NET_BIND_SERVICE";
            };
          };

        services.postgresql.enable = lib.mkDefault createLocalPostgreSQL;
        services.mysql.enable = lib.mkDefault createLocalMySQL;
        services.mysql.package = lib.mkIf createLocalMySQL pkgs.mariadb;
      };

  meta.doc = ./keycloak.xml;
  meta.maintainers = [ lib.maintainers.talyz ];
}
