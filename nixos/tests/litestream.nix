{ pkgs, lib, ... }:
let
  dbPath = "/var/lib/grafana/data/grafana.db";
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
          dbs = [
            {
              path = dbPath;
              replicas = [
                {
                  url = "sftp://foo:bar@127.0.0.1:22/home/foo/grafana";
                }
              ];
            }
          ];
        };
      };
      # Allow grafana group to traverse home dir and access data dir
      systemd.tmpfiles.rules = [
        "d /var/lib/grafana 0750 grafana grafana -"
        "d /var/lib/grafana/data 2770 grafana grafana -"
      ];
      systemd.services.grafana.serviceConfig = {
        # Pre-create the database in WAL mode (idempotent)
        ExecStartPre = lib.mkAfter "+${pkgs.sqlite}/bin/sqlite3 ${dbPath} 'PRAGMA journal_mode=WAL;'";
        # Make grafana create files as group-writable (litestream needs write access)
        UMask = lib.mkForce "0007";
      };
      systemd.services.litestream = {
        after = [ "grafana.service" ];
        requires = [ "grafana.service" ];
        serviceConfig.ExecStartPre = "+/bin/sh -c 'chmod g+rw ${dbPath}*'";
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
    # Wait for litestream to sync the password change to the replica
    machine.wait_until_succeeds(
        "journalctl -u litestream -o cat | grep -q 'compaction complete'"
    )
    # https://litestream.io/guides/systemd/#simulating-a-disaster
    machine.systemctl("stop litestream.service")
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
    machine.systemctl("restart grafana.service")
    machine.wait_for_open_port(3000)
    machine.succeed(
        "curl -sSfN -u admin:newpass http://127.0.0.1:3000/api/org/users | grep admin\@localhost"
    )
  '';
}
