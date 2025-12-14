{ lib, ... }:
{
  name = "it-tools-nginx";
  meta.maintainers = [ lib.maintainers.akotro ];

  nodes.machine =
    { pkgs, ... }:
    {
      services.it-tools = {
        enable = true;
        nginx = {
          enable = true;
          domain = "localhost";
        };
      };
    };

  testScript = ''
    machine.wait_for_unit("nginx.service")
    machine.wait_for_open_port(80)
    machine.succeed("curl --fail --show-error --silent http://localhost:80/ | grep '<title>IT Tools - Handy online tools for developers</title>'")
  '';
}
