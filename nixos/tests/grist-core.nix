import ./make-test-python.nix (
  { lib, ... }:
  with lib;
  {
    name = "grist";
    meta.maintainers = with maintainers; [ scandiravian ];

    nodes.machine =
      { pkgs, ... }:
      {
        services.grist-core = {
          enable = true;

          settings = {
            DEBUG = "1";
          };
        };
      };

    testScript = ''
      machine.wait_for_unit("grist-core.service")
      machine.wait_until_succeeds("curl --fail http://[::1]:8484", 15)
    '';
  }
)
