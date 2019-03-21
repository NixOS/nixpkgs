import ./make-test.nix ({ pkgs, ...} : {
  name = "postgis";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ lsix ];
  };

  nodes = {
    master =
      { pkgs, ... }:

      {
        services.postgresql = let mypg = pkgs.postgresql_11; in {
            enable = true;
            package = mypg;
            extraPlugins = with mypg.pkgs; [
              postgis
            ];
        };
      };
  };

  testScript = ''
    startAll;
    $master->waitForUnit("postgresql");
    $master->sleep(10); # Hopefully this is long enough!!
    $master->succeed("sudo -u postgres psql -c 'CREATE EXTENSION postgis;'");
    $master->succeed("sudo -u postgres psql -c 'CREATE EXTENSION postgis_topology;'");
  '';
})
