{
  system ? builtins.currentSystem,
  config ? { },
  pkgs ? import ../../.. { inherit system config; },
  lib ? pkgs.lib,
}:

let
  inherit (import ./common.nix { inherit pkgs lib; }) mkTestName mariadbPackages;

  makeTest = import ./../make-test-python.nix;

  makeAutobackupTest =
    {
      package,
      name ? mkTestName package,
    }:
    makeTest {
      name = "${name}-automysqlbackup";
      meta.maintainers = [ lib.maintainers.aanderse ];

      nodes.machine = {
        services.mysql = {
          inherit package;
          enable = true;
          initialDatabases = [
            {
              name = "testdb";
              schema = ./testdb.sql;
            }
          ];
        };

        services.automysqlbackup.enable = true;
        automysqlbackup.settings.mysql_dump_port = "";
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
    };
in
lib.mapAttrs (_: package: makeAutobackupTest { inherit package; }) mariadbPackages
