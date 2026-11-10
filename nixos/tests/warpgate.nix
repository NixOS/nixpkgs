{ pkgs, ... }:
{
  name = "warpgate";

  nodes = {
    machine = {
      services.warpgate = {
        enable = true;
      };
    };

    machine2 = {
      environment.etc."warpgate-db-url".text =
        "database_url: postgresql://warpgate:warpgate@localhost:5432/warpgate";
      environment.etc."warpgate-db-enc".text =
        "WARPGATE_ENCRYPTION_KEY=QVJBTkRPTTMyQ0hBUkFDVEVSU0VOQ1JZUFRJT05LRVk=";
      services.warpgate = {
        enable = true;
        databaseUrlFile = "/etc/warpgate-db-url";
        databaseEncryptionKeysFile = "/etc/warpgate-db-enc";
        settings = {
          database_url = null;
        };
      };
      services.postgresql = {
        enable = true;
        initialScript = pkgs.writeText "psql-init" ''
          CREATE ROLE warpgate WITH LOGIN PASSWORD 'warpgate';
          CREATE DATABASE warpgate WITH OWNER warpgate;
        '';
      };
      systemd.services.warpgate = {
        after = [ "postgresql.target" ];
        requires = [ "postgresql.target" ];
      };
    };

    machine3 = {
      services.warpgate = {
        enable = true;
        settings = {
          http.listen = "[::]:443";
          ssh.enable = true;
          rdp.enable = true;
          vnc.enable = true;
          mysql.enable = true;
          postgres.enable = true;
          kubernetes.enable = true;
        };
      };
    };
  };

  testScript = ''
    machine.wait_for_unit("warpgate.service")
    machine.wait_for_open_port(8888)
    machine.succeed("stat /var/lib/warpgate/db/db.sqlite3")
    machine.succeed("curl -k --fail https://localhost:8888/@warpgate")
    machine.shutdown()

    machine2.wait_for_unit("warpgate.service")
    machine2.wait_for_open_port(8888)
    machine2.succeed("curl -k --fail https://localhost:8888/@warpgate")
    machine2.shutdown()

    machine3.wait_for_unit("warpgate.service")
    machine3.wait_for_open_port(443)
    machine3.wait_for_open_port(2222)
    machine3.wait_for_open_port(3389)
    machine3.wait_for_open_port(5900)
    machine3.wait_for_open_port(33306)
    machine3.wait_for_open_port(55432)
    machine3.wait_for_open_port(8443)
    machine3.succeed("curl -k --fail https://localhost/@warpgate")
    machine3.shutdown()
  '';
}
