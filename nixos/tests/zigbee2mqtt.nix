import ./make-test-python.nix ({ pkgs, ... }:

  {
    machine = { pkgs, ... }:
      {
        services.zigbee2mqtt = {
          enable = true;
        };
      };

    testScript = ''
      machine.wait_for_unit("zigbee2mqtt.service")
      machine.wait_until_fails("systemctl status zigbee2mqtt.service")
      machine.succeed(
          "journalctl -eu zigbee2mqtt | grep \"Error: Error while opening serialport 'Error: Error: No such file or directory, cannot open /dev/ttyACM0'\""
      )
    '';
  }
)
