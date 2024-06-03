# mostly copied from ./timescaledb.nix which was copied from ./postgresql.nix
# as it seemed unapproriate to test additional extensions for postgresql there.

{ system ? builtins.currentSystem
, config ? { }
, pkgs ? import ../.. { inherit system config; }
}:

with import ../lib/testing-python.nix { inherit system pkgs; };
with pkgs.lib;

let
  postgresql-versions = import ../../pkgs/servers/sql/postgresql pkgs;
  # Test cases from https://docs.pgvecto.rs/use-cases/hybrid-search.html
  test-sql = pkgs.writeText "postgresql-test" ''
    CREATE EXTENSION vectors;

    CREATE TABLE items (
      id bigserial PRIMARY KEY,
      content text NOT NULL,
      embedding vectors.vector(3) NOT NULL -- 3 dimensions
    );

    INSERT INTO items (content, embedding) VALUES
      ('a fat cat sat on a mat and ate a fat rat', '[1, 2, 3]'),
      ('a fat dog sat on a mat and ate a fat rat', '[4, 5, 6]'),
      ('a thin cat sat on a mat and ate a thin rat', '[7, 8, 9]'),
      ('a thin dog sat on a mat and ate a thin rat', '[10, 11, 12]');
  '';
  make-postgresql-test = postgresql-name: postgresql-package: makeTest {
    name = postgresql-name;
    meta = with pkgs.lib.maintainers; {
      maintainers = [ diogotcorreia ];
    };

    nodes.machine = { ... }:
      {
        services.postgresql = {
          enable = true;
          package = postgresql-package;
          extraPlugins = ps: with ps; [
            pgvecto-rs
          ];
          settings.shared_preload_libraries = "vectors";
        };
      };

    testScript = ''
      def check_count(statement, lines):
          return 'test $(sudo -u postgres psql postgres -tAc "{}"|wc -l) -eq {}'.format(
              statement, lines
          )


      machine.start()
      machine.wait_for_unit("postgresql")

      with subtest("Postgresql with extension vectors is available just after unit start"):
          machine.succeed(check_count("SELECT * FROM pg_available_extensions WHERE name = 'vectors' AND default_version = '${postgresql-package.pkgs.pgvecto-rs.version}';", 1))

      machine.succeed("sudo -u postgres psql -f ${test-sql}")

      machine.succeed(check_count("SELECT content, embedding FROM items WHERE to_tsvector('english', content) @@ 'cat & rat'::tsquery;", 2))

      machine.shutdown()
    '';

  };
  applicablePostgresqlVersions = filterAttrs (_: value: versionAtLeast value.version "14") postgresql-versions;
in
mapAttrs'
  (name: package: {
    inherit name;
    value = make-postgresql-test name package;
  })
  applicablePostgresqlVersions
