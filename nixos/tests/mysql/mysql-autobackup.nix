import ./../make-test-python.nix ({ pkgs, lib, ... }:

{
  name = "automysqlbackup";
  meta.maintainers = [ lib.maintainers.aanderse ];

  machine =
    { pkgs, ... }:
    {
      services.mysql.enable = true;
      services.mysql.package = pkgs.mariadb;
      services.mysql.initialDatabases = [ { name = "testdb"; schema = ./testdb.sql; } ];

      services.automysqlbackup.enable = true;
    };

  testScript = ''
    start_all()

    # Need to have mysql started so that it can be populated with data.
    machine.wait_for_unit("mysql.service")

    with subtest("Wait for testdb to be fully populated (5 rows)."):
        machine.wait_until_succeeds(
            "mysql -u root -D testdb -N -B -e 'select count(id) from tests' | grep -q 5"
        )

    with subtest("Do a backup and wait for it to start"):
        machine.start_job("automysqlbackup.service")
        machine.wait_for_job("automysqlbackup.service")

    with subtest("wait for backup file and check that data appears in backup"):
        machine.wait_for_file("/var/backup/mysql/daily/testdb")
        machine.succeed(
            "${pkgs.gzip}/bin/zcat /var/backup/mysql/daily/testdb/daily_testdb_*.sql.gz | grep hello"
        )
    '';
})
