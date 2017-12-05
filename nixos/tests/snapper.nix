import ./make-test.nix ({ ... }:
{
  name = "snapper";

  machine = { pkgs, lib, ... }: {
    boot.initrd.postDeviceCommands = ''
      ${pkgs.btrfs-progs}/bin/mkfs.btrfs -f -L aux /dev/vdb
    '';

    virtualisation.emptyDiskImages = [ 4096 ];

    fileSystems = lib.mkVMOverride {
      "/home" = {
        device = "/dev/disk/by-label/aux";
        fsType = "btrfs";
      };
    };
    services.snapper.configs.home.subvolume = "/home";
    services.snapper.filters = "/nix";
  };

  testScript = ''
    $machine->succeed("btrfs subvolume create /home/.snapshots");

    $machine->succeed("snapper -c home list");

    $machine->succeed("snapper -c home create --description empty");

    $machine->succeed("echo test > /home/file");
    $machine->succeed("snapper -c home create --description file");

    $machine->succeed("snapper -c home status 1..2");

    $machine->succeed("snapper -c home undochange 1..2");
    $machine->fail("ls /home/file");

    $machine->succeed("snapper -c home delete 2");

    $machine->succeed("systemctl --wait start snapper-timeline.service");

    $machine->succeed("systemctl --wait start snapper-cleanup.service");
  '';
})
