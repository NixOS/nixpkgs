import ./make-test-python.nix ({pkgs, lib, ...}: {
  name = "neondb";
  meta = with pkgs.lib.maintainers; {
    maintainers = [lach];
  };

  nodes.machine = {pkgs, ...}: {
    services.postgresql = {
      enable = true;
      enableTCPIP = true;
      ensureDatabases = ["neondb"];
      ensureUsers = [{
        name = "neondb";
        ensureDBOwnership = true;
      }];
      authentication = ''
        hostssl neondb neondb 127.0.0.1/32 trust
      '';
      settings = {
        ssl = true;
        ssl_cert_file = "/var/lib/postgresql/server.crt";
        ssl_key_file = "/var/lib/postgresql/server.key";
      };
    };
    systemd.services.postgresql.preStart = lib.mkBefore ''
      if [ ! -f /var/lib/postgresql/server.key ]; then
        ${pkgs.openssl}/bin/openssl req -new -x509 -days 365 -nodes \
          -out /var/lib/postgresql/server.crt \
          -keyout /var/lib/postgresql/server.key \
          -subj "/CN=localhost"
        chmod 600 /var/lib/postgresql/server.key
      fi
    '';

    services.neondb = {
      storageController = {
        enable = true;
        settings = {
          listen = "127.0.0.1:1234";
          dev = true;
          database-url = "postgresql://neondb@127.0.0.1/neondb";
        };
      };
      pageservers.test.settings = {
        id = 1;
        control_plane_api = "http://127.0.0.1:1234/upcall/v1";
        remote_storage = {
          local_path = "/var/lib/neondb/pageserver/test/remote_storage";
        };
      };
      safekeepers.test.settings = {
        id = 1;
        listen-pg = "127.0.0.1:5454";
        listen-http = "127.0.0.1:7676";
      };
    };
  };

  testScript = ''
    machine.wait_for_unit("postgresql")
    machine.wait_for_unit("neondb-storage-broker")
    machine.wait_for_unit("neondb-storage-controller")
    machine.wait_for_unit("neondb-pageserver@test")
    machine.wait_for_unit("neondb-safekeeper@test")

    machine.succeed("curl -sf http://127.0.0.1:1234/status")
    machine.succeed("curl -sf http://127.0.0.1:9898/v1/status")
    machine.succeed("curl -sf http://127.0.0.1:7676/v1/status")
  '';
})
