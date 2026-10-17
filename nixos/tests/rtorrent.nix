{ pkgs, ... }:
let
  port = 50001;
in
{
  name = "rtorrent";
  meta = {
    maintainers = with pkgs.lib.maintainers; [ thiagokokada ];
  };

  nodes.machine =
    { pkgs, ... }:
    {
      services.rtorrent = {
        inherit port;
        enable = true;
      };
    };

  testScript = # python
    ''
      machine.start()
      machine.wait_for_unit("rtorrent.service")
      machine.wait_for_open_port(${toString port})

      machine.succeed("nc -z localhost ${toString port}")
    '';
}
