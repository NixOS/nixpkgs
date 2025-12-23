{ lib, ... }:
{
  name = "swap-file-btrfs";

  meta.maintainers = with lib.maintainers; [ oxalica ];

  nodes.machine =
    { config, pkgs, ... }:
    {
      virtualisation.useDefaultFilesystems = false;

      virtualisation.rootDevice = "/dev/vda";

      boot.initrd.systemd.enable = true;
      virtualisation.fileSystems = {
        "/" = {
          device = config.virtualisation.rootDevice;
          fsType = "btrfs";
          autoFormat = true;
        };
      };

      swapDevices = [
        {
          device = "/var/swapfile";
          size = 1; # 1MiB.
        }
      ];
    };

  testScript = ''
    machine.wait_for_unit('var-swapfile.swap')
    # Ensure the swap file creation script ran to completion without failing when creating the swap file
    machine.fail("systemctl is-failed --quiet mkswap-var-swapfile.service")
    machine.succeed("stat --file-system --format=%T /var/swapfile | grep btrfs")
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
