{
  pkgs,
  makeTest,
}:

let
  inherit (pkgs) lib;

  makeTestFor =
    package:
    makeTest {
      name = "tsja-${package.name}";
      meta = {
        maintainers = with lib.maintainers; [ chayleaf ];
      };

      nodes.master =
        { ... }:
        {
          services.postgresql = {
            inherit package;
            enable = true;
            enableJIT = lib.hasInfix "-jit-" package.name;
            extensions =
              ps: with ps; [
                tsja
              ];
          };
        };

      testScript = ''
        start_all()
        master.wait_for_unit("postgresql")
        master.succeed("sudo -u postgres psql -f /run/current-system/sw/share/postgresql/extension/libtsja_dbinit.sql")
        # make sure "日本語" is parsed as a separate lexeme
        master.succeed("""
          sudo -u postgres \\
            psql -c "SELECT * FROM ts_debug('japanese', 'PostgreSQLで日本語のテキスト検索ができます。')" \\
              | grep "{日本語}"
        """)
      '';
    };
in
lib.recurseIntoAttrs (
  lib.concatMapAttrs (n: p: { ${n} = makeTestFor p; }) (
    lib.filterAttrs (_: p: !p.pkgs.tsja.meta.broken) pkgs.postgresqlVersions
  )
  // {
    passthru.override = p: makeTestFor p;
  }
)
