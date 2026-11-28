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
      persistUnit = "etc/systemd/system/bluetooth-persist-power-state.service";
    in
    ''
      start_all()

      for name, auto_enable in [("powerOn", "true"), ("powerOff", "false"), ("auto", "true")]:
          with subtest(f"{name} sets AutoEnable={auto_enable}"):
              config = machine.succeed(f"cat ${specialisations}/{name}/etc/bluetooth/main.conf")
              assert f"AutoEnable={auto_enable}" in config, config

      with subtest("only auto persists the power state"):
          machine.succeed("test -e ${specialisations}/auto/${persistUnit}")
          machine.fail("test -e ${specialisations}/powerOn/${persistUnit}")
          machine.fail("test -e ${specialisations}/powerOff/${persistUnit}")
    '';
}
