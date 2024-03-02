# Test Authelia as an auth server for Traefik as a reverse proxy of a local web service
import ./make-test-python.nix ({ lib, ... }: {
  name = "authelia";
  meta.maintainers = with lib.maintainers; [ jk ];

  nodes = {
    authelia = { config, pkgs, lib, ... }: {
      services.authelia.instances.testing = {
        enable = true;
        secrets.storageEncryptionKeyFile = "/etc/authelia/storageEncryptionKeyFile";
        secrets.jwtSecretFile = "/etc/authelia/jwtSecretFile";
        settings = {
          authentication_backend.file.path = "/etc/authelia/users_database.yml";
          access_control.default_policy = "one_factor";
          session.domain = "example.com";
          storage.local.path = "/tmp/db.sqlite3";
          notifier.filesystem.filename = "/tmp/notifications.txt";
        };
      };

      # These should not be set from nix but through other means to not leak the secret!
      # This is purely for testing purposes!
      environment.etc."authelia/storageEncryptionKeyFile" = {
        mode = "0400";
        user = "authelia-testing";
        text = "you_must_generate_a_random_string_of_more_than_twenty_chars_and_configure_this";
      };
      environment.etc."authelia/jwtSecretFile" = {
        mode = "0400";
        user = "authelia-testing";
        text = "a_very_important_secret";
      };
      environment.etc."authelia/users_database.yml" = {
        mode = "0400";
        user = "authelia-testing";
        text = ''
          users:
            bob:
              disabled: false
              displayname: bob
              # password of password
              password: $argon2id$v=19$m=65536,t=3,p=4$2ohUAfh9yetl+utr4tLcCQ$AsXx0VlwjvNnCsa70u4HKZvFkC8Gwajr2pHGKcND/xs
              email: bob@jim.com
              groups:
                - admin
                - dev
        '';
      };

      services.traefik = {
        enable = true;

        dynamicConfigOptions = {
          tls.certificates =
            let
              certDir = pkgs.runCommand "selfSignedCerts" { buildInputs = [ pkgs.openssl ]; } ''
                openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -nodes -subj '/CN=example.com/CN=auth.example.com/CN=static.example.com' -days 36500
                mkdir -p $out
                cp key.pem cert.pem $out
              '';
            in
            [{
              certFile = "${certDir}/cert.pem";
              keyFile = "${certDir}/key.pem";
            }];
          http.middlewares.authelia.forwardAuth = {
            address = "http://localhost:9091/api/verify?rd=https%3A%2F%2Fauth.example.com%2F";
            trustForwardHeader = true;
            authResponseHeaders = [
              "Remote-User"
              "Remote-Groups"
              "Remote-Email"
              "Remote-Name"
            ];
          };
          http.middlewares.authelia-basic.forwardAuth = {
            address = "http://localhost:9091/api/verify?auth=basic";
            trustForwardHeader = true;
            authResponseHeaders = [
              "Remote-User"
              "Remote-Groups"
              "Remote-Email"
              "Remote-Name"
            ];
          };

          http.routers.simplehttp = {
            rule = "Host(`static.example.com`)";
            tls = true;
            entryPoints = "web";
            service = "simplehttp";
          };
          http.routers.simplehttp-basic-auth = {
            rule = "Host(`static-basic-auth.example.com`)";
            tls = true;
            entryPoints = "web";
            service = "simplehttp";
            middlewares = [ "authelia-basic@file" ];
          };

          http.services.simplehttp = {
            loadBalancer.servers = [{
              url = "http://localhost:8000";
            }];
          };

          http.routers.authelia = {
            rule = "Host(`auth.example.com`)";
            tls = true;
            entryPoints = "web";
            service = "authelia@file";
          };

          http.services.authelia = {
            loadBalancer.servers = [{
              url = "http://localhost:9091";
            }];
          };
        };

        staticConfigOptions = {
          global = {
            checkNewVersion = false;
            sendAnonymousUsage = false;
          };

          entryPoints.web.address = ":443";
        };
      };

      systemd.services.simplehttp =
        let fakeWebPageDir = pkgs.writeTextDir "index.html" "hello"; in
        {
          script = "${pkgs.python3}/bin/python -m http.server --directory ${fakeWebPageDir} 8000";
          serviceConfig.Type = "simple";
          wantedBy = [ "multi-user.target" ];
        };
    };
  };

  testScript = ''
    start_all()

    authelia.wait_for_unit("simplehttp.service")
    authelia.wait_for_unit("traefik.service")
    authelia.wait_for_unit("authelia-testing.service")
    authelia.wait_for_open_port(443)
    authelia.wait_for_unit("multi-user.target")

    with subtest("Check for authelia"):
      # expect the login page
      assert "Login - Authelia", "could not reach authelia" in \
        authelia.succeed("curl --insecure -sSf -H Host:auth.example.com https://authelia:443/")

    with subtest("Check contacting basic http server via traefik with https works"):
      assert "hello", "could not reach raw static site" in \
        authelia.succeed("curl --insecure -sSf -H Host:static.example.com https://authelia:443/")

    with subtest("Test traefik and authelia"):
      with subtest("No details fail"):
        authelia.fail("curl --insecure -sSf -H Host:static-basic-auth.example.com https://authelia:443/")
      with subtest("Incorrect details fail"):
        authelia.fail("curl --insecure -sSf -u 'bob:wordpass' -H Host:static-basic-auth.example.com https://authelia:443/")
        authelia.fail("curl --insecure -sSf -u 'alice:password' -H Host:static-basic-auth.example.com https://authelia:443/")
      with subtest("Correct details pass"):
        assert "hello", "could not reach authed static site with valid credentials" in \
          authelia.succeed("curl --insecure -sSf -u 'bob:password' -H Host:static-basic-auth.example.com https://authelia:443/")
  '';
})
