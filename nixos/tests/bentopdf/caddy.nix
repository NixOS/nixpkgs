import ../make-test-python.nix (
  { lib, ... }:

  {
    name = "bentopdf-caddy";
    meta.maintainers = with lib.maintainers; [ stunkymonkey ];

    nodes.machine =
      { pkgs, ... }:
      {
        services.bentopdf = {
          enable = true;
          virtualHost = {
            caddy.enable = true;
            domain = "localhost:80";
          };
        };
      };

    testScript = ''
      machine.wait_for_unit("caddy.service")
      machine.wait_for_open_port(80)
      machine.succeed("curl --fail --show-error --silent http://localhost:80/ | grep '<title>BentoPDF - The Privacy First PDF Toolkit</title>'")
    '';
  }
)
