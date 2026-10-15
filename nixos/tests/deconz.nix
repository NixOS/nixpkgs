{ lib, ... }:
let
  httpPort = 800;
in
{
  name = "deconz";

  meta.maintainers = with lib.maintainers; [
    bjornfor
  ];

  node.pkgsReadOnly = false;

  nodes.machine = {
    services.deconz = {
      enable = true;
      inherit httpPort;
      extraArgs = [
        "--dbg-err=2"
        "--dbg-info=2"
      ];
    };
  };

  testScript = ''
    machine.wait_for_unit("deconz.service")
    machine.succeed("curl -sfL http://localhost:${toString httpPort}")
  '';
}
