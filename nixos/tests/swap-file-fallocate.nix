{ lib, ... }:
{
  name = "swap-file-fallocate";

  meta.maintainers = with lib.maintainers; [ EpicEric ];

  nodes.machine =
    { ... }:
    {
      virtualisation.useDefaultFilesystems = false;

      virtualisation.rootDevice = "/dev/vda1";

      boot.initrd.systemd = {
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
      };

      virtualisation.fileSystems = {
        "/" = {
          device = "/dev/disk/by-label/root";
          fsType = "ext4";
        };
      };

      swapDevices = [
        {
          device = "/var/swapfile";
          size = 10; # 10MiB.
          zeroize = false;
        }
      ];
    };

  testScript = ''
    machine.wait_for_unit('var-swapfile.swap')
    # Ensure the swap file creation script ran to completion without failing when creating the swap file
    machine.fail("systemctl is-failed --quiet mkswap-var-swapfile.service")
    machine.succeed("stat --format=%s /var/swapfile | grep 10485760")
    # First run. Auto creation.
    machine.succeed("swapon --show | grep /var/swapfile")

    machine.shutdown()
    machine.start()

    # Second run. Use it as-is.
    machine.wait_for_unit('var-swapfile.swap')
    # Ensure the swap file creation script ran to completion without failing when the swap file already exists
    machine.fail("systemctl is-failed --quiet mkswap-var-swapfile.service")
    machine.succeed("swapon --show | grep /var/swapfile")
  '';
}
