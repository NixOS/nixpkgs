# This tests Keycloak: it starts the service, creates a realm with an
# OIDC client and a user, and simulates the user logging in to the
# client using their Keycloak login.

let
  certs = import ./common/acme/server/snakeoil-certs.nix;
  frontendUrl = "https://${certs.domain}";

  keycloakTest = databaseType: import ./make-test-python.nix (
    { pkgs, ... }:
    let
      initialAdminPassword = "h4Iho\"JFn't2>iQIR9";
      adminPasswordFile = pkgs.writeText "admin-password" "${initialAdminPassword}";
    in
    {
      name = "keycloak";
      meta = with pkgs.lib.maintainers; {
        maintainers = [ talyz ];
      };

      nodes = {
        keycloak = { config, ... }: {
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
            };
            inherit initialAdminPassword;
            sslCertificate = "${certs.${certs.domain}.cert}";
            sslCertificateKey = "${certs.${certs.domain}.key}";
            database = {
              type = databaseType;
              username = "bogus";
              name = "also bogus";
              passwordFile = "${pkgs.writeText "dbPassword" ''wzf6\"vO"Cb\nP>p#6;c&o?eu=q'THE'''H''''E''}";
            };
            plugins = with config.services.keycloak.package.plugins; [
              keycloak-discord
              keycloak-metrics-spi
            ];
          };
          environment.systemPackages = with pkgs; [
            xmlstarlet
            html-tidy
            jq
          ];
        };
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
                user // {
                  enabled = true;
                  credentials = [{
                    type = "password";
                    temporary = false;
                    value = password;
                  }];
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
        in ''
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

          # Register the metrics SPI
          keycloak.succeed(
              """${pkgs.jre}/bin/keytool -import -alias snakeoil -file ${certs.ca.cert} -storepass aaaaaa -keystore cacert.jks -noprompt""",
              """KC_OPTS='-Djavax.net.ssl.trustStore=cacert.jks -Djavax.net.ssl.trustStorePassword=aaaaaa' kcadm.sh config credentials --server '${frontendUrl}' --realm master --user admin --password "$(<${adminPasswordFile})" """,
              """KC_OPTS='-Djavax.net.ssl.trustStore=cacert.jks -Djavax.net.ssl.trustStorePassword=aaaaaa' kcadm.sh update events/config -s 'eventsEnabled=true' -s 'adminEventsEnabled=true' -s 'eventsListeners+=metrics-listener'""",
              """curl -sSf '${frontendUrl}/realms/master/metrics' | grep '^keycloak_admin_event_UPDATE'"""
          )

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
              "tidy -asxml -q -m login_form || true",
              "xml sel -T -t -m \"_:html/_:body/_:div/_:div/_:div/_:div/_:div/_:div/_:form[@id='kc-form-login']\" -v @action login_form >form_post_url",
          )

          # Post the login form and save the response. Once again tidy up
          # the HTML, then extract the authorization code.
          keycloak.succeed(
              "curl -sSf -L -b cookie -d 'username=${user.username}' -d 'password=${password}' -d 'credentialId=' \"$(<form_post_url)\" >auth_code_html",
              "tidy -asxml -q -m auth_code_html || true",
              "xml sel -T -t -m \"_:html/_:body/_:div/_:div/_:div/_:div/_:div/_:input[@id='code']\" -v @value auth_code_html >auth_code",
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
        '';
    }
  );
in
{
  postgres = keycloakTest "postgresql";
  mariadb = keycloakTest "mariadb";
  mysql = keycloakTest "mysql";
}
