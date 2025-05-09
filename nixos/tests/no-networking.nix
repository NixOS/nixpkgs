import ./make-test-python.nix (
  { pkgs, ... }:
  {
    name = "no-networking";
    meta = {
      maintainers = [ ];
    };

    nodes.machine =
      { ... }:
      {
        networking.enable = false;
      };

    testScript = ''
      start_all()

      # Assert that the system does not have iproute2
      machine.fail(
          'test -e /run/current-system/sw/bin/ip'
      )
    '';
  }
)
