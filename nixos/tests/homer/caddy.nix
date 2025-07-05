import ../make-test-python.nix (
  { lib, ... }:

  {
    name = "homer-caddy";
    meta.maintainers = with lib.maintainers; [ stunkymonkey ];

    nodes.machine =
      { pkgs, ... }:
      {
        services.homer = {
          enable = true;
          virtualHost = {
            caddy.enable = true;
            domain = "localhost:80";
          };
          settings = {
            title = "testing";
          };
        };
      };

    testScript = ''
      machine.wait_for_unit("caddy.service")
      machine.wait_for_open_port(80)
      machine.succeed("curl --fail --show-error --silent http://localhost:80/ | grep '<title>Homer</title>'")
      machine.succeed("curl --fail --show-error --silent http://localhost:80/assets/config.yml | grep 'title: testing'")
    '';
  }
)
