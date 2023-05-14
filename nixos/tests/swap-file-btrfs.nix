import ./make-test-python.nix ({ lib, ... }:
{
  name = "swap-file-btrfs";

  meta.maintainers = with lib.maintainers; [ oxalica ];

  nodes.machine =
    { pkgs, ... }:
    {
      virtualisation.useDefaultFilesystems = false;

      virtualisation.rootDevice = "/dev/vda";

      boot.initrd.postDeviceCommands = ''
        ${pkgs.btrfs-progs}/bin/mkfs.btrfs --label root /dev/vda
      '';

      virtualisation.fileSystems = {
        "/" = {
          device = "/dev/disk/by-label/root";
          fsType = "btrfs";
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
    machine.succeed("stat --file-system --format=%T /var/swapfile | grep btrfs")
    # First run. Auto creation.
    machine.succeed("swapon --show | grep /var/swapfile")

    machine.shutdown()
    machine.start()

    # Second run. Use it as-is.
    machine.wait_for_unit('var-swapfile.swap')
    machine.succeed("swapon --show | grep /var/swapfile")
  '';
})
