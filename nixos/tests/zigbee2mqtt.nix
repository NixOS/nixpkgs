import ./make-test-python.nix ({ pkgs, lib, ... }:

  {
    nodes.machine = { pkgs, ... }:
      {
        services.zigbee2mqtt = {
          enable = true;
        };

        systemd.services.zigbee2mqtt.serviceConfig.DevicePolicy = lib.mkForce "auto";
      };

    testScript = ''
      machine.wait_for_unit("zigbee2mqtt.service")
      machine.wait_until_fails("systemctl status zigbee2mqtt.service")
      machine.succeed(
          "journalctl -eu zigbee2mqtt | grep \"Error: Error while opening serialport 'Error: Error: No such file or directory, cannot open /dev/ttyACM0'\""
      )

      machine.log(machine.succeed("systemd-analyze security zigbee2mqtt.service"))
    '';
  }
)
