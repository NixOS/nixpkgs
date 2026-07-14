{ pkgs, ... }:
{
  name = "hedgedoc";

  meta.maintainers = [ ];
  containers = {
    sqlite =
      { ... }:
      {
        services.hedgedoc.enable = true;
      };

    pgsqltcp =
      { ... }:
      {
        systemd.services.hedgedoc.after = [ "postgresql.target" ];
        services = {
          hedgedoc = {
            enable = true;
            settings.db = {
              dialect = "postgres";
              user = "hedgedoc";
              password = "$DB_PASSWORD";
              host = "localhost";
              port = 5432;
              database = "hedgedocdb";
            };

            /*
              Do not use pkgs.writeText for secrets as
              they will end up in the world-readable Nix store.
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

    pgsqluds =
      { ... }:
      {
        systemd.services.hedgedoc.after = [ "postgresql.target" ];
        services = {
          hedgedoc = {
            enable = true;
            settings.db = {
              dialect = "postgres";
              user = "hedgedoc";
              password = "$DB_PASSWORD";
              host = "/run/postgresql";
              database = "hedgedocdb";
            };

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
        sqlite.wait_for_unit("hedgedoc.service")
        sqlite.wait_for_open_port(3000)
        sqlite.wait_until_succeeds("curl -sSf http://localhost:3000/new")

    with subtest("HedgeDoc postgres with TCP socket"):
        pgsqltcp.wait_for_unit("postgresql.target")
        pgsqltcp.wait_for_unit("hedgedoc.service")
        pgsqltcp.wait_for_open_port(5432)
        pgsqltcp.wait_for_open_port(3000)
        pgsqltcp.wait_until_succeeds("curl -sSf http://localhost:3000/new")

    with subtest("HedgeDoc postgres with UNIX socket"):
        pgsqluds.wait_for_unit("postgresql.target")
        pgsqluds.wait_for_unit("hedgedoc.service")
        pgsqluds.wait_for_open_port(5432)
        pgsqluds.wait_for_open_port(3000)
        pgsqluds.wait_until_succeeds("curl -sSf http://localhost:3000/new")
  '';
}
