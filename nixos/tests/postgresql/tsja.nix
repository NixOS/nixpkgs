{ pkgs
, makeTest
}:

let
  makeTsjaTest = postgresqlPackage:
    makeTest {
      name = "tsja-${postgresqlPackage.name}";
      meta = {
        maintainers = with lib.maintainers; [ chayleaf ];
      };

      nodes = {
        master =
          { config, ... }:

          {
            services.postgresql = {
              enable = true;
              package = postgresqlPackage;
              extraPlugins = ps: with ps; [
                tsja
              ];
            };
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
pkgs.lib.recurseIntoAttrs (
  pkgs.lib.concatMapAttrs (n: p: { ${n} = makeTsjaTest p; }) pkgs.postgresqlVersions
  // {
    passthru.override = p: makeTsjaTest p;
  }
)
