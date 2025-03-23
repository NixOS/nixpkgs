{
  lib,
  package,
  pkgs,
  ...
}:

let
  error =
    if lib.versionOlder package.version "2" then
      "Inappropriate ioctl for device, cannot set"
    else
      "No valid USB adapter found";
in
{
  name = "zigbee2mqtt-${lib.versions.major package.version}.x";
  nodes.machine = {
    systemd.services.dummy-serial = {
      wantedBy = [
        "multi-user.target"
      ];
      serviceConfig = {
        ExecStart = "${pkgs.socat}/bin/socat pty,link=/dev/ttyACM0,mode=666 pty,link=/dev/ttyACM1";
      };
    };

    services.zigbee2mqtt = {
      enable = true;
      inherit package;
    };

    systemd.services.zigbee2mqtt.serviceConfig.DevicePolicy = lib.mkForce "auto";
  };

  testScript = ''
    machine.wait_for_unit("multi-user.target")
    machine.wait_until_fails("systemctl status zigbee2mqtt.service")
    machine.succeed(
        "journalctl -eu zigbee2mqtt | grep '${error}'"
    )

    machine.log(machine.succeed("systemd-analyze security zigbee2mqtt.service"))
  '';
}
