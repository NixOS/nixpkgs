import ../make-test-python.nix (
  { lib, ... }:

  {
    name = "homer-nginx";
    meta.maintainers = with lib.maintainers; [ stunkymonkey ];

    nodes.machine =
      { pkgs, ... }:
      {
        services.homer = {
          enable = true;
          virtualHost = {
            nginx.enable = true;
            domain = "localhost";
          };
          settings = {
            title = "testing";
          };
        };
      };

    testScript = ''
      machine.wait_for_unit("nginx.service")
      machine.wait_for_open_port(80)
      machine.succeed("curl --fail --show-error --silent http://localhost:80/ | grep '<title>Homer</title>'")
      machine.succeed("curl --fail --show-error --silent http://localhost:80/assets/config.yml | grep 'title: testing'")
    '';
  }
)
