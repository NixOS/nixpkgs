# Integration test for Vaultwarden with Litestream continuous replication
# This test validates the proper configuration for cross-service file access
# between Vaultwarden and Litestream, demonstrating a production-ready
# backup solution for self-hosted password managers.

import ./make-test-python.nix ({ pkgs, lib, ... }:
  let
    # TODO: Remove when https://github.com/NixOS/nixpkgs/pull/421926 is merged
    customPkgs = import pkgs.path {
      inherit (pkgs) system;
      config = pkgs.config // {
        permittedInsecurePackages = [ "litestream-0.3.13" ];
      };
    };
  in
  {
    name = "vaultwarden-litestream";
    meta = {
      maintainers = with lib.maintainers; [ ak2k ];
    };

    nodes.machine = { config, pkgs, ... }: {
      # Vaultwarden configuration
      services.vaultwarden = {
        enable = true;
        config = {
          DOMAIN = "http://localhost:8000";
          SIGNUPS_ALLOWED = true;  # Required for test user creation
          DATABASE_URL = "/var/lib/vaultwarden/db.sqlite3";  # Explicit path for test clarity
        };
      };

      # Litestream configuration for continuous replication
      services.litestream = {
        enable = true;
        package = customPkgs.litestream;
        settings = {
          dbs = [{
            path = "/var/lib/vaultwarden/db.sqlite3";
            replicas = [{
              type = "file";
              path = "/var/backup/litestream";
              sync-interval = "1s";     # Fast sync for testing
              snapshot-interval = "10s";  # Frequent snapshots for testing
              retention = "1h";
            }];
          }];
        };
      };

      # Configure proper file access permissions
      # This is the key configuration that enables Litestream to read Vaultwarden's database
      users.users.litestream.extraGroups = [ "vaultwarden" ];
      
      # Adjust Vaultwarden's default restrictive permissions to allow group access
      systemd.services.vaultwarden.serviceConfig = {
        # Allow group read access to state directory (default: 0700)
        StateDirectoryMode = lib.mkForce "0750";
        # Allow group read access to created files (default: 0077)
        UMask = lib.mkForce "0027";
      };

      # Create backup directory
      systemd.tmpfiles.rules = [
        "d /var/backup 0755 root root -"
        "d /var/backup/litestream 0755 litestream litestream -"
      ];

      # Required packages for testing
      environment.systemPackages = with pkgs; [
        curl
        jq
        sqlite
        bitwarden-cli
      ];

      networking.firewall.allowedTCPPorts = [ 8000 ];
    };

    testScript = ''
      import json
      import time

      machine.start()
      
      # Wait for services to start
      machine.wait_for_unit("vaultwarden.service")
      machine.wait_for_unit("litestream.service")
      machine.wait_for_open_port(8000)
      
      # Give services time to initialize
      time.sleep(5)
      
      # Verify Vaultwarden is responding
      response = machine.succeed("curl -s http://localhost:8000/api/config")
      config = json.loads(response)
      assert config["version"] is not None, "Vaultwarden should be running"
      print(f"Vaultwarden version: {config['version']}")
      
      # Verify database exists and has proper permissions
      machine.succeed("test -f /var/lib/vaultwarden/db.sqlite3")
      perms = machine.succeed("stat -c '%a %U:%G' /var/lib/vaultwarden/db.sqlite3").strip()
      print(f"Database permissions: {perms}")
      
      # Check that Litestream can access the database (no permission errors)
      machine.succeed("sudo -u litestream test -r /var/lib/vaultwarden/db.sqlite3")
      
      # Verify Litestream is creating replicas
      machine.wait_until_succeeds(
          "find /var/backup/litestream -name '*.lz4' | grep -q .",
          timeout=30
      )
      
      # Create a test user and some data
      register_response = machine.succeed("""
        curl -s -X POST http://localhost:8000/api/accounts/register \
          -H "Content-Type: application/json" \
          -d '{
            "email": "test@example.com",
            "name": "Test User",
            "masterPasswordHash": "pbkdf2\$10000\$GHMvWyLlHmxvbHuYJHGpEw==\$p/CRYB0j8+L3luOHPlFQavBdNoGDLRYs4zmNfH2nhI8=",
            "masterPasswordHint": "hint",
            "key": "2.ftF0K4LPgR1vFPl7gLJI6A==|W2c0OIvS4BsFLIrqiGlbVxbnJLWJPMQaLF2kb+E3u1M="
          }'
      """)
      
      # Wait for replication to catch up
      time.sleep(15)
      
      # Simulate disaster recovery scenario
      print("\n=== Testing Disaster Recovery ===")
      
      # Stop services
      machine.succeed("systemctl stop vaultwarden.service")
      machine.succeed("systemctl stop litestream.service")
      
      # Create a backup of the current database for comparison
      machine.succeed("sqlite3 /var/lib/vaultwarden/db.sqlite3 '.backup /tmp/original-backup.db'")
      original_checksum = machine.succeed("sha256sum /tmp/original-backup.db | cut -d' ' -f1").strip()
      print(f"Original database checksum: {original_checksum}")
      
      # Delete the database (simulate disaster)
      machine.succeed("rm -f /var/lib/vaultwarden/db.sqlite3*")
      
      # Restore from Litestream backup
      machine.succeed("litestream restore -o /var/lib/vaultwarden/db.sqlite3 /var/backup/litestream")
      
      # Fix ownership (restore creates files as root)
      machine.succeed("chown vaultwarden:vaultwarden /var/lib/vaultwarden/db.sqlite3")
      machine.succeed("chmod 640 /var/lib/vaultwarden/db.sqlite3")
      
      # Create a backup of the restored database for comparison
      machine.succeed("sqlite3 /var/lib/vaultwarden/db.sqlite3 '.backup /tmp/restored-backup.db'")
      restored_checksum = machine.succeed("sha256sum /tmp/restored-backup.db | cut -d' ' -f1").strip()
      print(f"Restored database checksum: {restored_checksum}")
      
      # Verify data integrity
      assert original_checksum == restored_checksum, f"Data integrity check failed: {original_checksum} != {restored_checksum}"
      print("Data integrity verified - checksums match")
      
      # Restart services
      machine.succeed("systemctl start litestream.service")
      machine.succeed("systemctl start vaultwarden.service")
      machine.wait_for_open_port(8000)
      
      # Verify the restored database contains our test user
      check_response = machine.succeed("""
        curl -s -X POST http://localhost:8000/identity/accounts/prelogin \
          -H "Content-Type: application/json" \
          -d '{"email": "test@example.com"}'
      """)
      prelogin_data = json.loads(check_response)
      assert prelogin_data["Kdf"] == 0, "Test user should exist in restored database"
      
      print("\n=== Test Results ===")
      print("Database successfully restored from Litestream backup")
      print("User data persisted through disaster recovery")
      print("Data integrity verified through checksum comparison")
      print("Vaultwarden + Litestream integration working correctly")
    '';
  })