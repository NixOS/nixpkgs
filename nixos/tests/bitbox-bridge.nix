{ lib, ... }:

let
  testPort = 8179;
in
{
  name = "bitbox-bridge";
  meta.maintainers = with lib.maintainers; [
    izelnakri
    tensor5
  ];

  nodes.machine = {
    services.bitbox-bridge = {
      enable = true;
      port = testPort;
      runOnMount = false;
    };
  };

  testScript = ''
    start_all()
    machine.wait_for_unit("bitbox-bridge.service")
    machine.wait_for_open_port(${toString testPort})
    machine.wait_until_succeeds("curl -fL http://localhost:${toString testPort}/api/info | grep version")
  '';
}
