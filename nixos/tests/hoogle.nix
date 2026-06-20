{ lib, ... }:
{
  name = "hoogle";
  meta.maintainers = with lib.maintainers; [ h7x4 ];

  nodes.machine =
    { pkgs, ... }:
    {
      services.hoogle = {
        enable = true;
        packages =
          hp: with hp; [
            arrows
            lens
          ];
      };
    };

  testScript =
    { nodes, ... }:
    let
      cfg = nodes.machine.services.hoogle;
    in
    ''
      machine.wait_for_unit("hoogle.service")
      machine.wait_for_open_port(${toString cfg.port})

      machine.succeed("curl http://${cfg.host}:${toString cfg.port} | grep '<title>Hoogle</title>'")
      machine.succeed("curl 'http://${cfg.host}:${toString cfg.port}?hoogle=>>>' | grep Arrow")
    '';
}
