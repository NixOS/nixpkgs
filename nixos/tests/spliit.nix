import ./make-test-python.nix (
  { lib, ... }:
  {
    name = "spliit";
    meta.maintainers = with lib.maintainers; [ qvalentin ];

    nodes.machine =
      { ... }:
      {
        services.spliit = {
          enable = true;
        };
      };

    testScript = ''
      machine.wait_for_unit("spliit.service")
      machine.wait_for_open_port(3000)
      machine.succeed("curl --fail http://127.0.0.1:3000")
    '';
  }
)
