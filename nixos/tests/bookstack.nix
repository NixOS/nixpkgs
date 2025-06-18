{ pkgs, ... }:

let
  db-pass = "Test2Test2";
  app-key = "TestTestTestTestTestTestTestTest";
in
{
  name = "bookstack";
  meta.maintainers = [ pkgs.lib.maintainers.savyajha ];

  nodes.bookstackMysql = {
    services.bookstack = {
      enable = true;
      hostname = "localhost";
      nginx.onlySSL = false;
      settings = {
        APP_KEY_FILE = pkgs.writeText "bookstack-appkey" app-key;
        LOG_CHANNEL = "stdout";
        SITE_OWNER = "mail@example.com";
        DB_DATABASE = "bookstack";
        DB_USERNAME = "bookstack";
        DB_PASSWORD_FILE = pkgs.writeText "mysql-pass" db-pass;
        DB_SOCKET = "/run/mysqld/mysqld.sock";
      };
    };

    services.mysql = {
      enable = true;
      package = pkgs.mariadb;
      initialScript = pkgs.writeText "bookstack-init.sql" ''
        create database bookstack DEFAULT CHARACTER SET utf8mb4;
        create user 'bookstack'@'localhost' identified by '${db-pass}';
        grant all on bookstack.* to 'bookstack'@'localhost';
      '';
      settings.mysqld.character-set-server = "utf8mb4";
    };
  };

  testScript = ''
    bookstackMysql.wait_for_unit("phpfpm-bookstack.service")
    bookstackMysql.wait_for_unit("nginx.service")
    bookstackMysql.wait_for_unit("mysql.service")
    bookstackMysql.succeed("curl -fvvv -Ls http://localhost/ | grep 'Log In'")
  '';
}
