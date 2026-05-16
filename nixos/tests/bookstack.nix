{ pkgs, ... }:

let
  app-key = "TestTestTestTestTestTestTestTest";
in
{
  name = "bookstack";
  meta = {
    maintainers = [ pkgs.lib.maintainers.savyajha ];
    platforms = pkgs.lib.platforms.linux;
  };

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
        DB_SOCKET = "/run/mysqld/mysqld.sock";
      };
    };

    services.mysql = {
      enable = true;
      package = pkgs.mariadb;
      settings.mysqld.character-set-server = "utf8mb4";
      ensureDatabases = [
        "bookstack"
      ];
      ensureUsers = [
        {
          name = "bookstack";
          ensurePermissions = {
            "bookstack.*" = "ALL PRIVILEGES";
          };
        }
      ];
    };
  };

  testScript = ''
    bookstackMysql.wait_for_unit("phpfpm-bookstack.service")
    bookstackMysql.wait_for_unit("nginx.service")
    bookstackMysql.wait_for_unit("mysql.service")
    bookstackMysql.succeed("curl -fvvv -Ls http://localhost/ | grep 'Log In'")
  '';
}
