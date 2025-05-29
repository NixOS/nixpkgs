{ lib, ... }:
{
  name = "commafeed";

  nodes.server = {
    services.commafeed = {
      enable = true;
    };
  };

  testScript = ''
    server.start()
    server.wait_for_unit("commafeed.service")
    server.wait_for_open_port(8082)
    server.succeed("curl --fail --silent http://localhost:8082")
  '';

  meta.maintainers = [ lib.maintainers.raroh73 ];
}
