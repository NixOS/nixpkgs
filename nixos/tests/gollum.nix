{ pkgs, ... }:
{
  name = "gollum";

  nodes = {
    webserver =
      { pkgs, lib, ... }:
      {
        services.gollum.enable = true;
        services.gollum.extraConfig = ''
          wiki_options = {
            show_local_time: true
          }

          Precious::App.set(:wiki_options, wiki_options)
        '';
      };
  };

  testScript =
    { nodes, ... }:
    ''
      webserver.wait_for_unit("gollum")
      webserver.wait_for_open_port(${toString nodes.webserver.services.gollum.port})
    '';
}
