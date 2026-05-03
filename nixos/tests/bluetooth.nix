{ lib, ... }:
{
  name = "bluetooth";
  meta.maintainers = with lib.maintainers; [
    bittner
    rnhmjoj
  ];

  nodes.machine = {
    hardware.bluetooth.enable = true;

    specialisation = {
      powerOn.configuration.hardware.bluetooth.powerOnBoot = true;
      powerOff.configuration.hardware.bluetooth.powerOnBoot = false;
      auto.configuration.hardware.bluetooth.powerOnBoot = "auto";
    };
  };

  testScript =
    { nodes, ... }:
    let
      specialisations = "${nodes.machine.system.build.toplevel}/specialisation";
    in
    ''
      start_all()

      with subtest("powerOnBoot = true sets AutoEnable = true"):
          config = machine.succeed("cat ${specialisations}/powerOn/etc/bluetooth/main.conf")
          assert "AutoEnable=true" in config, f"Expected AutoEnable=true, got: {config}"

      with subtest("powerOnBoot = false sets AutoEnable = false"):
          config = machine.succeed("cat ${specialisations}/powerOff/etc/bluetooth/main.conf")
          assert "AutoEnable=false" in config, f"Expected AutoEnable=false, got: {config}"

      with subtest("powerOnBoot = auto sets AutoEnable = true"):
          config = machine.succeed("cat ${specialisations}/auto/etc/bluetooth/main.conf")
          assert "AutoEnable=true" in config, f"Expected AutoEnable=true, got: {config}"

      with subtest("powerOnBoot = auto creates persist service"):
          machine.succeed("test -e ${specialisations}/auto/etc/systemd/system/bluetooth-persist-power-state.service")

      with subtest("persist service is a oneshot, not a long-running daemon"):
          unit = machine.succeed("cat ${specialisations}/auto/etc/systemd/system/bluetooth-persist-power-state.service")
          assert "Type=oneshot" in unit, f"Expected Type=oneshot, got: {unit}"
          assert "RemainAfterExit=true" in unit, f"Expected RemainAfterExit=true, got: {unit}"
          assert "ExecStart=" in unit, f"Expected ExecStart, got: {unit}"
          assert "ExecStop=" in unit, f"Expected ExecStop, got: {unit}"

      with subtest("persist service uses rfkill to enforce off state"):
          import re
          unit = machine.succeed("cat ${specialisations}/auto/etc/systemd/system/bluetooth-persist-power-state.service")
          match = re.search(r'ExecStart=(\S+)', unit)
          assert match, f"Could not find ExecStart in unit: {unit}"
          script = machine.succeed(f"cat {match.group(1)}")
          assert "rfkill block bluetooth" in script, f"Expected 'rfkill block bluetooth' in ExecStart script, got: {script}"

      with subtest("powerOnBoot = true does not create persist service"):
          machine.fail("test -e ${specialisations}/powerOn/etc/systemd/system/bluetooth-persist-power-state.service")

      with subtest("powerOnBoot = false does not create persist service"):
          machine.fail("test -e ${specialisations}/powerOff/etc/systemd/system/bluetooth-persist-power-state.service")
    '';
}
