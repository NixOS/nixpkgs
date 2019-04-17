import ./make-test.nix ({ pkgs, ...} : {
  name = "mysql";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ eelco shlevy ];
  };

  nodes = {
    mysql =
      { pkgs, ... }:

      {
        services.mysql.enable = true;
        services.mysql.initialDatabases = [ { name = "testdb"; schema = ./testdb.sql; } ];
        services.mysql.package = pkgs.mysql;
      };

    mariadb =
      { pkgs, ... }:

      {
        users.users.testuser = { };
        services.mysql.enable = true;
        services.mysql.ensureDatabases = [ "testdb" ];
        services.mysql.ensureUsers = [{
          name = "testuser";
          ensurePermissions = {
            "testdb.*" = "ALL PRIVILEGES";
          };
        }];
        services.mysql.package = pkgs.mariadb;
      };

  };

  testScript = ''
    startAll;

    $mysql->waitForUnit("mysql");
    $mysql->succeed("echo 'use testdb; select * from tests' | mysql -u root -N | grep 4");

    $mariadb->waitForUnit("mysql");
    $mariadb->succeed("echo 'use testdb; create table tests (test_id INT, PRIMARY KEY (test_id));' | sudo -u testuser mysql -u testuser");
    $mariadb->succeed("echo 'use testdb; insert into tests values (42);' | sudo -u testuser mysql -u testuser");
    $mariadb->succeed("echo 'use testdb; select test_id from tests' | sudo -u testuser mysql -u testuser -N | grep 42");
  '';
})
