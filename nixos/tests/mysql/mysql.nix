import ./../make-test-python.nix ({ pkgs, ...} : {
  name = "mysql";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ eelco shlevy ];
  };

  nodes = {
    mysql57 =
      { pkgs, ... }:

      {
        users.users.testuser = { };
        users.users.testuser2 = { };
        services.mysql.enable = true;
        # note that using pkgs.writeText here is generally not a good idea,
        # as it will store the password in world-readable /nix/store ;)
        services.mysql.initialScript = pkgs.writeText "mysql-init.sql" ''
          CREATE USER 'testuser3'@'localhost' IDENTIFIED BY 'secure';
          GRANT ALL PRIVILEGES ON testdb3.* TO 'testuser3'@'localhost';
        '';
        services.mysql.activationScripts.mysql57 = ''
          ( echo "create database if not exists testdb;"
            echo "create user if not exists 'testuser'@'localhost' identified with auth_socket;"
            echo "grant all privileges on testdb.* to 'testuser'@'localhost';"

            echo "create database if not exists testdb2;"
            echo "create user if not exists 'testuser2'@'localhost' identified with auth_socket;"
            echo "grant all privileges on testdb2.* to 'testuser2'@'localhost';"

            echo "create database if not exists testdb3;"
          ) | ${pkgs.mysql57}/bin/mysql -N

          ${pkgs.mysql57}/bin/mysql -N testdb3 < ${./testdb.sql}
        '';
        services.mysql.package = pkgs.mysql57;
      };

    mysql80 =
      { pkgs, ... }:

      {
        # prevent oom:
        # Kernel panic - not syncing: Out of memory: compulsory panic_on_oom is enabled
        virtualisation.memorySize = 1024;

        users.users.testuser = { };
        users.users.testuser2 = { };
        services.mysql.enable = true;
        # note that using pkgs.writeText here is generally not a good idea,
        # as it will store the password in world-readable /nix/store ;)
        services.mysql.initialScript = pkgs.writeText "mysql-init.sql" ''
          CREATE USER 'testuser3'@'localhost' IDENTIFIED BY 'secure';
          GRANT ALL PRIVILEGES ON testdb3.* TO 'testuser3'@'localhost';
        '';
        services.mysql.activationScripts.mysql80 = ''
          ( echo "create database if not exists testdb;"
            echo "create user if not exists 'testuser'@'localhost' identified with auth_socket;"
            echo "grant all privileges on testdb.* to 'testuser'@'localhost';"

            echo "create database if not exists testdb2;"
            echo "create user if not exists 'testuser2'@'localhost' identified with auth_socket;"
            echo "grant all privileges on testdb2.* to 'testuser2'@'localhost';"

            echo "create database if not exists testdb3;"
          ) | ${pkgs.mysql80}/bin/mysql -N

          ${pkgs.mysql80}/bin/mysql -N testdb3 < ${./testdb.sql}
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
        services.mysql.activationScripts.mariadb = ''
          ( echo "create database if not exists testdb;"
            echo "create user if not exists 'testuser'@'localhost' identified with unix_socket;"
            echo "grant all privileges on testdb.* to 'testuser'@'localhost';"

            echo "create database if not exists testdb2;"
            echo "create user if not exists 'testuser2'@'localhost' identified with unix_socket;"
            echo "grant all privileges on testdb2.* to 'testuser2'@'localhost';"
          ) | ${pkgs.mariadb}/bin/mysql -N
        '';
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
  '' + pkgs.stdenv.lib.optionalString pkgs.stdenv.isx86_64 ''
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
  '';
})
