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

      with subtest("persist service uses rfkill to enforce off state"):
          unit = machine.succeed("cat ${specialisations}/auto/etc/systemd/system/bluetooth-persist-power-state.service")
          assert "rfkill block bluetooth" in unit, f"Expected 'rfkill block bluetooth' in unit, got: {unit}"

      with subtest("powerOnBoot = true does not create persist service"):
          machine.fail("test -e ${specialisations}/powerOn/etc/systemd/system/bluetooth-persist-power-state.service")

      with subtest("powerOnBoot = false does not create persist service"):
          machine.fail("test -e ${specialisations}/powerOff/etc/systemd/system/bluetooth-persist-power-state.service")
    '';
}
