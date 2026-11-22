{ lib, pkgs, ... }:
{
  name = "xpadneo";
  meta.maintainers = with lib.maintainers; [ kira-bruneau ];

  nodes = {
    machine = {
      config.hardware.xpadneo = {
        enable = true;
        rumbleAttenuation = {
          overall = 50;
          triggers = 25;
        };
        settings = {
          disable_deadzones = 1;
          trigger_rumble_mode = 2;
        };
      };
    };
  };

  # This is just a sanity check to make sure the module was
  # loaded. We'd have to find some way to mock an xbox controller if
  # we wanted more in-depth testing.
  testScript = ''
    machine.start();
    machine.succeed("modinfo hid_xpadneo | grep 'version:\s\+${pkgs.linuxPackages.xpadneo.version}'")

    machine.succeed("grep 'options hid_xpadneo' /etc/modprobe.d/nixos.conf")
    machine.succeed("grep 'disable_deadzones=1' /etc/modprobe.d/nixos.conf")
    machine.succeed("grep 'trigger_rumble_mode=2' /etc/modprobe.d/nixos.conf")
    machine.succeed("grep 'rumble_attenuation=50,25' /etc/modprobe.d/nixos.conf")
  '';
}
