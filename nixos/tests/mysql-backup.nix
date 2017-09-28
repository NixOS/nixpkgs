# Test whether mysqlBackup option works
import ./make-test.nix ({ pkgs, ... } : {
  name = "mysql-backup";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ rvl ];
  };

  nodes = {
    master = { config, pkgs, ... }: {
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

  testScript =
    '' startAll;

       # Need to have mysql started so that it can be populated with data.
       $master->waitForUnit("mysql.service");

       # Wait for testdb to be populated.
       $master->sleep(10);

       # Do a backup and wait for it to finish.
       $master->startJob("mysql-backup.service");
       $master->waitForJob("mysql-backup.service");

       # Check that data appears in backup
       $master->succeed("${pkgs.gzip}/bin/zcat /var/backup/mysql/testdb.gz | grep hello");

       # Check that a failed backup is logged
       $master->succeed("journalctl -u mysql-backup.service | grep 'fail.*doesnotexist' > /dev/null");
    '';
})
