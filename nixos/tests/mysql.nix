import ./make-test-python.nix ({ pkgs, ...} : {
  name = "mysql";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ eelco shlevy ];
  };

  nodes = {
    mysql =
      { pkgs, ... }:

      {
        services.mysql.enable = true;
        services.mysql.initialDatabases = [
          { name = "testdb"; schema = ./testdb.sql; }
          { name = "empty_testdb"; }
        ];
        # note that using pkgs.writeText here is generally not a good idea,
        # as it will store the password in world-readable /nix/store ;)
        services.mysql.initialScript = pkgs.writeText "mysql-init.sql" ''
          CREATE USER 'passworduser'@'localhost' IDENTIFIED BY 'password123';
        '';
        services.mysql.package = pkgs.mysql57;
      };

    mysql80 =
      { pkgs, ... }:

      {
        # prevent oom:
        # Kernel panic - not syncing: Out of memory: compulsory panic_on_oom is enabled
        virtualisation.memorySize = 1024;

        services.mysql.enable = true;
        services.mysql.initialDatabases = [
          { name = "testdb"; schema = ./testdb.sql; }
          { name = "empty_testdb"; }
        ];
        # note that using pkgs.writeText here is generally not a good idea,
        # as it will store the password in world-readable /nix/store ;)
        services.mysql.initialScript = pkgs.writeText "mysql-init.sql" ''
          CREATE USER 'passworduser'@'localhost' IDENTIFIED BY 'password123';
        '';
        services.mysql.package = pkgs.mysql80;
      };

    mariadb =
      { pkgs, ... }:

      {
        users.users.testuser = { };
        users.users.testuser2 = { };
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
            plugin-load-add = [ "ha_tokudb.so" "ha_rocksdb.so" ];
          };
        };
        services.mysql.package = pkgs.mariadb;
      };

  };

  testScript = ''
    start_all()

    mysql.wait_for_unit("mysql")
    mysql.succeed("echo 'use empty_testdb;' | mysql -u root")
    mysql.succeed("echo 'use testdb; select * from tests;' | mysql -u root -N | grep 4")
    # ';' acts as no-op, just check whether login succeeds with the user created from the initialScript
    mysql.succeed("echo ';' | mysql -u passworduser --password=password123")

    mysql80.wait_for_unit("mysql")
    mysql80.succeed("echo 'use empty_testdb;' | mysql -u root")
    mysql80.succeed("echo 'use testdb; select * from tests;' | mysql -u root -N | grep 4")
    # ';' acts as no-op, just check whether login succeeds with the user created from the initialScript
    mysql80.succeed("echo ';' | mysql -u passworduser --password=password123")

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

    # Check if TokuDB plugin works
    mariadb.succeed(
        "echo 'use testdb; create table tokudb (test_id INT, PRIMARY KEY (test_id)) ENGINE = TokuDB;' | sudo -u testuser mysql -u testuser"
    )
    mariadb.succeed(
        "echo 'use testdb; insert into tokudb values (25);' | sudo -u testuser mysql -u testuser"
    )
    mariadb.succeed(
        "echo 'use testdb; select test_id from tokudb;' | sudo -u testuser mysql -u testuser -N | grep 25"
    )
    mariadb.succeed(
        "echo 'use testdb; drop table tokudb;' | sudo -u testuser mysql -u testuser"
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
