import ./make-test-python.nix (
  { pkgs, ... }:
  {
    name = "postgis";
    meta = with pkgs.lib.maintainers; {
      maintainers = [ lsix ]; # TODO: Who's the maintener now?
    };

    nodes = {
      master =
        { pkgs, ... }:

        {
          services.postgresql =
            let
              mypg = pkgs.postgresql_15;
            in
            {
              enable = true;
              package = mypg;
              extraPlugins = with mypg.pkgs; [
                apache_datasketches
              ];
            };
        };
    };

    testScript = ''
      start_all()
      master.wait_for_unit("postgresql")
      master.sleep(10)  # Hopefully this is long enough!!
      master.succeed("sudo -u postgres psql -c 'CREATE EXTENSION datasketches;'")
      master.succeed("sudo -u postgres psql -c 'SELECT hll_sketch_to_string(hll_sketch_build(1));'")
    '';
  }
)
