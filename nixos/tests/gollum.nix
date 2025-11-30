{ pkgs, ... }:
{
  name = "gollum";

  nodes = {
    webserver =
      { pkgs, lib, ... }:
      {
        services.gollum.enable = true;
      };
  };

  testScript =
    { nodes, ... }:
    ''
      webserver.wait_for_unit("gollum")
      webserver.wait_for_open_port(${toString nodes.webserver.services.gollum.port})
    '';
}
