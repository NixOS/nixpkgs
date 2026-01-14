{ lib, ... }:
{
  name = "gowitness";

  nodes.machine = {
    services.gowitness.enable = true;
  };

  testScript = ''
    machine.wait_for_unit("gowitness.service")
    machine.wait_for_open_port(7171)
    machine.fail("journalctl -u gowitness.service | grep debug")
    machine.succeed("journalctl -u gowitness.service | grep 127.0.0.1")
    machine.succeed("journalctl -u gowitness.service | grep 7171")
    machine.succeed("cat /etc/systemd/system/gowitness.service | grep User=gowitness")
    machine.succeed("cat /etc/systemd/system/gowitness.service | grep Group=gowitness")
  '';

  meta.maintainers = with lib.maintainers; [ codexlynx ];
}
