# This tests Keycloak: it starts the service, creates a realm with an
# OIDC client and a user, and simulates the user logging in to the
# client using their Keycloak login.

let
  certs = import ./common/acme/server/snakeoil-certs.nix;
  frontendUrl = "https://${certs.domain}";

  keycloakTest =
    {
      databaseType,
      tcp ? false,
    }:
    import ./make-test-python.nix (
      { pkgs, ... }:
      let
        inherit (pkgs) lib;
        initialAdminPassword = "h4Iho\"JFn't2>iQIR9";
        adminPasswordFile = pkgs.writeText "admin-password" "${initialAdminPassword}";
        isMySQL = databaseType != "postgresql";
        dbName = "also_bogus";
        dbUser = "bogus";
        dbPassword = ''wzf6\"vO"Cb\nP>p#6;c&o?eu=q'THE'''H''''E'';
      in
      {
        name = "keycloak";
        meta = with pkgs.lib.maintainers; {
          maintainers = [ talyz ];
        };

        nodes = {
          keycloak =
            { config, ... }:
            lib.mkMerge [
              {
                virtualisation.memorySize = 2047;

                security.pki.certificateFiles = [
                  certs.ca.cert
                ];

                networking.extraHosts = ''
                  127.0.0.1 ${certs.domain}
                '';

                services.keycloak = {
                  enable = true;
                  settings = {
                    hostname = certs.domain;
                    metrics-enabled = true;
                  };
                  inherit initialAdminPassword;
                  sslCertificate = "${certs.${certs.domain}.cert}";
                  sslCertificateKey = "${certs.${certs.domain}.key}";
                  database = {
                    type = databaseType;
                  }
                  // lib.optionalAttrs tcp {
                    createLocally = false;
                    host = "localhost";
                    name = dbName;
                    username = dbUser;
                    passwordFile = "${pkgs.writeText "dbPassword" dbPassword}";
                  };
                  plugins = with config.services.keycloak.package.plugins; [
                    keycloak-discord
                  ];
                };
                environment.systemPackages = with pkgs; [
                  htmlq
                  jq
                ];
              }
              (lib.mkIf tcp {
                services.postgresql = lib.mkIf (!isMySQL) {
                  enable = true;
                  initialScript = pkgs.writeText "keycloak-db.sql" ''
                    CREATE ROLE ${dbUser} WITH LOGIN PASSWORD ${"$kc$" + dbPassword + "$kc$"};
                    CREATE DATABASE ${dbName} OWNER ${dbUser};
                  '';
                };
                services.mysql = lib.mkIf isMySQL {
                  enable = true;
                  package = if databaseType == "mariadb" then pkgs.mariadb else pkgs.mysql84;
                  initialScript = pkgs.writeText "keycloak-db.sql" ''
                    SET sql_mode = 'NO_BACKSLASH_ESCAPES';
                    CREATE DATABASE ${dbName};
                    CREATE USER '${dbUser}'@'localhost' IDENTIFIED BY '${
                      lib.replaceStrings [ "'" ] [ "''" ] dbPassword
                    }';
                    GRANT ALL PRIVILEGES ON ${dbName}.* TO '${dbUser}'@'localhost';
                  '';
                };
                systemd.services.keycloak = {
                  after = [ (if isMySQL then "mysql.service" else "postgresql.target") ];
                  requires = [ (if isMySQL then "mysql.service" else "postgresql.target") ];
                };
              })
            ];
        };

        testScript =
          let
            client = {
              clientId = "test-client";
              name = "test-client";
              redirectUris = [ "urn:ietf:wg:oauth:2.0:oob" ];
            };

            user = {
              firstName = "Chuck";
              lastName = "Testa";
              username = "chuck.testa";
              email = "chuck.testa@example.com";
            };

            password = "password1234";

            realm = {
              enabled = true;
              realm = "test-realm";
              clients = [ client ];
              users = [
                (
                  user
                  // {
                    enabled = true;
                    credentials = [
                      {
                        type = "password";
                        temporary = false;
                        value = password;
                      }
                    ];
                  }
                )
              ];
            };

            realmDataJson = pkgs.writeText "realm-data.json" (builtins.toJSON realm);

            jqCheckUserinfo = pkgs.writeText "check-userinfo.jq" ''
              if {
                "firstName": .given_name,
                "lastName": .family_name,
                "username": .preferred_username,
                "email": .email
              } != ${builtins.toJSON user} then
                error("Wrong user info!")
              else
                empty
              end
            '';
          in
          ''
            keycloak.start()
            keycloak.wait_for_unit("keycloak.service")
            keycloak.wait_for_open_port(443)
            keycloak.wait_until_succeeds("curl -sSf ${frontendUrl}")

            ### Realm Setup ###

            # Get an admin interface access token
            keycloak.succeed("""
                curl -sSf -d 'client_id=admin-cli' \
                     -d 'username=admin' \
                     -d "password=$(<${adminPasswordFile})" \
                     -d 'grant_type=password' \
                     '${frontendUrl}/realms/master/protocol/openid-connect/token' \
                     | jq -r '"Authorization: bearer " + .access_token' >admin_auth_header
            """)

            keycloak.succeed("curl -sSf https://${certs.domain}:9000/metrics | grep '^jvm_'")

            # Publish the realm, including a test OIDC client and user
            keycloak.succeed(
                "curl -sSf -H @admin_auth_header -X POST -H 'Content-Type: application/json' -d @${realmDataJson} '${frontendUrl}/admin/realms/'"
            )

            # Generate and save the client secret. To do this we need
            # Keycloak's internal id for the client.
            keycloak.succeed(
                "curl -sSf -H @admin_auth_header '${frontendUrl}/admin/realms/${realm.realm}/clients?clientId=${client.name}' | jq -r '.[].id' >client_id",
                "curl -sSf -H @admin_auth_header -X POST '${frontendUrl}/admin/realms/${realm.realm}/clients/'$(<client_id)'/client-secret' | jq -r .value >client_secret",
            )


            ### Authentication Testing ###

            # Start the login process by sending an initial request to the
            # OIDC authentication endpoint, saving the returned page. Tidy
            # up the HTML (XmlStarlet is picky) and extract the login form
            # post url.
            keycloak.succeed(
                "curl -sSf -c cookie '${frontendUrl}/realms/${realm.realm}/protocol/openid-connect/auth?client_id=${client.name}&redirect_uri=urn%3Aietf%3Awg%3Aoauth%3A2.0%3Aoob&scope=openid+email&response_type=code&response_mode=query&nonce=qw4o89g3qqm' >login_form",
                "htmlq '#kc-form-login' --attribute action --filename login_form --output form_post_url"
            )

            # Post the login form and save the response. Once again tidy up
            # the HTML, then extract the authorization code.
            keycloak.succeed(
                "curl -sSf -L -b cookie -d 'username=${user.username}' -d 'password=${password}' -d 'credentialId=' \"$(<form_post_url)\" >auth_code_html",
                "htmlq '#code' --attribute value --filename auth_code_html --output auth_code"
            )

            # Exchange the authorization code for an access token.
            keycloak.succeed(
                "curl -sSf -d grant_type=authorization_code -d code=$(<auth_code) -d client_id=${client.name} -d client_secret=$(<client_secret) -d redirect_uri=urn%3Aietf%3Awg%3Aoauth%3A2.0%3Aoob '${frontendUrl}/realms/${realm.realm}/protocol/openid-connect/token' | jq -r '\"Authorization: bearer \" + .access_token' >auth_header"
            )

            # Use the access token on the OIDC userinfo endpoint and check
            # that the returned user info matches what we initialized the
            # realm with.
            keycloak.succeed(
                "curl -sSf -H @auth_header '${frontendUrl}/realms/${realm.realm}/protocol/openid-connect/userinfo' | jq -f ${jqCheckUserinfo}"
            )
          ''
          + lib.optionalString tcp ''

            keycloak.succeed("grep -qx 'db-url-host=localhost' /run/keycloak/conf/keycloak.conf")
          ''
          + lib.optionalString (isMySQL && !tcp) ''

            ### Socket authentication migration ###

            # Older module versions created a password-authenticated user
            keycloak.succeed(
                "systemctl stop keycloak.service",
                "mysql -N -e \"ALTER USER 'keycloak'@'localhost' IDENTIFIED BY 'legacy'\"",
                "systemctl restart keycloakMySQLInit.service",
                "systemctl start keycloak.service",
            )
            keycloak.wait_for_unit("keycloak.service")
            keycloak.wait_for_open_port(443)
            keycloak.succeed(
                "mysql -N -e \"SELECT plugin FROM mysql.user WHERE user = 'keycloak' AND host = 'localhost'\" | grep -Ex '(unix|auth)_socket'",
                "curl -sSf '${frontendUrl}/realms/${realm.realm}'",
            )
          '';
      }
    );
in
{
  postgres = keycloakTest { databaseType = "postgresql"; };
  mariadb = keycloakTest { databaseType = "mariadb"; };
  mysql = keycloakTest { databaseType = "mysql"; };
  postgres-tcp = keycloakTest {
    databaseType = "postgresql";
    tcp = true;
  };
  mariadb-tcp = keycloakTest {
    databaseType = "mariadb";
    tcp = true;
  };
  mysql-tcp = keycloakTest {
    databaseType = "mysql";
    tcp = true;
  };
}
