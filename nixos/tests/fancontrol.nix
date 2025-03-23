import ./make-test-python.nix (
  { pkgs, ... }:
  {
    name = "fancontrol";
    meta = with pkgs.lib.maintainers; {
      maintainers = [ evils ];
    };

    nodes.machine =
      { ... }:
      {
        imports = [ ../modules/profiles/minimal.nix ];
        hardware.fancontrol.enable = true;
        hardware.fancontrol.config = ''
          INTERVAL=42
          DEVPATH=hwmon1=devices/platform/dummy
          DEVNAME=hwmon1=dummy
          FCTEMPS=hwmon1/device/pwm1=hwmon1/device/temp1_input
          FCFANS=hwmon1/device/pwm1=hwmon1/device/fan1_input
          MINTEMP=hwmon1/device/pwm1=25
          MAXTEMP=hwmon1/device/pwm1=65
          MINSTART=hwmon1/device/pwm1=150
          MINSTOP=hwmon1/device/pwm1=0
        '';
      };

    # This configuration cannot be valid for the test VM, so it's expected to get an 'outdated' error.
    testScript = ''
      start_all()
      # can't wait for unit fancontrol.service because it doesn't become active due to invalid config
      # fancontrol.service is WantedBy multi-user.target
      machine.wait_for_unit("multi-user.target")
      machine.succeed(
          "journalctl -eu fancontrol | tee /dev/stderr | grep 'Configuration appears to be outdated'"
      )
      machine.shutdown()
    '';
  }
)
