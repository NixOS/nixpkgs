# Integration test for Vaultwarden with Litestream continuous replication
# This test validates the proper configuration for cross-service file access
# between Vaultwarden and Litestream, demonstrating a production-ready
# backup solution for self-hosted password managers.

import ./make-test-python.nix (
  { pkgs, lib, ... }:
  let
    dbPath = "/var/lib/vaultwarden/db.sqlite3";
    backupPath = "/var/backup/litestream";
    server = "http://localhost:8000";
    testUser = builtins.toJSON {
      email = "test@example.com";
      name = "Test User";
      masterPasswordHash = "pbkdf2$10000$GHMvWyLlHmxvbHuYJHGpEw==$p/CRYB0j8+L3luOHPlFQavBdNoGDLRYs4zmNfH2nhI8=";
      key = "2.ftF0K4LPgR1vFPl7gLJI6A==|W2c0OIvS4BsFLIrqiGlbVxbnJLWJPMQaLF2kb+E3u1M=";
    };
  in
  {
    name = "vaultwarden-litestream";
    meta = {
      maintainers = with lib.maintainers; [ ];
    };

    nodes.machine =
      { config, pkgs, ... }:
      {
        services = {
          vaultwarden = {
            enable = true;
            config = {
              DOMAIN = server;
              SIGNUPS_ALLOWED = true; # Required for test user creation
              DATABASE_URL = dbPath;
            };
          };

          litestream = {
            enable = true;
            settings = {
              dbs = [
                {
                  path = dbPath;
                  replicas = [
                    {
                      type = "file";
                      path = backupPath;
                      snapshot-interval = "1s"; # Frequent snapshots for testing
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
              # Pre-create the database to ensure WAL mode
              ExecStartPre = "${pkgs.sqlite}/bin/sqlite3 ${dbPath} 'PRAGMA journal_mode=WAL;'"; # idempotent
            };

            litestream = {
              after = [ "vaultwarden.service" ];
              requires = [ "vaultwarden.service" ];
              serviceConfig = {
                # Ensure litestream has access to the database
                ExecStartPre = "+/bin/sh -c 'chmod 660 ${dbPath}; chmod 770 /var/lib/vaultwarden'";
              };
            };
          };

          tmpfiles.rules = [
            "d /var/backup 0755 root root -"
            "d ${backupPath} 0755 litestream litestream -"
          ];
        };

        environment.systemPackages = with pkgs; [
          curl
          sqlite
        ];

        networking.firewall.allowedTCPPorts = [ 8000 ];
      };

    testScript = ''
      machine.start()
      machine.wait_for_unit("vaultwarden.service")
      machine.wait_for_open_port(8000)
      machine.wait_for_unit("litestream.service")

      with subtest("Verify litestream is creating backups on changes"):
          get_last_snapshot = "litestream snapshots ${dbPath} | tail -n +2 | awk '{print $5}'"

          assert machine.succeed("stat -c '%a %U:%G' ${dbPath}").strip() == "660 vaultwarden:vaultwarden"
          initial_snapshot = machine.wait_until_succeeds(get_last_snapshot, timeout=30).strip()

          # Register test user to trigger snapshot on database change
          machine.succeed(register_cmd := r"""curl -sf ${server}/api/accounts/register --json '${testUser}'""")

          machine.wait_until_succeeds(f"[ \"$({get_last_snapshot})\" != \"{initial_snapshot}\" ]", timeout=10)

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
)
