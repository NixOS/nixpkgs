{
  system ? builtins.currentSystem,
  config ? { },
  pkgs ? import ../.. { inherit system config; },
}:

with import ../lib/testing-python.nix { inherit system pkgs; };
let
  lib = pkgs.lib;
  mysqlBackupTest =
    {
      mysqlBackupConfig,
      withNoDbName ? false,
      withRemoteUser ? false,
    }:
    makeTest {
      name = "databacker-mysql-backup";
      meta.maintainers = with lib.maintainers; [ ramblurr ];
      nodes.machine =
        { config, pkgs, ... }:
        lib.mkMerge [
          mysqlBackupConfig
          {
            environment.systemPackages = with pkgs; [ mysql-backup ];
            services.mysql = {
              package = pkgs.mariadb;
              enable = true;
              initialScript = pkgs.writeText "mysql-init.sql" ''
                create user if not exists 'mysql-backup-remote'@'localhost' identified with mysql_native_password;
                alter user 'mysql-backup-remote'@'localhost' identified by 'hunter2';
                grant all privileges on *.* to 'mysql-backup-remote'@'localhost';
                create database test_db default character set utf8mb4;
                use test_db;
                create table t1
                  (id int, name varchar(20), d date, t time, dt datetime, ts timestamp);
                  insert into t1 (id,name,d,t,dt,ts)
                  values
                  (1, "John", "2012-11-01", "00:15:00", "2012-11-01 00:15:00", "2012-11-01 00:15:00"),
                  (2, "Jill", "2012-11-02", "00:16:00", "2012-11-02 00:16:00", "2012-11-02 00:16:00"),
                  (3, "Sam", "2012-11-03", "00:17:00", "2012-11-03 00:17:00", "2012-11-03 00:17:00"),
                  (4, "Sarah", "2012-11-04", "00:18:00", "2012-11-04 00:18:00", "2012-11-04 00:18:00");
              '';

              settings = {
                mysqld = {
                  character-set-server = "utf8mb4";
                  collation-server = "utf8mb4_unicode_ci";
                  log_warnings = 1;
                };
              };
            };
          }
        ];

      testScript =
        ''
          start_all()
          machine.wait_for_unit("mysql")
          machine.wait_for_unit("databacker-mysql-backup")
        ''
        + (
          if withRemoteUser then
            ''
              machine.fail("mysql -e 'SHOW GRANTS FOR 'mysqlbackup'@'localhost';' | grep -E 'GRANT SELECT.*LOCK.*SHOW VIEW.*TRIGGER.*mysqlbackup' ")
            ''
          else
            ''
              machine.succeed("mysql -e 'SHOW GRANTS FOR 'mysqlbackup'@'localhost';' | grep -E 'GRANT SELECT.*LOCK.*SHOW VIEW.*TRIGGER.*mysqlbackup' ")
            ''
        )
        + ''
          machine.sleep(5)
          machine.succeed("[ -d /var/backup/mysql ]")
          print(machine.succeed("find /var/backup/mysql -type f -name 'db_backup*.tgz' -exec tar -xzvf {} -C /var/backup/mysql \;"))
          print(machine.succeed("ls -al /var/backup/mysql"))
          machine.succeed("find /var/backup/mysql -type f -name 'test_db*.sql' -exec cat {} \; | grep Jill")
          print(machine.succeed("find /var/backup/mysql -type f -name 'test_db*.sql' -exec cat {} \;"))

        ''
        + (
          if withNoDbName then
            ''
              machine.fail("find /var/backup/mysql -type f -name 'test_db*.sql' -exec cat {} \; | grep 'USE `test_db`'")
            ''
          else
            ''
              machine.succeed("find /var/backup/mysql -type f -name 'test_db*.sql' -exec cat {} \; | grep 'USE `test_db`'")
            ''
        )
        + ''
          machine.fail("find /var/backup/mysql -type f -name 'test_db*.sql' -exec cat {} \; | grep DOES_NOT_EXIST")
        '';
    }
    // { };
in
{
  # Most simple configuration
  test1 = mysqlBackupTest {
    mysqlBackupConfig = {
      services.databacker-mysql-backup = {
        enable = true;
        frequency = 60;
        begin = "+0";
      };
    };
  };
  # Test that applying a config works
  test2 = mysqlBackupTest {
    withNoDbName = true;
    mysqlBackupConfig = {
      services.databacker-mysql-backup = {
        enable = true;
        frequency = 60;
        begin = "+0";
        databases = [ "test_db" ];
        config = {
          DB_DUMP_NO_DATABASE_NAME = true;
        };
      };
    };
  };
  # Test MySQL over TCP
  test3 = mysqlBackupTest {
    withRemoteUser = true;
    mysqlBackupConfig = {
      systemd.services.databacker-mysql-backup.after = [ "mysql.service" ];
      systemd.services.databacker-mysql-backup.requires = [ "mysql.service" ];
      services.databacker-mysql-backup = {
        enable = true;
        frequency = 60;
        begin = "+0";
        useLocalMySQL = false;
        mysql = {
          host = "127.0.0.1";
          user = "mysql-backup-remote";
          passwordFile = "${pkgs.writeText "mysql-backup-pass" "hunter2"}";
        };
      };
    };
  };
  # Test external config file
  test4 = mysqlBackupTest {
    mysqlBackupConfig = {
      services.databacker-mysql-backup = {
        enable = true;
        configFile = pkgs.writeText "mysql-backup-conf.yaml" ''
          ---
          type: config.databack.io
          version: 1
          logging: info
          dump:
            schedule:
              frequency: 1
              begin: +0
            targets:
              - local
          database:
            server: /run/mysqld/mysqld.sock
          targets:
            local:
              type: file
              url: file:///var/backup/mysql

        '';
      };
    };
  };
  # Test extraConfig
  test5 = mysqlBackupTest {
    withNoDbName = true;
    mysqlBackupConfig = {
      services.databacker-mysql-backup = {
        enable = true;
        frequency = 60;
        begin = "+0";
        databases = [ "test_db" ];
        extraConfigFile = pkgs.writeText "mysql-backup-extra-conf.yaml" ''
          ---
          type: config.databack.io
          version: 1
          dump:
            no-database-name: true
        '';
      };
    };
  };
}
