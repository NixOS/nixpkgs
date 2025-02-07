{ lib, ... }:
{
  name = "it-tools-caddy";
  meta.maintainers = [ lib.maintainers.akotro ];

  nodes.machine =
    { pkgs, ... }:
    {
      services.it-tools = {
        enable = true;
        caddy = {
          enable = true;
          domain = "localhost:80";
        };
      };
    };

  testScript = ''
    machine.wait_for_unit("caddy.service")
    machine.wait_for_open_port(80)
    machine.succeed("curl --fail --show-error --silent http://localhost:80/ | grep '<title>IT Tools - Handy online tools for developers</title>'")
  '';
}
