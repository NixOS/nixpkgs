{
  system ? builtins.currentSystem,
  config ? {},
  pkgs ? import ../../.. { inherit system config; },
  lib ? pkgs.lib
}:

let
  inherit (import ./common.nix { inherit pkgs lib; }) mkTestName mariadbPackages mysqlPackages perconaPackages;

  makeTest = import ./../make-test-python.nix;
  # Setup common users
  makeMySQLTest = {
    package,
    name ? mkTestName package,
    useSocketAuth ? true,
    hasMroonga ? true,
    hasRocksDB ? pkgs.stdenv.hostPlatform.is64bit
  }: makeTest {
    inherit name;
    meta = {
      maintainers = lib.teams.helsinki-systems.members;
    };

    nodes = {
      ${name} =
        { pkgs, ... }: {

          users = {
            groups.testusers = { };

            users.testuser = {
              isSystemUser = true;
              group = "testusers";
            };

            users.testuser2 = {
              isSystemUser = true;
              group = "testusers";
            };
          };

          services.mysql = {
            enable = true;
            initialDatabases = [
              { name = "testdb3"; schema = ./testdb.sql; }
            ];
            # note that using pkgs.writeText here is generally not a good idea,
            # as it will store the password in world-readable /nix/store ;)
            initialScript = pkgs.writeText "mysql-init.sql" (if (!useSocketAuth) then ''
              CREATE USER 'testuser3'@'localhost' IDENTIFIED BY 'secure';
              GRANT ALL PRIVILEGES ON testdb3.* TO 'testuser3'@'localhost';
            '' else ''
              ALTER USER root@localhost IDENTIFIED WITH unix_socket;
              DELETE FROM mysql.user WHERE password = ''' AND plugin = ''';
              DELETE FROM mysql.user WHERE user = ''';
              FLUSH PRIVILEGES;
            '');

            ensureDatabases = [ "testdb" "testdb2" ];
            ensureUsers = [{
              name = "testuser";
              ensurePermissions = {
                "testdb.*" = "ALL PRIVILEGES";
              };
            } {
              name = "testuser2";
              ensurePermissions = {
                "testdb2.*" = "ALL PRIVILEGES";
              };
            }];
            package = package;
            settings = {
              mysqld = {
                plugin-load-add = lib.optional hasMroonga "ha_mroonga.so"
                  ++ lib.optional hasRocksDB "ha_rocksdb.so";
              };
            };
          };
        };
    };

    testScript = ''
      start_all()

      machine = ${name}
      machine.wait_for_unit("mysql")
      machine.succeed(
          "echo 'use testdb; create table tests (test_id INT, PRIMARY KEY (test_id));' | sudo -u testuser mysql -u testuser"
      )
      machine.succeed(
          "echo 'use testdb; insert into tests values (42);' | sudo -u testuser mysql -u testuser"
      )
      # Ensure testuser2 is not able to insert into testdb as mysql testuser2
      machine.fail(
          "echo 'use testdb; insert into tests values (23);' | sudo -u testuser2 mysql -u testuser2"
      )
      # Ensure testuser2 is not able to authenticate as mysql testuser
      machine.fail(
          "echo 'use testdb; insert into tests values (23);' | sudo -u testuser2 mysql -u testuser"
      )
      machine.succeed(
          "echo 'use testdb; select test_id from tests;' | sudo -u testuser mysql -u testuser -N | grep 42"
      )

      ${lib.optionalString hasMroonga ''
        # Check if Mroonga plugin works
        machine.succeed(
            "echo 'use testdb; create table mroongadb (test_id INT, PRIMARY KEY (test_id)) ENGINE = Mroonga;' | sudo -u testuser mysql -u testuser"
        )
        machine.succeed(
            "echo 'use testdb; insert into mroongadb values (25);' | sudo -u testuser mysql -u testuser"
        )
        machine.succeed(
            "echo 'use testdb; select test_id from mroongadb;' | sudo -u testuser mysql -u testuser -N | grep 25"
        )
        machine.succeed(
            "echo 'use testdb; drop table mroongadb;' | sudo -u testuser mysql -u testuser"
        )
      ''}

      ${lib.optionalString hasRocksDB ''
        # Check if RocksDB plugin works
        machine.succeed(
            "echo 'use testdb; create table rocksdb (test_id INT, PRIMARY KEY (test_id)) ENGINE = RocksDB;' | sudo -u testuser mysql -u testuser"
        )
        machine.succeed(
            "echo 'use testdb; insert into rocksdb values (28);' | sudo -u testuser mysql -u testuser"
        )
        machine.succeed(
            "echo 'use testdb; select test_id from rocksdb;' | sudo -u testuser mysql -u testuser -N | grep 28"
        )
        machine.succeed(
            "echo 'use testdb; drop table rocksdb;' | sudo -u testuser mysql -u testuser"
        )
      ''}
    '';
  };
in
  lib.mapAttrs (_: package: makeMySQLTest {
    inherit package;
    hasRocksDB = false; hasMroonga = false; useSocketAuth = false;
  }) mysqlPackages
  // (lib.mapAttrs (_: package: makeMySQLTest {
    inherit package;
  }) mariadbPackages)
  // (lib.mapAttrs (_: package: makeMySQLTest {
    inherit package;
    name = "percona_8_0";
    hasMroonga = false; useSocketAuth = false;
  }) perconaPackages)
