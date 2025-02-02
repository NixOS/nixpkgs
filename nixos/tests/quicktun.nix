import ./make-test-python.nix (
  { pkgs, lib, ... }:
  {
    name = "quicktun";
    meta.maintainers = with lib.maintainers; [ h7x4 ];

    nodes = {
      machine =
        { ... }:
        {
          services.quicktun."test-tunnel" = {
            protocol = "raw";
          };
        };
    };

    testScript = ''
      start_all()
      machine.wait_for_unit("quicktun-test-tunnel.service")
    '';
  }
)
