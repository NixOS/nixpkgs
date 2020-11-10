import ./make-test-python.nix ({ pkgs, lib, ... }:
{
  name = "codimd";

  meta = with lib.maintainers; {
    maintainers = [ willibutz ];
  };

  nodes = {
    codimdSqlite = { ... }: {
      services = {
        codimd = {
          enable = true;
          configuration.dbURL = "sqlite:///var/lib/codimd/codimd.db";
        };
      };
    };

    codimdPostgres = { ... }: {
      systemd.services.codimd.after = [ "postgresql.service" ];
      services = {
        codimd = {
          enable = true;
          configuration.dbURL = "postgres://codimd:\${DB_PASSWORD}@localhost:5432/codimddb";

          /*
           * Do not use pkgs.writeText for secrets as
           * they will end up in the world-readable Nix store.
           */
          environmentFile = pkgs.writeText "codimd-env" ''
            DB_PASSWORD=snakeoilpassword
          '';
        };
        postgresql = {
          enable = true;
          initialScript = pkgs.writeText "pg-init-script.sql" ''
            CREATE ROLE codimd LOGIN PASSWORD 'snakeoilpassword';
            CREATE DATABASE codimddb OWNER codimd;
          '';
        };
      };
    };
  };

  testScript = ''
    start_all()

    with subtest("CodiMD sqlite"):
        codimdSqlite.wait_for_unit("codimd.service")
        codimdSqlite.wait_for_open_port(3000)
        codimdSqlite.wait_until_succeeds("curl -sSf http://localhost:3000/new")

    with subtest("CodiMD postgres"):
        codimdPostgres.wait_for_unit("postgresql.service")
        codimdPostgres.wait_for_unit("codimd.service")
        codimdPostgres.wait_for_open_port(5432)
        codimdPostgres.wait_for_open_port(3000)
        codimdPostgres.wait_until_succeeds("curl -sSf http://localhost:3000/new")
  '';
})
