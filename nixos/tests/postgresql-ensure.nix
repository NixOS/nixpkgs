{ system ? builtins.currentSystem
, config ? { }
, pkgs ? import ../.. { inherit system config; }
}:

with import ../lib/testing-python.nix { inherit system pkgs; };
with pkgs.lib;

let
  postgresql-versions = import ../../pkgs/servers/sql/postgresql pkgs;

  make-postgresql-test = postgresql-name: postgresql-package: makeTest {
    name = "${postgresql-name}-ensure";
    meta = with pkgs.lib.maintainers; {
      maintainers = [ Scrumplex ];
    };

    nodes.machine = { ... }:
      {
        services.postgresql = {
          enable = true;
          package = postgresql-package;

          # needed to test password authentication
          enableTCPIP = true;

          initialScript = pkgs.writeText "init.sql" ''
            CREATE DATABASE cool_template IS_TEMPLATE = true;

            \connect cool_template;

            CREATE TABLE cool_distros (name character varying(150) NOT NULL);
            INSERT INTO cool_distros VALUES ('NixOS')
          '';

          ensureUsers = [
            {
              name = "landlord";
            }

            {
              name = "verysecure";
              passwordFile = pkgs.writeText "super-secret-password" "hunter2";
              ensurePermissions = {
                "DATABASE postgres" = "ALL PRIVILEGES";
              };
            }
          ];

          # TODO: Test connection limit
          ensureDatabases = [
            "old"
            {
              name = "owneddb";
              owner = "landlord";
            }
            {
              name = "verysecure";
              owner = "verysecure";
              allowConnections = false;
            }
            {
              name = "linux";
              template = "cool_template";
            }
            {
              name = "i18n";
              template = "template0";
              encoding = "UTF8";
              lcCollate = "C.utf8";
              lcCtype = "C.utf8";
            }
          ];
        };
      };

    testScript = ''
      def check_count(statement, lines, database="postgres"):
          return 'test $(sudo -u postgres psql {} -tAc "{}"|wc -l) -eq {}'.format(
              database, statement, lines
          )

      def db_exists(db_name):
          return check_count(f"SELECT * FROM pg_database WHERE datname = '{db_name}';", 1)

      def user_exists(user_name):
          return check_count(f"SELECT * FROM pg_user WHERE usename = '{user_name}';", 1)

      machine.start()
      machine.wait_for_unit("postgresql")

      with subtest("old database exists"):
          machine.succeed(db_exists("old"))

      with subtest("landlord is owner of owneddb"):
          machine.succeed(db_exists("owneddb"))

          machine.succeed(user_exists("landlord"))

          machine.succeed(check_count("SELECT * FROM pg_database WHERE datname = 'owneddb' AND pg_catalog.pg_get_userbyid(datdba) = 'landlord';", 1))

      with subtest("user with password works"):
          machine.succeed("env PGPASSWORD=hunter2 psql -h localhost postgres verysecure -tAc 'BEGIN;COMMIT;'")

      with subtest("try database with allowConnections = false"):
          machine.fail("env PGPASSWORD=hunter2 psql -h localhost verysecure verysecure -tAc 'BEGIN;COMMIT;'")

      with subtest("check template database"):
          machine.succeed(db_exists("linux"))
          machine.succeed(check_count("SELECT * FROM cool_distros WHERE name = 'NixOS';", 1, "linux"))

      with subtest("check international database"):
          machine.succeed(db_exists("i18n"))
          machine.succeed(check_count("SELECT * FROM pg_database WHERE datname = 'i18n' AND pg_encoding_to_char(encoding) = 'UTF8';", 1))
          machine.succeed(check_count("SELECT * FROM pg_database WHERE datname = 'i18n' AND datcollate = 'C.utf8';", 1))
          machine.succeed(check_count("SELECT * FROM pg_database WHERE datname = 'i18n' AND datctype = 'C.utf8';", 1))

      machine.shutdown()
    '';

  };
in
mapAttrs' (name: package: { inherit name; value = make-postgresql-test name package; }) postgresql-versions

