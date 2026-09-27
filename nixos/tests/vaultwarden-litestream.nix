# Integration test: Vaultwarden with Litestream continuous replication.
# Validates cross-service file access and disaster recovery.
{ pkgs, lib, ... }:
let
  dbPath = "/var/lib/vaultwarden/db.sqlite3";
  backupPath = "/var/backup/litestream";
  socketPath = "/run/litestream/litestream.sock";
  server = "http://localhost:8000";
  testUser = builtins.toJSON {
    email = "test@example.com";
    name = "Test User";
    masterPasswordHash = "pbkdf2$100000$J0+G2hx3fwLJivASjZNn5g==$VHB/rfRjawuwyHdznIqBxZf+UxzjxpKY3exnDYwO70g=";
    key = "2.ftF0K4LPgR1vFPl7gLJI6A==|W2c0OIvS4BsFLIrqiGlbVxbnJLWJPMQaLF2kb+E3u1M=";
    kdf = 0;
    kdfIterations = 100000;
  };
in
{
  name = "vaultwarden-litestream";
  meta = {
    maintainers = with lib.maintainers; [ ak2k ];
  };

  nodes.machine =
    { pkgs, ... }:
    {
      services = {
        vaultwarden = {
          enable = true;
          config = {
            DOMAIN = server;
            SIGNUPS_ALLOWED = true;
            DATABASE_URL = dbPath;
            ROCKET_ADDRESS = "0.0.0.0";
            ROCKET_PORT = 8000;
          };
        };

        litestream = {
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
                    type = "file";
                    path = backupPath;
                  }
                ];
              }
            ];
          };
        };
      };

      users.users.litestream.extraGroups = [ "vaultwarden" ];

      systemd = {
        services = {
          vaultwarden.serviceConfig = {
            # Pre-create the database to ensure WAL mode (idempotent)
            ExecStartPre = lib.mkAfter "${pkgs.sqlite}/bin/sqlite3 ${dbPath} 'PRAGMA journal_mode=WAL;'";
          };

          litestream = {
            after = [ "vaultwarden.service" ];
            requires = [ "vaultwarden.service" ];
            serviceConfig = {
              RuntimeDirectory = "litestream";
              ExecStartPre = "+/bin/sh -c 'chmod 660 ${dbPath}; chmod 770 /var/lib/vaultwarden'";
            };
          };
        };

        tmpfiles.settings."10-vaultwarden-litestream" = {
          "/var/backup".d = {
            mode = "0755";
            user = "root";
            group = "root";
          };
          ${backupPath}.d = {
            mode = "0755";
            user = "litestream";
            group = "litestream";
          };
        };
      };

      environment.systemPackages = with pkgs; [
        curl
        sqlite
      ];

    };

  testScript = ''
    machine.start()
    machine.wait_for_unit("vaultwarden.service")
    machine.wait_for_open_port(8000)
    machine.wait_for_unit("litestream.service")

    with subtest("Verify litestream is creating backups on changes"):
        assert machine.succeed("stat -c '%a %U:%G' ${dbPath}").strip() == "660 vaultwarden:vaultwarden"

        machine.succeed(register_cmd := r"""curl -sf ${server}/identity/accounts/register --json '${testUser}'""")
        machine.succeed("litestream sync -wait -socket ${socketPath} ${dbPath}")
        machine.succeed(
            "litestream restore -o /tmp/restored.db ${dbPath} && "
            "sqlite3 /tmp/restored.db '.dump' | grep -q test@example.com"
        )

    with subtest("Simulate disaster recovery"):
        machine.systemctl("stop vaultwarden.service litestream.service")

        original_checksum = machine.succeed("sqlite3 ${dbPath} '.dump' | cksum").split()[0]

        machine.succeed("rm -f ${dbPath}*")

        machine.succeed("litestream restore ${dbPath}")
        machine.succeed("chown vaultwarden:vaultwarden ${dbPath} && chmod 660 ${dbPath}")
        restored_checksum = machine.succeed("sqlite3 ${dbPath} '.dump' | cksum").split()[0]

        assert original_checksum == restored_checksum

    with subtest("Verify service recovery"):
        machine.systemctl("start litestream.service vaultwarden.service")
        machine.wait_for_open_port(8000)

        # Vaultwarden returns HTTP 400 when trying to register an existing user
        assert machine.succeed(register_cmd.replace("-sf", "-s -o /dev/null -w '%{http_code}'")).strip() == "400"

  '';
}
