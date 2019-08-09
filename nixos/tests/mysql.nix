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

    mariadb =
      { pkgs, ... }:

      {
        users.users.testuser = { };
        services.mysql.enable = true;
        services.mysql.initialScript = pkgs.writeText "mariadb-init.sql" ''
          ALTER USER root@localhost IDENTIFIED WITH unix_socket;
          DELETE FROM mysql.user WHERE password = ''' AND plugin = ''';
          DELETE FROM mysql.user WHERE user = ''';
          FLUSH PRIVILEGES;
        '';
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
    $mysql->succeed("echo 'use empty_testdb;' | mysql -u root");
    $mysql->succeed("echo 'use testdb; select * from tests;' | mysql -u root -N | grep 4");
    # ';' acts as no-op, just check whether login succeeds with the user created from the initialScript
    $mysql->succeed("echo ';' | mysql -u passworduser --password=password123");

    $mariadb->waitForUnit("mysql");
    $mariadb->succeed("echo 'use testdb; create table tests (test_id INT, PRIMARY KEY (test_id));' | sudo -u testuser mysql -u testuser");
    $mariadb->succeed("echo 'use testdb; insert into tests values (42);' | sudo -u testuser mysql -u testuser");
    $mariadb->succeed("echo 'use testdb; select test_id from tests;' | sudo -u testuser mysql -u testuser -N | grep 42");
  '';
})
