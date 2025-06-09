{ pkgs, ... }:
{
  name = "isso";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ ];
  };

  nodes.machine =
    { config, pkgs, ... }:
    {
      services.isso = {
        enable = true;
        settings = {
          general = {
            dbpath = "/var/lib/isso/comments.db";
            host = "http://localhost";
          };
        };
      };
    };

  testScript =
    let
      port = 8080;
    in
    ''
      machine.wait_for_unit("isso.service")

      machine.wait_for_open_port(${toString port})

      machine.succeed("curl --fail http://localhost:${toString port}/?uri")
      machine.succeed("curl --fail http://localhost:${toString port}/js/embed.min.js")
    '';
}
