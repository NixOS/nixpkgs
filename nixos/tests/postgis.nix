import ./make-test.nix ({ pkgs, ...} : {
  name = "postgis";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ lsix ];
  };

  nodes = {
    master =
      { pkgs, ... }:

      {
        services.postgresql = let mypg = pkgs.postgresql10; in {
            enable = true;
            package = mypg;
            extraPlugins = [ (pkgs.postgis.override { postgresql = mypg; }) ];
        };
      };
  };

  testScript = ''
    startAll;
    $master->waitForUnit("postgresql");
    $master->sleep(10); # Hopefully this is long enough!!
    $master->succeed("sudo -u postgres psql -c 'CREATE EXTENSION postgis;'");
  '';
})
