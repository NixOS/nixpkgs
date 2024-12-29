{
  pkgs,
  makeTest,
}:

let
  inherit (pkgs) lib;

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

  makeTestFor =
    package:
    makeTest {
      name = "pgvecto-rs-${package.name}";
      meta = with lib.maintainers; {
        maintainers = [ diogotcorreia ];
      };

      nodes.machine =
        { ... }:
        {
          services.postgresql = {
            inherit package;
            enable = true;
            enableJIT = lib.hasInfix "-jit-" package.name;
            extensions =
              ps: with ps; [
                pgvecto-rs
              ];
            settings.shared_preload_libraries = "vectors";
          };
        };

      testScript =
        { nodes, ... }:
        let
          inherit (nodes.machine.services.postgresql.package.pkgs) pgvecto-rs;
        in
        ''
          def check_count(statement, lines):
              return 'test $(sudo -u postgres psql postgres -tAc "{}"|wc -l) -eq {}'.format(
                  statement, lines
              )


          machine.start()
          machine.wait_for_unit("postgresql")

          with subtest("Postgresql with extension vectors is available just after unit start"):
              machine.succeed(check_count("SELECT * FROM pg_available_extensions WHERE name = 'vectors' AND default_version = '${pgvecto-rs.version}';", 1))

          machine.succeed("sudo -u postgres psql -f ${test-sql}")

          machine.succeed(check_count("SELECT content, embedding FROM items WHERE to_tsvector('english', content) @@ 'cat & rat'::tsquery;", 2))

          machine.shutdown()
        '';
    };
in
lib.recurseIntoAttrs (
  lib.concatMapAttrs (n: p: { ${n} = makeTestFor p; }) (
    lib.filterAttrs (_: p: !p.pkgs.pgvecto-rs.meta.broken) pkgs.postgresqlVersions
  )
  // {
    passthru.override = p: makeTestFor p;
  }
)
