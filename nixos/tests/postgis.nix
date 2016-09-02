import ./make-test.nix ({ pkgs, ...} : {
  name = "postgis";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ lsix ];
  };

  nodes = {
    master =
      { pkgs, config, ... }:

      {
        services.postgresql = let mypg = pkgs.postgresql95; in {
            enable = true;
            package = mypg;
            extraPlugins = [ (pkgs.postgis.override { postgresql = mypg; }).v_2_2_1 ];
            initialScript =  pkgs.writeText "postgresql-init.sql"
          ''
          CREATE ROLE postgres WITH superuser login createdb;
          '';
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
