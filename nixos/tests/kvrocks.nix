{ lib, pkgs, ... }:

{
  name = "kvrocks";
  meta.maintainers = with lib.maintainers; [ xyenon ];

  nodes.machine = {
    services.kvrocks.enable = true;
  };

  testScript =
    { nodes, ... }:
    let
      inherit (nodes.machine.services) kvrocks;
    in
    ''
      start_all()
      machine.wait_for_unit("kvrocks")
      machine.wait_for_open_port(${toString kvrocks.settings.port})
      machine.succeed("${pkgs.redis}/bin/redis-cli -p ${toString kvrocks.settings.port} ping | grep PONG")
    '';
}
