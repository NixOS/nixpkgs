import ../make-test-python.nix (
  { lib, ... }:

  {
    name = "bentopdf-nginx";
    meta.maintainers = with lib.maintainers; [ stunkymonkey ];

    nodes.machine =
      { pkgs, ... }:
      {
        services.bentopdf = {
          enable = true;
          domain = "localhost";
          nginx.enable = true;
        };
      };

    testScript = ''
      machine.wait_for_unit("nginx.service")
      machine.wait_for_open_port(80)
      assert "<title>BentoPDF - The Privacy First PDF Toolkit</title>" in machine.succeed("curl --fail --show-error --silent --location --insecure http://localhost:80/")
    '';
  }
)
