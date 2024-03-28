import ./make-test-python.nix ({ pkgs, lib, ... }:
{
  name = "hedgedoc";

  meta = with lib.maintainers; {
    maintainers = [ willibutz ];
  };

  nodes = {
    hedgedocSqlite = { ... }: {
      services.hedgedoc.enable = true;
    };

    hedgedocPostgresWithTCPSocket = { ... }: {
      systemd.services.hedgedoc.after = [ "postgresql.service" ];
      systemd.services.hedgedoc.serviceConfig.SetCredential = "dbpassword:snakeoilpassword";
      services = {
        hedgedoc = {
          enable = true;
          settings.db = {
            dialect = "postgres";
            user = "hedgedoc";
            password = lib.stringFromSystemdCredential "dbpassword";
            host = "localhost";
            port = 5432;
            database = "hedgedocdb";
          };
        };
        postgresql = {
          enable = true;
          initialScript = pkgs.writeText "pg-init-script.sql" ''
            CREATE ROLE hedgedoc LOGIN PASSWORD 'snakeoilpassword';
            CREATE DATABASE hedgedocdb OWNER hedgedoc;
          '';
        };
      };
    };

    hedgedocPostgresWithUNIXSocket = { ... }: {
      systemd.services.hedgedoc.after = [ "postgresql.service" ];
      # In a non-test scenario, this should be emplaced by some
      # secrets handling mechanism like sops-nix or colmena secrets.
      systemd.tmpfiles.rules = [
        "L+ /run/secrets/hedgedoc-db-password - - - - ${pkgs.writeText "password" "snakeoilpassword"}"
      ];
      services = {
        hedgedoc = {
          enable = true;
          settings.db = {
            dialect = "postgres";
            user = "hedgedoc";
            password = lib.stringFromRuntimeFile "/run/secrets/hedgedoc-db-password";
            host = "/run/postgresql";
            database = "hedgedocdb";
          };
        };
        postgresql = {
          enable = true;
          initialScript = pkgs.writeText "pg-init-script.sql" ''
            CREATE ROLE hedgedoc LOGIN PASSWORD 'snakeoilpassword';
            CREATE DATABASE hedgedocdb OWNER hedgedoc;
          '';
        };
      };
    };
  };

  testScript = ''
    start_all()

    with subtest("HedgeDoc sqlite"):
        hedgedocSqlite.wait_for_unit("hedgedoc.service")
        hedgedocSqlite.wait_for_open_port(3000)
        hedgedocSqlite.wait_until_succeeds("curl -sSf http://localhost:3000/new")

    with subtest("HedgeDoc postgres with TCP socket"):
        hedgedocPostgresWithTCPSocket.wait_for_unit("postgresql.service")
        hedgedocPostgresWithTCPSocket.wait_for_unit("hedgedoc.service")
        hedgedocPostgresWithTCPSocket.wait_for_open_port(5432)
        hedgedocPostgresWithTCPSocket.wait_for_open_port(3000)
        hedgedocPostgresWithTCPSocket.wait_until_succeeds("curl -sSf http://localhost:3000/new")

    with subtest("HedgeDoc postgres with UNIX socket"):
        hedgedocPostgresWithUNIXSocket.wait_for_unit("postgresql.service")
        hedgedocPostgresWithUNIXSocket.wait_for_unit("hedgedoc.service")
        hedgedocPostgresWithUNIXSocket.wait_for_open_port(5432)
        hedgedocPostgresWithUNIXSocket.wait_for_open_port(3000)
        hedgedocPostgresWithUNIXSocket.wait_until_succeeds("curl -sSf http://localhost:3000/new")
  '';
})
