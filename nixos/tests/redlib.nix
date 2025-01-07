import ./make-test-python.nix (
  { lib, pkgs, ... }:
  {
    name = "redlib";
    meta.maintainers = with lib.maintainers; [
      soispha
      Guanran928
    ];

    nodes.machine = {
      services.redlib = {
        package = pkgs.redlib;
        enable = true;
        # Test CAP_NET_BIND_SERVICE
        port = 80;

        settings = {
          REDLIB_DEFAULT_USE_HLS = true;
        };
      };
    };

    testScript = ''
      machine.wait_for_unit("redlib.service")
      machine.wait_for_open_port(80)
      # Query a page that does not require Internet access
      machine.succeed("curl --fail http://localhost:80/settings")
      machine.succeed("curl --fail http://localhost:80/info | grep '<tr><td>Use HLS</td><td>on</td></tr>'")
    '';
  }
)
