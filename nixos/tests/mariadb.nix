import ./make-test.nix ({ pkgs, ...} : {
  name = "mariadb";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ nequissimus ];
  };

  nodes = {
    master =
      { pkgs, config, ... }:

      {
        services.mysql.enable = true;
        services.mysql.initialDatabases = [ { name = "testdb"; schema = ./testdb.sql; } ];
        services.mysql.package = pkgs.mariadb;
      };
  };

  testScript = ''
    startAll;

    $master->waitForUnit("mysql");
    $master->sleep(10); # Hopefully this is long enough!!
    $master->succeed("echo 'use testdb; select * from tests' | mysql -u root -N | grep 4");
  '';
})
