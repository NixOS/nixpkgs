import ./make-test-python.nix (
  { pkgs, ... }:
  {
    name = "metabase";
    meta = with pkgs.lib.maintainers; {
      maintainers = [ mmahut ];
    };

    nodes = {
      machine =
        { ... }:
        {
          services.metabase.enable = true;
        };
    };

    testScript = ''
      start_all()
      machine.wait_for_unit("metabase.service")
      machine.wait_for_open_port(3000)
      machine.wait_until_succeeds("curl -fL http://localhost:3000/setup | grep Metabase")
    '';
  }
)
