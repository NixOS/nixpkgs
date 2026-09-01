{ pkgs, lib, ... }:
let
  dbPath = "/var/lib/grafana/data/grafana.db";
  socketPath = "/run/litestream/litestream.sock";
in
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
          socket = {
            enabled = true;
            path = socketPath;
          };
          dbs = [
            {
              path = dbPath;
              replicas = [
                {
                  url = "sftp://foo:bar@127.0.0.1:22/home/foo/grafana";
                  auto-recover = true;
                }
              ];
            }
          ];
        };
      };
      # Litestream 0.5.x writes to the database (_litestream_seq table),
      # so grafana's data directory must be group-writable.
      systemd.tmpfiles.settings."10-litestream" = {
        "/var/lib/grafana".d = {
          mode = "0750";
          user = "grafana";
          group = "grafana";
        };
        "/var/lib/grafana/data".d = {
          mode = "2770";
          user = "grafana";
          group = "grafana";
        };
      };
      systemd.services.grafana.serviceConfig = {
        ExecStartPre = lib.mkAfter "+${pkgs.sqlite}/bin/sqlite3 ${dbPath} 'PRAGMA journal_mode=WAL;'";
        UMask = lib.mkForce "0007";
      };
      systemd.services.litestream = {
        after = [
          "grafana.service"
          "sshd.service"
        ];
        requires = [ "grafana.service" ];
        wants = [ "sshd.service" ];
        serviceConfig = {
          RuntimeDirectory = "litestream";
          ExecStartPre = "+/bin/sh -c 'chmod g+rw ${dbPath}*'";
        };
      };
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
            secret_key = "SW2YcwTIb9zpOOhoPsMm";
          };

          server = {
            http_addr = "127.0.0.1";
            http_port = 3000;
          };

          database = {
            type = "sqlite3";
            path = dbPath;
            wal = true;
          };
        };
      };
      users.users.foo = {
        isNormalUser = true;
        password = "bar";
      };
      users.users.litestream.extraGroups = [ "grafana" ];
      environment.systemPackages = [ pkgs.sqlite ];
    };

  testScript = ''
    start_all()
    machine.wait_for_open_port(3000)
    with subtest("Verify litestream replicates changes"):
        machine.succeed("""
            curl -sSfN -X PUT --json '{
              "name": "LitestreamTest",
              "login": "admin",
              "email": "admin@localhost"
            }' http://admin:admin@127.0.0.1:3000/api/user
        """)
        machine.succeed("litestream sync -wait -socket ${socketPath} ${dbPath}")
        machine.succeed(
            "litestream restore -o /tmp/restored.db ${dbPath} && "
            "sqlite3 /tmp/restored.db '.dump' | grep -q LitestreamTest"
        )

    with subtest("Simulate disaster recovery"):
        # https://litestream.io/guides/systemd/#simulating-a-disaster
        machine.systemctl("stop litestream.service grafana.service")
        machine.succeed(
            "rm -f ${dbPath} "
            "${dbPath}-shm "
            "${dbPath}-wal"
        )
        machine.succeed(
            "litestream restore ${dbPath} "
            "&& chown grafana:grafana ${dbPath} "
            "&& chmod 660 ${dbPath}"
        )
        machine.systemctl("restart grafana.service litestream.service")
        machine.wait_for_open_port(3000)
        machine.wait_for_unit("litestream.service")
        machine.succeed(
            "curl -sSfN -u admin:admin http://127.0.0.1:3000/api/user | grep LitestreamTest"
        )
  '';
}
