# Test powerdns-admin
{ system ? builtins.currentSystem
, config ? { }
, pkgs ? import ../.. { inherit system config; }
}:

with import ../lib/testing-python.nix { inherit system pkgs; };
with pkgs.lib;
let
  defaultConfig = ''
    BIND_ADDRESS = '127.0.0.1'
    PORT = 8000
    CAPTCHA_ENABLE = False
  '';

  makeAppTest = name: configs: makeTest {
    name = "powerdns-admin-${name}";
    meta = with pkgs.lib.maintainers; {
      maintainers = [ Flakebi zhaofengli ];
    };

    nodes.server = { pkgs, config, ... }: mkMerge ([
      {
        services.powerdns-admin = {
          enable = true;
          secretKeyFile = "/etc/powerdns-admin/secret";
          saltFile = "/etc/powerdns-admin/salt";
        };
        # It's insecure to have secrets in the world-readable nix store, but this is just a test
        environment.etc."powerdns-admin/secret".text = "secret key";
        environment.etc."powerdns-admin/salt".text = "salt";
        environment.systemPackages = [
          (pkgs.writeShellScriptBin "run-test" config.system.build.testScript)
        ];
      }
    ] ++ configs);

    testScript = ''
      server.wait_for_unit("powerdns-admin.service")
      server.wait_until_succeeds("run-test", timeout=10)
    '';
  };

  matrix = {
    backend = {
      mysql = {
        services.powerdns-admin = {
          config = ''
            ${defaultConfig}
            SQLALCHEMY_DATABASE_URI = 'mysql://powerdnsadmin@/powerdnsadmin?unix_socket=/run/mysqld/mysqld.sock'
          '';
        };
        systemd.services.powerdns-admin = {
          after = [ "mysql.service" ];
          serviceConfig.BindPaths = "/run/mysqld";
        };

        services.mysql = {
          enable = true;
          package = pkgs.mariadb;
          ensureDatabases = [ "powerdnsadmin" ];
          ensureUsers = [
            {
              name = "powerdnsadmin";
              ensurePermissions = {
                "powerdnsadmin.*" = "ALL PRIVILEGES";
              };
            }
          ];
        };
      };
      postgresql = {
        services.powerdns-admin = {
          config = ''
            ${defaultConfig}
            SQLALCHEMY_DATABASE_URI = 'postgresql://powerdnsadmin@/powerdnsadmin?host=/run/postgresql'
          '';
        };
        systemd.services.powerdns-admin = {
          after = [ "postgresql.service" ];
          serviceConfig.BindPaths = "/run/postgresql";
        };

        services.postgresql = {
          enable = true;
          ensureDatabases = [ "powerdnsadmin" ];
          ensureUsers = [
            {
              name = "powerdnsadmin";
              ensureDBOwnership = true;
            }
          ];
        };
      };
    };
    listen = {
      tcp = {
        services.powerdns-admin.extraArgs = [ "-b" "127.0.0.1:8000" ];
        system.build.testScript = ''
          set -euxo pipefail
          curl -sSf http://127.0.0.1:8000/

          # Create account to check that the database migrations ran
          csrf_token="$(curl -sSfc session http://127.0.0.1:8000/register | grep _csrf_token | cut -d\" -f6)"
          # Outputs 'Redirecting' if successful
          curl -sSfb session http://127.0.0.1:8000/register \
            -F "_csrf_token=$csrf_token" \
            -F "firstname=first" \
            -F "lastname=last" \
            -F "email=a@example.com" \
            -F "username=user" \
            -F "password=password" \
            -F "rpassword=password" | grep Redirecting

          # Login
          # Outputs 'Redirecting' if successful
          curl -sSfb session http://127.0.0.1:8000/login \
            -F "_csrf_token=$csrf_token" \
            -F "username=user" \
            -F "password=password" | grep Redirecting

          # Check that we are logged in, this redirects to /admin/setting/pdns if we are
          curl -sSfb session http://127.0.0.1:8000/dashboard/ | grep /admin/setting
        '';
      };
      unix = {
        services.powerdns-admin.extraArgs = [ "-b" "unix:/run/powerdns-admin/http.sock" ];
        system.build.testScript = ''
          curl -sSf --unix-socket /run/powerdns-admin/http.sock http://somehost/
        '';
      };
    };
  };
in
with matrix; {
  postgresql = makeAppTest "postgresql" [ backend.postgresql listen.tcp ];
  mysql = makeAppTest "mysql" [ backend.mysql listen.tcp ];
  unix-listener = makeAppTest "unix-listener" [ backend.postgresql listen.unix ];
}
