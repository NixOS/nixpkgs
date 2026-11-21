{ lib, ... }:
{
  name = "zcfan";
  meta.maintainers = with lib.maintainers; [ surfaceflinger ];

  nodes.machine =
    { pkgs, ... }:
    {
      imports = [ ../modules/profiles/minimal.nix ];

      services.zcfan = {
        enable = true;
        settings = {
          max_temp = 85;
          med_temp = 70;
          low_temp = 55;
          temp_hysteresis = 20;
          # Max allowed, so the watchdog never fires during the short test
          # and overwrites the fan level file.
          watchdog_secs = 120;
          max_level = "full-speed";
          med_level = "4";
          low_level = "3";
          ignore_sensor = [
            "nvme"
            "BAT0"
          ];
        };
      };

      # zcfan uses fixed thinkpad_acpi paths, so fake them in the test VM.
      systemd.services.fake-fan = {
        wantedBy = [ "multi-user.target" ];
        before = [ "zcfan.service" ];
        serviceConfig.Type = "oneshot";
        path = [ pkgs.util-linux ];
        script = ''
          mount -t tmpfs tmpfs /proc/acpi
          mkdir -p /proc/acpi/ibm
          printf '%s\n' \
            'status: enabled' \
            'level: auto' \
            'commands: level <level> (0-7, auto, disengaged, full-speed)' \
            'commands: watchdog <timeout> (0-120)' \
            'fan: 0' \
            'speed: 0' > /proc/acpi/ibm/fan

          mount -t tmpfs tmpfs /sys/class/hwmon
          for sensor in hwmon0 hwmon1 hwmon2; do
            mkdir -p "/sys/class/hwmon/$sensor"
          done
          echo nvme > /sys/class/hwmon/hwmon0/name
          echo 95000 > /sys/class/hwmon/hwmon0/temp1_input
          echo BAT0 > /sys/class/hwmon/hwmon1/name
          echo 96000 > /sys/class/hwmon/hwmon1/temp1_input
          echo fake > /sys/class/hwmon/hwmon2/name
          echo 60000 > /sys/class/hwmon/hwmon2/temp1_input
        '';
      };
    };

  testScript = ''
    from datetime import timedelta

    start_all()
    machine.wait_for_unit("multi-user.target")
    machine.wait_for_unit("zcfan.service")

    # The nvme and BAT0 sensors are ignored, so the remaining 60C sensor
    # selects the configured low level.
    machine.wait_until_succeeds("grep -qx 'level 3' /proc/acpi/ibm/fan", timeout=timedelta(seconds=60))
    machine.wait_until_succeeds(
        "journalctl -u zcfan | grep -q 'Temperature now 60C, fan set to low'", timeout=timedelta(seconds=60)
    )
    machine.wait_until_succeeds(
        "journalctl -u zcfan | grep -q 'Ignored 2 present sensors'", timeout=timedelta(seconds=60)
    )
    machine.succeed("journalctl -u zcfan | grep -q 'At 85C fan is set to maximum'")
    machine.succeed("journalctl -u zcfan | grep -q 'At 70C fan is set to medium'")
    machine.succeed("journalctl -u zcfan | grep -q 'At 55C fan is set to low'")
    machine.succeed("systemctl is-active --quiet zcfan.service")
  '';
}
