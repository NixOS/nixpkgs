import ./make-test.nix ({ pkgs, ...} : {
  name = "mysql";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ eelco chaoflow shlevy ];
  };

  nodes = {
    master =
      { pkgs, config, ... }:

      {
        services.mysql.enable = true;
        services.mysql.initialDatabases = [ { name = "testdb"; schema = ./testdb.sql; } ];
        services.mysql.package = pkgs.mysql;
      };
  };

  testScript = ''
    startAll;

    $master->waitForUnit("mysql");
    $master->sleep(10); # Hopefully this is long enough!!
    $master->succeed("echo 'use testdb; select * from tests' | mysql -u root -N | grep 4");
  '';
})
