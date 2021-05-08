import ./../make-test-python.nix ({ pkgs, ...} : {
  name = "mysql";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ eelco shlevy ];
  };

  nodes = {
    mysql57 =
      { pkgs, ... }:

      {
        users.users.testuser = { isSystemUser = true; };
        users.users.testuser2 = { isSystemUser = true; };
        services.mysql.enable = true;
        services.mysql.initialDatabases = [
          { name = "testdb3"; schema = ./testdb.sql; }
        ];
        # note that using pkgs.writeText here is generally not a good idea,
        # as it will store the password in world-readable /nix/store ;)
        services.mysql.initialScript = pkgs.writeText "mysql-init.sql" ''
          CREATE USER 'testuser3'@'localhost' IDENTIFIED BY 'secure';
          GRANT ALL PRIVILEGES ON testdb3.* TO 'testuser3'@'localhost';
        '';
        services.mysql.ensureDatabases = [ "testdb" "testdb2" ];
        services.mysql.ensureUsers = [{
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
        services.mysql.package = pkgs.mysql57;
      };

    mysql80 =
      { pkgs, ... }:

      {
        # prevent oom:
        # Kernel panic - not syncing: Out of memory: compulsory panic_on_oom is enabled
        virtualisation.memorySize = 1024;

        users.users.testuser = { isSystemUser = true; };
        users.users.testuser2 = { isSystemUser = true; };
        services.mysql.enable = true;
        services.mysql.initialDatabases = [
          { name = "testdb3"; schema = ./testdb.sql; }
        ];
        # note that using pkgs.writeText here is generally not a good idea,
        # as it will store the password in world-readable /nix/store ;)
        services.mysql.initialScript = pkgs.writeText "mysql-init.sql" ''
          CREATE USER 'testuser3'@'localhost' IDENTIFIED BY 'secure';
          GRANT ALL PRIVILEGES ON testdb3.* TO 'testuser3'@'localhost';
        '';
        services.mysql.ensureDatabases = [ "testdb" "testdb2" ];
        services.mysql.ensureUsers = [{
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
        services.mysql.package = pkgs.mysql80;
      };

    mariadb =
      { pkgs, ... }:

      {
        users.users.testuser = { isSystemUser = true; };
        users.users.testuser2 = { isSystemUser = true; };
        services.mysql.enable = true;
        services.mysql.initialScript = pkgs.writeText "mariadb-init.sql" ''
          ALTER USER root@localhost IDENTIFIED WITH unix_socket;
          DELETE FROM mysql.user WHERE password = ''' AND plugin = ''';
          DELETE FROM mysql.user WHERE user = ''';
          FLUSH PRIVILEGES;
        '';
        services.mysql.ensureDatabases = [ "testdb" "testdb2" ];
        services.mysql.ensureUsers = [{
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
        services.mysql.settings = {
          mysqld = {
            plugin-load-add = [ "ha_rocksdb.so" ];
          };
        };
        services.mysql.package = pkgs.mariadb;
      };

  };

  testScript = ''
    start_all()

    mysql57.wait_for_unit("mysql")
    mysql57.succeed(
        "echo 'use testdb; create table tests (test_id INT, PRIMARY KEY (test_id));' | sudo -u testuser mysql -u testuser"
    )
    mysql57.succeed(
        "echo 'use testdb; insert into tests values (41);' | sudo -u testuser mysql -u testuser"
    )
    # Ensure testuser2 is not able to insert into testdb as mysql testuser2
    mysql57.fail(
        "echo 'use testdb; insert into tests values (22);' | sudo -u testuser2 mysql -u testuser2"
    )
    # Ensure testuser2 is not able to authenticate as mysql testuser
    mysql57.fail(
        "echo 'use testdb; insert into tests values (22);' | sudo -u testuser2 mysql -u testuser"
    )
    mysql57.succeed(
        "echo 'use testdb; select test_id from tests;' | sudo -u testuser mysql -u testuser -N | grep 41"
    )
    mysql57.succeed(
        "echo 'use testdb3; select * from tests;' | mysql -u testuser3 --password=secure -N | grep 4"
    )

    mysql80.wait_for_unit("mysql")
    mysql80.succeed(
        "echo 'use testdb; create table tests (test_id INT, PRIMARY KEY (test_id));' | sudo -u testuser mysql -u testuser"
    )
    mysql80.succeed(
        "echo 'use testdb; insert into tests values (41);' | sudo -u testuser mysql -u testuser"
    )
    # Ensure testuser2 is not able to insert into testdb as mysql testuser2
    mysql80.fail(
        "echo 'use testdb; insert into tests values (22);' | sudo -u testuser2 mysql -u testuser2"
    )
    # Ensure testuser2 is not able to authenticate as mysql testuser
    mysql80.fail(
        "echo 'use testdb; insert into tests values (22);' | sudo -u testuser2 mysql -u testuser"
    )
    mysql80.succeed(
        "echo 'use testdb; select test_id from tests;' | sudo -u testuser mysql -u testuser -N | grep 41"
    )
    mysql80.succeed(
        "echo 'use testdb3; select * from tests;' | mysql -u testuser3 --password=secure -N | grep 4"
    )

    mariadb.wait_for_unit("mysql")
    mariadb.succeed(
        "echo 'use testdb; create table tests (test_id INT, PRIMARY KEY (test_id));' | sudo -u testuser mysql -u testuser"
    )
    mariadb.succeed(
        "echo 'use testdb; insert into tests values (42);' | sudo -u testuser mysql -u testuser"
    )
    # Ensure testuser2 is not able to insert into testdb as mysql testuser2
    mariadb.fail(
        "echo 'use testdb; insert into tests values (23);' | sudo -u testuser2 mysql -u testuser2"
    )
    # Ensure testuser2 is not able to authenticate as mysql testuser
    mariadb.fail(
        "echo 'use testdb; insert into tests values (23);' | sudo -u testuser2 mysql -u testuser"
    )
    mariadb.succeed(
        "echo 'use testdb; select test_id from tests;' | sudo -u testuser mysql -u testuser -N | grep 42"
    )

    # Check if RocksDB plugin works
    mariadb.succeed(
        "echo 'use testdb; create table rocksdb (test_id INT, PRIMARY KEY (test_id)) ENGINE = RocksDB;' | sudo -u testuser mysql -u testuser"
    )
    mariadb.succeed(
        "echo 'use testdb; insert into rocksdb values (28);' | sudo -u testuser mysql -u testuser"
    )
    mariadb.succeed(
        "echo 'use testdb; select test_id from rocksdb;' | sudo -u testuser mysql -u testuser -N | grep 28"
    )
    mariadb.succeed(
        "echo 'use testdb; drop table rocksdb;' | sudo -u testuser mysql -u testuser"
    )
  '';
})
