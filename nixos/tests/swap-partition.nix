{ ... }:
{
  name = "swap-partition";

  nodes.machine =
    { config, ... }:
    {
      virtualisation.useDefaultFilesystems = false;

      virtualisation.rootDevice = "/dev/vda1";

      boot.initrd.systemd = {
        enable = true;
        repart = {
          enable = true;
          device = "/dev/vda";
          empty = "allow";
        };
      };
      systemd.repart.partitions = {
        "00-root" = {
          Type = "linux-generic";
          Format = "ext4";
          Label = "root";
        };
        "10-swap" = {
          Type = "linux-generic";
          Label = "swap";
          SizeMinBytes = "250M";
          SizeMaxBytes = "250M";
        };
      };

      virtualisation.fileSystems = {
        "/" = {
          device = "/dev/disk/by-label/root";
          fsType = "ext4";
        };
      };

      swapDevices = [
        {
          device = "/dev/disk/by-partlabel/swap";
          options = [ "x-systemd.makefs" ];
        }
      ];
    };

  testScript = ''
    machine.wait_for_unit("multi-user.target")

    with subtest("Swap is active"):
      # Doesn't matter if the numbers reported by `free` are slightly off due to unit conversions.
      machine.succeed("free -h | grep -E 'Swap:\s+2[45][0-9]Mi'")
  '';
}
