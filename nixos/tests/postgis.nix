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
    master.succeed("sudo -u postgres psql -c 'select postgis_version();'")
    master.succeed("[ \"$(sudo -u postgres psql --no-psqlrc --tuples-only -c 'select postgis_version();')\" = \" ${
      pkgs.lib.versions.major pkgs.postgis.version
    }.${
      pkgs.lib.versions.minor pkgs.postgis.version
    } USE_GEOS=1 USE_PROJ=1 USE_STATS=1\" ]")
    # st_makepoint goes through c code
    master.succeed("sudo -u postgres psql --no-psqlrc --tuples-only -c 'select st_makepoint(1, 1)'")
  '';
})
