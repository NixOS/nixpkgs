{ lib, ... }:

let
  db-pass = "Test2Test2";
  app-key = "TestTestTestTestTestTestTestTest";
in
{
  name = "firefly-pico";
  meta.maintainers = [ lib.maintainers.patrickdag ];

  nodes.fireflySqlite =
    { config, ... }:
    {
      environment.etc = {
        "firefly-pico-appkey".text = app-key;
      };
      services.firefly-pico = {
        enable = true;
        enableNginx = true;
        settings = {
          APP_KEY_FILE = "/etc/firefly-iii-appkey";
          LOG_CHANNEL = "stdout";
          FIREFLY_URL = "localhost";
        };
      };
    };

  nodes.fireflyPostgresql =
    { config, pkgs, ... }:
    {
      environment.etc = {
        "firefly-pico-appkey".text = app-key;
        "postgres-pass".text = db-pass;
      };
      services.firefly-pico = {
        enable = true;
        enableNginx = true;
        settings = {
          APP_KEY_FILE = "/etc/firefly-pico-appkey";
          LOG_CHANNEL = "stdout";
          SITE_OWNER = "mail@example.com";
          DB_CONNECTION = "pgsql";
          DB_DATABASE = "firefly";
          DB_USERNAME = "firefly";
          DB_PASSWORD_FILE = "/etc/postgres-pass";
          PGSQL_SCHEMA = "firefly";
          FIREFLY_URL = "localhost";
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
        "firefly-pico-appkey".text = app-key;
        "mysql-pass".text = db-pass;
      };
      services.firefly-pico = {
        enable = true;
        enableNginx = true;
        settings = {
          APP_KEY_FILE = "/etc/firefly-pico-appkey";
          LOG_CHANNEL = "stdout";
          DB_CONNECTION = "mysql";
          DB_DATABASE = "firefly";
          DB_USERNAME = "firefly";
          DB_PASSWORD_FILE = "/etc/mysql-pass";
          DB_SOCKET = "/run/mysqld/mysqld.sock";
          FIREFLY_URL = "localhost";
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
    fireflySqlite.wait_for_unit("phpfpm-firefly-pico.service")
    fireflySqlite.wait_for_unit("nginx.service")
    fireflySqlite.succeed("curl -fvvv -Ls http://localhost/ | grep 'Pico'")
    fireflySqlite.succeed("curl -fvvv -Ls http://localhost/api/test | grep 'Test!'")
    fireflyPostgresql.wait_for_unit("phpfpm-firefly-pico.service")
    fireflyPostgresql.wait_for_unit("nginx.service")
    fireflyPostgresql.wait_for_unit("postgresql.service")
    fireflyPostgresql.succeed("curl -fvvv -Ls http://localhost/ | grep 'Pico'")
    fireflyPostgresql.succeed("curl -fvvv -Ls http://localhost/api/test | grep 'Test!'")
    fireflyMysql.wait_for_unit("phpfpm-firefly-pico.service")
    fireflyMysql.wait_for_unit("nginx.service")
    fireflyMysql.wait_for_unit("mysql.service")
    fireflyMysql.succeed("curl -fvvv -Ls http://localhost/ | grep 'Pico'")
    fireflyMysql.succeed("curl -fvvv -Ls http://localhost/api/test | grep 'Test!'")
  '';
}
