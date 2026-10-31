{ ... }:
{
  name = "snapper";

  nodes.machine =
    { pkgs, lib, ... }:
    {
      virtualisation.emptyDiskImages = [
        {
          size = 4096;
          driveConfig.deviceExtraOpts.serial = "aux";
        }
      ];

      virtualisation.fileSystems = {
        "/home" = {
          device = "/dev/disk/by-id/virtio-aux";
          fsType = "btrfs";
          autoFormat = true;
        };
      };
      services.snapper.configs.home.SUBVOLUME = "/home";
      services.snapper.filters = "/nix";
    };

  testScript =
    { nodes, ... }:
    let
      inherit (nodes.machine.services.snapper) snapshotRootOnBoot;
    in
    ''
      machine.succeed("btrfs subvolume create /home/.snapshots")
      machine.succeed("snapper -c home list")
      machine.succeed("snapper -c home create --description empty")
      machine.succeed("echo test > /home/file")
      machine.succeed("snapper -c home create --description file")
      machine.succeed("snapper -c home status 1..2")
      machine.succeed("snapper -c home undochange 1..2")
      machine.fail("ls /home/file")
      machine.succeed("snapper -c home delete 2")
      machine.succeed("systemctl --wait start snapper-timeline.service")
      machine.succeed("systemctl --wait start snapper-cleanup.service")
      machine.${if snapshotRootOnBoot then "succeed" else "fail"}("systemctl cat snapper-boot.service")
    '';
}
