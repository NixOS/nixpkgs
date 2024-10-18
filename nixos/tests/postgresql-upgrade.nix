{ system ? builtins.currentSystem
, config ? { }
, pkgs ? import ../.. { inherit system config; }
, package ? null
,
}:

with import ../lib/testing-python.nix { inherit system pkgs; };

let
  lib = pkgs.lib;

  insertData = pkgs.writeShellApplication {
    name = "insert-data";
    runtimeInputs = [ pkgs.gnugrep ];
    text = ''
      run_sql() {
        su -c 'psql testdb -At -v ON_ERROR_STOP=1' postgres
      }

      run_sql <<- 'QUERY'
        CREATE TABLE books (
          title   text,
          author  text,
          year    int
        );

        INSERT INTO books (title, author, year) VALUES
        ('Do Androids Dream Of Electric Sheep?', 'Philip K. Dick', 1968),
        ('Neuromancer', 'William Gibson', 1984),
        ('Cryptonomicon', 'Neal Stephenson', 1999),
        ('Accelerando', 'Charles Stross', 2005);
      QUERY
    '';
  };

  verifyData = pkgs.writeShellApplication {
    name = "verify-data";
    runtimeInputs = [ pkgs.gnugrep ];
    text = ''
      run_sql() {
        su -c 'psql testdb -At -v ON_ERROR_STOP=1' postgres
      }

      die() {
        echo "$1" >&2 && exit 1
      }

      run_sql <<- 'QUERY' | grep 't' || die 'No author found 1'
        SELECT exists(SELECT * FROM books WHERE author = 'Philip K. Dick');
      QUERY

      run_sql <<- 'QUERY' | grep 't' || die 'No title found'
        SELECT exists(SELECT * FROM books WHERE title = 'Neuromancer');
      QUERY

      run_sql <<- 'QUERY' | grep 't' || die 'No year found'
        SELECT exists(SELECT * FROM books WHERE year = 1999);
      QUERY

      run_sql <<- 'QUERY' | grep 't' || die 'No author found 2'
        SELECT exists(SELECT * FROM books WHERE author = 'Charles Stross');
      QUERY
    '';
  };

  makePostgresqUpgradeTest = { pkgFrom, pkgTo }:
    makeTest {
      name = "postgresql-upgrade-${pkgFrom.psqlSchema}-${pkgTo.psqlSchema}";
      meta.maintainers = with lib.maintainers; [ tm-drtina ];

      nodes.machine = { ... }: {
        services.postgresql = {
          enable = true;
          package = pkgFrom;
          ensureDatabases = [ "testdb" ];
        };
        specialisation = {
          upgraded.configuration = {
            services.postgresql = {
              package = lib.mkForce pkgTo;
              upgrade.enable = true;
            };
          };
          upgraded-autodetect.configuration = {
            services.postgresql = {
              package = lib.mkForce pkgTo;
              upgrade.enable = true;
              # This simulates upgrade from older stateVersion
              upgrade.enablePreviousInstallationAutodetection = true;
            };
          };
        };
      };

      testScript = { nodes, ... }:
        let
          machine = nodes.machine.system.build.toplevel;
          databaseDir = nodes.machine.services.postgresql.databaseDir;
          oldDataDir = nodes.machine.services.postgresql.dataDir;
          newDataDir = nodes.machine.specialisation.upgraded.configuration.services.postgresql.dataDir;
        in
        ''
          machine.wait_for_unit("postgresql")
          machine.succeed("${lib.getExe insertData}")

          with subtest("Upgrade while having symlink to previous dataDir"):
            machine.succeed("${machine}/specialisation/upgraded/bin/switch-to-configuration test 2>&1")
            machine.wait_for_unit("postgresql")
            machine.succeed("${lib.getExe verifyData}")

          with subtest("Reset back to old version"):
            # This will reuse the old dataDir
            machine.succeed("${machine}/bin/switch-to-configuration test 2>&1")
            machine.wait_for_unit("postgresql")

            # Now it should be safe to remove "new" dataDir
            machine.succeed("rm -r '${newDataDir}'")

          with subtest("Upgrade while *NOT* having symlink to previous dataDir"):
            machine.succeed("rm '${databaseDir}/current' '${oldDataDir}/nix-postgresql-bin'")
            machine.succeed("${machine}/specialisation/upgraded-autodetect/bin/switch-to-configuration test 2>&1")
            machine.wait_for_unit("postgresql")
            machine.succeed("${lib.getExe verifyData}")
        '';
    };

  allPackages = map (pkg: pkgs.${pkg}) (builtins.attrNames (import ../../pkgs/servers/sql/postgresql pkgs));
  olderPackages = pkg: builtins.filter (p: lib.versionOlder p.version pkg.version) allPackages;

  # Creates [{pkgOld: ..., pkgNew: ...}, ...]
  versionMatrix = pkgs: builtins.concatMap (pkgTo: map (pkgFrom: { inherit pkgTo pkgFrom; }) (olderPackages pkgTo)) pkgs;
  makeTests = targetPkgs: map makePostgresqUpgradeTest (versionMatrix targetPkgs);
  asAttrs = tests: builtins.listToAttrs (map (test: { name = test.name; value = test; }) tests);
in
if package == null then
  # all-tests.nix: Maps the generic function over all attributes of PostgreSQL packages
  asAttrs (makeTests allPackages)
else
  # Called directly from <package>.tests
  asAttrs (makeTests [ package ])
