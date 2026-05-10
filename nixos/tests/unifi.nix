{ lib, ... }:

{
  name = "unifi";

  meta.maintainers = with lib.maintainers; [
    patryk27
    zhaofengli
  ];

  node.pkgsReadOnly = false;

  nodes.machine = {
    services.unifi.enable = true;
  };

  testScript = ''
    import json

    start_all()

    machine.wait_for_unit("unifi.service")
    machine.wait_for_open_port(8880)
    machine.succeed("systemctl show unifi.service | grep -q 'ActiveState=active'")
    machine.succeed("pgrep mongod")

    status = json.loads(machine.succeed("curl --silent --show-error --fail-with-body http://localhost:8880/status"))
    assert status["meta"]["rc"] == "ok"

    machine.succeed("systemctl stop unifi.service")
    machine.succeed("systemctl show unifi.service | grep -q 'ActiveState=inactive'")
    machine.fail("pgrep mongod")

    machine.succeed("systemctl start unifi.service")
    machine.wait_for_unit("unifi.service")
    machine.succeed("systemctl show unifi.service | grep -q 'ActiveState=active'")
    machine.succeed("pgrep mongod")
  '';
}
