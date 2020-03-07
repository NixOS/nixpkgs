# Test whether mysqlBackup option works
import ./make-test-python.nix ({ pkgs, ... } : {
  name = "mysql-backup";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ rvl ];
  };

  nodes = {
    master = { pkgs, ... }: {
      services.mysql = {
        enable = true;
        initialDatabases = [ { name = "testdb"; schema = ./testdb.sql; } ];
        package = pkgs.mysql;
      };

      services.mysqlBackup = {
        enable = true;
        databases = [ "doesnotexist" "testdb" ];
      };
    };
  };

  testScript = ''
    start_all()

    # Delete backup file that may be left over from a previous test run.
    # This is not needed on Hydra but useful for repeated local test runs.
    master.execute("rm -f /var/backup/mysql/testdb.gz")

    # Need to have mysql started so that it can be populated with data.
    master.wait_for_unit("mysql.service")

    # Wait for testdb to be fully populated (5 rows).
    master.wait_until_succeeds(
        "mysql -u root -D testdb -N -B -e 'select count(id) from tests' | grep -q 5"
    )

    # Do a backup and wait for it to start
    master.start_job("mysql-backup.service")
    master.wait_for_unit("mysql-backup.service")

    # wait for backup to fail, because of database 'doesnotexist'
    master.wait_until_fails("systemctl is-active -q mysql-backup.service")

    # wait for backup file and check that data appears in backup
    master.wait_for_file("/var/backup/mysql/testdb.gz")
    master.succeed(
        "${pkgs.gzip}/bin/zcat /var/backup/mysql/testdb.gz | grep hello"
    )

    # Check that a failed backup is logged
    master.succeed(
        "journalctl -u mysql-backup.service | grep 'fail.*doesnotexist' > /dev/null"
    )
  '';
})
