{ system ? builtins.currentSystem
}:

with import ../lib/testing.nix { inherit system; };
with pkgs.lib;

let

  # An attrset containing every version of PostgreSQL, shipped by Nixpkgs.  The
  # tests are run once for each version.
  postgresql-versions =
    # This is an existing attrset containing every supported version...
    let allPackages = (pkgs.callPackage ../../pkgs/servers/sql/postgresql/packages.nix { }).allPostgresqlPackages;
    # ... now swizzle the names of the attrset in order to be more user-friendly. This is a bit of a hack;
    # ideally we would use postgresql.version, but that normally results in something like 'postgresql-10.4'
    # which is an attribute name that can't be evaluated easily by 'nix-build'
    in mapAttrs' (name: value: { name = "${builtins.substring 0 12 name}"; inherit value; }) allPackages;

  # Sample SQL script to use. Note: this should work on _every_ available, supported
  # version of PostgreSQL shipped by Nixpkgs.
  test-sql = pkgs.writeText "test.sql" ''
    CREATE EXTENSION pgcrypto; -- just to check if lib loading works
    CREATE TABLE sth (
      id int
    );
    INSERT INTO sth (id) VALUES (1);
    INSERT INTO sth (id) VALUES (1);
    INSERT INTO sth (id) VALUES (1);
    INSERT INTO sth (id) VALUES (1);
    INSERT INTO sth (id) VALUES (1);
    CREATE TABLE xmltest ( doc xml );
    INSERT INTO xmltest (doc) VALUES ('<test>ok</test>'); -- check if libxml2 enabled
  '';

  # Actual test
  make-test = name: packages: makeTest {
    inherit name;

    meta = with pkgs.stdenv.lib.maintainers; {
      maintainers = [ thoughtpolice zagy ];
    };

    machine = {...}:
      {
        services.postgresql.enable = true;
        services.postgresql.packages = packages;

        services.postgresqlBackup.enable = true;
        services.postgresqlBackup.databases = [ "postgres" ];
      };

    testScript = ''
      sub check_count {
        my ($select, $nlines) = @_;
        return 'test $(sudo -u postgres psql postgres -tAc "' . $select . '"|wc -l) -eq ' . $nlines;
      }

      $machine->start;

      # postgresql should be available just after unit start
      $machine->waitForUnit("postgresql");
      $machine->succeed("cat ${test-sql} | sudo -u postgres psql");
      $machine->shutdown; # make sure that postgresql survive restart (bug #1735)
      sleep(2);

      # run some basic queries against the schema
      $machine->start;
      $machine->waitForUnit("postgresql");
      $machine->fail(check_count("SELECT * FROM sth;", 3));
      $machine->succeed(check_count("SELECT * FROM sth;", 5));
      $machine->fail(check_count("SELECT * FROM sth;", 4));
      $machine->succeed(check_count("SELECT xpath(\'/test/text()\', doc) FROM xmltest;", 1));

      # Check backup service
      $machine->succeed("systemctl start postgresqlBackup-postgres.service");
      $machine->succeed("zcat /var/backup/postgresql/postgres.sql.gz | grep '<test>ok</test>'");
      $machine->shutdown;
    '';
  };

  results = mapAttrs' (name: pkg: { inherit name; value = make-test name pkg; }) postgresql-versions;
in results
