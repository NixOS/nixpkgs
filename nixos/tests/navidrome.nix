import ./make-test-python.nix (
  { pkgs, ... }:
  {
    name = "navidrome";

    nodes.machine =
      { ... }:
      {
        services.navidrome.enable = true;
      };

    testScript = ''
      machine.wait_for_unit("navidrome")
      machine.wait_for_open_port(4533)
    '';
  }
)
