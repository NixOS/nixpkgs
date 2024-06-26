import ./make-test-python.nix ({ pkgs, ...} : {
  name = "postgis";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ lsix ];
  };

  nodes = {
    master =
      { pkgs, ... }:

      {
        services.postgresql = {
            enable = true;
            package = pkgs.postgresql;
            extraPlugins = ps: with ps; [
              postgis
            ];
        };
      };
  };

  testScript = ''
    start_all()
    master.wait_for_unit("postgresql")
    master.sleep(10)  # Hopefully this is long enough!!
    master.succeed("sudo -u postgres psql -c 'CREATE EXTENSION postgis;'")
    master.succeed("sudo -u postgres psql -c 'CREATE EXTENSION postgis_raster;'")
    master.succeed("sudo -u postgres psql -c 'CREATE EXTENSION postgis_topology;'")
  '';
})
