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
        services.mysql.package = pkgs.mysql57;
      };

    mariadb =
      { pkgs, ... }:

      {
        services.mysql.enable = true;
        services.mysql.initialDatabases = [ { name = "testdb"; schema = ./testdb.sql; } ];
        services.mysql.package = pkgs.mariadb;
      };

  };

  testScript = ''
    startAll;

    $mysql->waitForUnit("mysql");
    $mysql->succeed("echo 'use testdb; select * from tests' | mysql -u root -N | grep 4");
    $mysql->shutdown;
    $mariadb->waitForUnit("mysql");
    $mariadb->succeed("echo 'use testdb; select * from tests' | mysql -u root -N | grep 4");
    $mariadb->shutdown;
  '';
})
