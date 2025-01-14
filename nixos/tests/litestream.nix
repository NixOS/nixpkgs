import ./make-test-python.nix (
  { pkgs, ... }:
  {
    name = "litestream";
    meta = with pkgs.lib.maintainers; {
      maintainers = [ jwygoda ];
    };

    nodes.machine =
      { pkgs, ... }:
      {
        services.litestream = {
          enable = true;
          settings = {
            dbs = [
              {
                path = "/var/lib/grafana/data/grafana.db";
                replicas = [
                  {
                    url = "sftp://foo:bar@127.0.0.1:22/home/foo/grafana";
                  }
                ];
              }
            ];
          };
        };
        systemd.services.grafana.serviceConfig.ExecStartPost =
          "+"
          + pkgs.writeShellScript "grant-grafana-permissions" ''
            timeout=10

            while [ ! -f /var/lib/grafana/data/grafana.db ];
            do
              if [ "$timeout" == 0 ]; then
                echo "ERROR: Timeout while waiting for /var/lib/grafana/data/grafana.db."
                exit 1
              fi

              sleep 1

              ((timeout--))
            done

            find /var/lib/grafana -type d -exec chmod -v 775 {} \;
            find /var/lib/grafana -type f -exec chmod -v 660 {} \;
          '';
        services.openssh = {
          enable = true;
          allowSFTP = true;
          listenAddresses = [
            {
              addr = "127.0.0.1";
              port = 22;
            }
          ];
        };
        services.grafana = {
          enable = true;
          settings = {
            security = {
              admin_user = "admin";
              admin_password = "admin";
            };

            server = {
              http_addr = "localhost";
              http_port = 3000;
            };

            database = {
              type = "sqlite3";
              path = "/var/lib/grafana/data/grafana.db";
              wal = true;
            };
          };
        };
        users.users.foo = {
          isNormalUser = true;
          password = "bar";
        };
        users.users.litestream.extraGroups = [ "grafana" ];
      };

    testScript = ''
      start_all()
      machine.wait_until_succeeds("test -d /home/foo/grafana")
      machine.wait_for_open_port(3000)
      machine.succeed("""
          curl -sSfN -X PUT -H "Content-Type: application/json" -d '{
            "oldPassword": "admin",
            "newPassword": "newpass",
            "confirmNew": "newpass"
          }' http://admin:admin@127.0.0.1:3000/api/user/password
      """)
      # https://litestream.io/guides/systemd/#simulating-a-disaster
      machine.systemctl("stop litestream.service")
      machine.succeed(
          "rm -f /var/lib/grafana/data/grafana.db "
          "/var/lib/grafana/data/grafana.db-shm "
          "/var/lib/grafana/data/grafana.db-wal"
      )
      machine.succeed(
          "litestream restore /var/lib/grafana/data/grafana.db "
          "&& chown grafana:grafana /var/lib/grafana/data/grafana.db "
          "&& chmod 660 /var/lib/grafana/data/grafana.db"
      )
      machine.systemctl("restart grafana.service")
      machine.wait_for_open_port(3000)
      machine.succeed(
          "curl -sSfN -u admin:newpass http://127.0.0.1:3000/api/org/users | grep admin\@localhost"
      )
    '';
  }
)
