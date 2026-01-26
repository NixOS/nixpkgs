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
          virtualHost = {
            nginx.enable = true;
            domain = "localhost";
          };
        };
      };

    testScript = ''
      machine.wait_for_unit("nginx.service")
      machine.wait_for_open_port(80)
      machine.succeed("curl --fail --show-error --silent http://localhost:80/ | grep '<title>BentoPDF - The Privacy First PDF Toolkit</title>'")
    '';
  }
)
