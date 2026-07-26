{ pkgs, ... }:

{
  name = "joplin-server";
  meta.maintainers = with pkgs.lib.maintainers; [ Apollo-sudo767 ];

  nodes.machine =
    { config, pkgs, ... }:
    {
      services.joplin-server = {
        enable = true;
        baseUrl = "http://localhost:22300";
      };
    };

  testScript = ''
    machine.wait_for_unit("postgresql.service")
    machine.wait_for_unit("joplin-server.service")
    machine.wait_for_open_port(22300)
    machine.succeed("curl -s http://localhost:22300/ping | grep -i 'pong'")
  '';
}
