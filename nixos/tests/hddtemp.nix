{ pkgs, ... }:
{
  name = "hddtemp";
  meta = with pkgs.lib.maintainers; {
    maintainers = [
      peterhoeg
      usovalx
    ];
  };

  nodes.machine =
    { config, pkgs, ... }:
    {
      systemd.enableStrictShellChecks = true;

      hardware.sensor.hddtemp = {
        enable = true;
        drives = [
          "/dev/sda"
          "/dev/sdb"
        ];
        extraArgs = [ "--listen=127.0.0.1" ];
      };
    };

  # system build-only test, nothing to actually run
  testScript = ''
    machine.start()
    machine.wait_for_unit("hddtemp.service")
  '';
}
