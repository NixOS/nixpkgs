{
  lib,
  pkgs,
  ...
}:

{
  name = "zigbee2mqtt";
  nodes.machine = {
    systemd.services.dummy-serial = {
      wantedBy = [
        "multi-user.target"
      ];
      serviceConfig = {
        ExecStart = "${pkgs.socat}/bin/socat pty,link=/dev/ttyACM0,mode=666 pty,link=/dev/ttyACM1";
      };
    };

    services.zigbee2mqtt.enable = true;

    systemd.services.zigbee2mqtt.serviceConfig.DevicePolicy = lib.mkForce "auto";
  };

  testScript = ''
    machine.wait_for_unit("multi-user.target")
    machine.wait_until_fails("systemctl status zigbee2mqtt.service")
    machine.succeed(
        "journalctl -eu zigbee2mqtt | grep 'No valid USB adapter found'"
    )

    machine.log(machine.succeed("systemd-analyze security zigbee2mqtt.service"))
  '';
}
