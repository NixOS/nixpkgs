import ./make-test-python.nix ({ pkgs, ...} : {
  name = "postgis";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ lsix ];
  };

  nodes = {
    master =
      { pkgs, ... }:

      {
        services.postgresql = let mypg = pkgs.postgresql; in {
            enable = true;
            package = mypg;
            extraPlugins = with mypg.pkgs; [
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
    master.succeed("sudo -u postgres psql -c 'CREATE EXTENSION postgis_topology;'")
  '';
})
