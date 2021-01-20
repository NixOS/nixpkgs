import ./make-test-python.nix ({ pkgs, lib, ... }:
{
  name = "hedgedoc";

  meta = with lib.maintainers; {
    maintainers = [ willibutz ];
  };

  nodes = {
    hedgedocSqlite = { ... }: {
      services = {
        hedgedoc = {
          enable = true;
          configuration.dbURL = "sqlite:///var/lib/hedgedoc/hedgedoc.db";
        };
      };
    };

    hedgedocPostgres = { ... }: {
      systemd.services.hedgedoc.after = [ "postgresql.service" ];
      services = {
        hedgedoc = {
          enable = true;
          configuration.dbURL = "postgres://hedgedoc:\${DB_PASSWORD}@localhost:5432/hedgedocdb";

          /*
           * Do not use pkgs.writeText for secrets as
           * they will end up in the world-readable Nix store.
           */
          environmentFile = pkgs.writeText "hedgedoc-env" ''
            DB_PASSWORD=snakeoilpassword
          '';
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

    with subtest("HedgeDoc postgres"):
        hedgedocPostgres.wait_for_unit("postgresql.service")
        hedgedocPostgres.wait_for_unit("hedgedoc.service")
        hedgedocPostgres.wait_for_open_port(5432)
        hedgedocPostgres.wait_for_open_port(3000)
        hedgedocPostgres.wait_until_succeeds("curl -sSf http://localhost:3000/new")
  '';
})
