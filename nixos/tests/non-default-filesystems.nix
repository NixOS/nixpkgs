import ./make-test-python.nix ({ lib, pkgs, ... }:
{
  name = "non-default-filesystems";

  nodes.machine =
    { config, pkgs, lib, ... }:
    let
      disk = config.virtualisation.rootDevice;
    in
    {
      virtualisation.rootDevice = "/dev/vda";
      virtualisation.useDefaultFilesystems = false;

      boot.initrd.availableKernelModules = [ "btrfs" ];
      boot.supportedFilesystems = [ "btrfs" ];

      boot.initrd.postDeviceCommands = ''
        FSTYPE=$(blkid -o value -s TYPE ${disk} || true)
        if test -z "$FSTYPE"; then
          modprobe btrfs
          ${pkgs.btrfs-progs}/bin/mkfs.btrfs ${disk}

          mkdir /nixos
          mount -t btrfs ${disk} /nixos

          ${pkgs.btrfs-progs}/bin/btrfs subvolume create /nixos/root
          ${pkgs.btrfs-progs}/bin/btrfs subvolume create /nixos/home

          umount /nixos
        fi
      '';

      virtualisation.fileSystems = {
        "/" = {
          device = disk;
          fsType = "btrfs";
          options = [ "subvol=/root" ];
        };

        "/home" = {
          device = disk;
          fsType = "btrfs";
          options = [ "subvol=/home" ];
        };
      };
    };

  testScript = ''
    machine.wait_for_unit("multi-user.target")

    with subtest("BTRFS filesystems are mounted correctly"):
      machine.succeed("grep -E '/dev/vda / btrfs rw,relatime,space_cache=v2,subvolid=[0-9]+,subvol=/root 0 0' /proc/mounts")
      machine.succeed("grep -E '/dev/vda /home btrfs rw,relatime,space_cache=v2,subvolid=[0-9]+,subvol=/home 0 0' /proc/mounts")
  '';
})
