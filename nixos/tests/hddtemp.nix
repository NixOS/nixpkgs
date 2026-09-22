{ pkgs, ... }: {
  name = "hddtemp";
  meta = {
    inherit (pkgs.hddtemp.meta) maintainers;
  };

  nodes.machine =
    { config, pkgs, ... }:
    {
      virtualisation.qemu.options = [
        "-drive file=${pkgs.emptyFile},format=raw,if=ide,media=disk,snapshot=on"
      ];

      environment.systemPackages = [ pkgs.netcat ];

      hardware.sensor.hddtemp = {
        enable = true;
        drives = [
          "/dev/sda"
        ];
        extraArgs = [ "--listen=127.0.0.1" ];
        dbEntries = [
          # custom SMART decoding rule for QEMU disk
          ''"QEMU HARDDISK"   190 C "QEMU hard disk"''
        ];
      };
    };

  testScript = ''
    machine.start()
    machine.wait_for_unit("hddtemp.service")
    output = machine.succeed("nc -w1 localhost 7634")
    assert output == "|/dev/sda|QEMU HARDDISK|31|C|", output
  '';
}
