import ./make-test.nix ({ pkgs, lib, ... }:

{
  name = "automysqlbackup";
  meta.maintainers = [ lib.maintainers.aanderse ];

  machine =
    { pkgs, ... }:
    {
      services.mysql.enable = true;
      services.mysql.package = pkgs.mysql;
      services.mysql.initialDatabases = [ { name = "testdb"; schema = ./testdb.sql; } ];

      services.automysqlbackup.enable = true;
    };

  testScript = ''
    startAll;

    # Need to have mysql started so that it can be populated with data.
    $machine->waitForUnit("mysql.service");

    # Wait for testdb to be fully populated (5 rows).
    $machine->waitUntilSucceeds("mysql -u root -D testdb -N -B -e 'select count(id) from tests' | grep -q 5");

    # Do a backup and wait for it to start
    $machine->startJob("automysqlbackup.service");
    $machine->waitForJob("automysqlbackup.service");

    # wait for backup file and check that data appears in backup
    $machine->waitForFile("/var/backup/mysql/daily/testdb");
    $machine->succeed("${pkgs.gzip}/bin/zcat /var/backup/mysql/daily/testdb/daily_testdb_*.sql.gz | grep hello");
    '';
})
