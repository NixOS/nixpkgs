{ lib, ... }:

let
  db-pass = "Test2Test2";
  app-key = "TestTestTestTestTestTestTestTest";
in
{
  name = "firefly-iii";
  meta = {
    maintainers = [ lib.maintainers.savyajha ];
    platforms = lib.platforms.linux;
  };

  nodes.fireflySqlite =
    { config, ... }:
    {
      environment.etc = {
        "firefly-iii-appkey".text = app-key;
      };
      services.firefly-iii = {
        enable = true;
        enableNginx = true;
        settings = {
          APP_KEY_FILE = "/etc/firefly-iii-appkey";
          LOG_CHANNEL = "stdout";
          SITE_OWNER = "mail@example.com";
        };
      };
    };

  nodes.fireflyPostgresql =
    { config, pkgs, ... }:
    {
      environment.etc = {
        "firefly-iii-appkey".text = app-key;
        "postgres-pass".text = db-pass;
      };
      services.firefly-iii = {
        enable = true;
        enableNginx = true;
        settings = {
          APP_KEY_FILE = "/etc/firefly-iii-appkey";
          LOG_CHANNEL = "stdout";
          SITE_OWNER = "mail@example.com";
          DB_CONNECTION = "pgsql";
          DB_DATABASE = "firefly";
          DB_USERNAME = "firefly";
          DB_PASSWORD_FILE = "/etc/postgres-pass";
          PGSQL_SCHEMA = "firefly";
        };
      };

      services.postgresql = {
        enable = true;
        package = pkgs.postgresql_16;
        authentication = ''
          local all postgres peer
          local firefly firefly password
        '';
        initialScript = pkgs.writeText "firefly-init.sql" ''
          CREATE USER "firefly" WITH LOGIN PASSWORD '${db-pass}';
          CREATE DATABASE "firefly" WITH OWNER "firefly";
          \c firefly
          CREATE SCHEMA AUTHORIZATION firefly;
        '';
      };
    };

  nodes.fireflyMysql =
    { config, pkgs, ... }:
    {
      environment.etc = {
        "firefly-iii-appkey".text = app-key;
        "mysql-pass".text = db-pass;
      };
      services.firefly-iii = {
        enable = true;
        enableNginx = true;
        settings = {
          APP_KEY_FILE = "/etc/firefly-iii-appkey";
          LOG_CHANNEL = "stdout";
          SITE_OWNER = "mail@example.com";
          DB_CONNECTION = "mysql";
          DB_DATABASE = "firefly";
          DB_USERNAME = "firefly";
          DB_PASSWORD_FILE = "/etc/mysql-pass";
          DB_SOCKET = "/run/mysqld/mysqld.sock";
        };
      };

      services.mysql = {
        enable = true;
        package = pkgs.mariadb;
        initialScript = pkgs.writeText "firefly-init.sql" ''
          create database firefly DEFAULT CHARACTER SET utf8mb4;
          create user 'firefly'@'localhost' identified by '${db-pass}';
          grant all on firefly.* to 'firefly'@'localhost';
        '';
        settings.mysqld.character-set-server = "utf8mb4";
      };
    };

  testScript = ''
    fireflySqlite.wait_for_unit("phpfpm-firefly-iii.service")
    fireflySqlite.wait_for_unit("nginx.service")
    fireflySqlite.succeed("curl -fvvv -Ls http://localhost/ | grep 'Firefly III'")
    fireflySqlite.succeed("curl -fvvv -Ls http://localhost/v1/js/app.js")
    fireflySqlite.succeed("systemctl start firefly-iii-cron.service")
    fireflyPostgresql.wait_for_unit("phpfpm-firefly-iii.service")
    fireflyPostgresql.wait_for_unit("nginx.service")
    fireflyPostgresql.wait_for_unit("postgresql.target")
    fireflyPostgresql.succeed("curl -fvvv -Ls http://localhost/ | grep 'Firefly III'")
    fireflyPostgresql.succeed("systemctl start firefly-iii-cron.service")
    fireflyMysql.wait_for_unit("phpfpm-firefly-iii.service")
    fireflyMysql.wait_for_unit("nginx.service")
    fireflyMysql.wait_for_unit("mysql.service")
    fireflyMysql.succeed("curl -fvvv -Ls http://localhost/ | grep 'Firefly III'")
    fireflyMysql.succeed("systemctl start firefly-iii-cron.service")
  '';
}
