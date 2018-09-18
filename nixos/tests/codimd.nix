import ./make-test.nix ({ pkgs, lib, ... }:
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
          configuration.dbURL = "postgres://codimd:snakeoilpassword@localhost:5432/codimddb";
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
    startAll();

    subtest "CodiMD sqlite", sub {
      $codimdSqlite->waitForUnit("codimd.service");
      $codimdSqlite->waitForOpenPort(3000);
      $codimdPostgres->succeed("sleep 2"); # avoid 503 during startup
      $codimdSqlite->succeed("curl -sSf http://localhost:3000/new");
    };

    subtest "CodiMD postgres", sub {
      $codimdPostgres->waitForUnit("postgresql.service");
      $codimdPostgres->waitForUnit("codimd.service");
      $codimdPostgres->waitForOpenPort(5432);
      $codimdPostgres->waitForOpenPort(3000);
      $codimdPostgres->succeed("sleep 2"); # avoid 503 during startup
      $codimdPostgres->succeed("curl -sSf http://localhost:3000/new");
    };
  '';
})
