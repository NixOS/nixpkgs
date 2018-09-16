import ./make-test.nix ({ pkgs, ... }: {
  name = "bcachefs";
  meta.maintainers = with pkgs.stdenv.lib.maintainers; [ chiiruno ];

  machine = { pkgs, ... }: {
    virtualisation.emptyDiskImages = [ 4096 ];
    networking.hostId = "deadbeef";
    boot.supportedFilesystems = [ "bcachefs" ];
    environment.systemPackages = with pkgs; [ parted ];
  };

  testScript = ''
    $machine->succeed("modprobe bcachefs");
    $machine->succeed("bcachefs version");
    $machine->succeed("ls /dev");
    
    $machine->succeed(
      "mkdir /tmp/mnt",

      "udevadm settle",
      "parted --script /dev/vdb mklabel msdos",
      "parted --script /dev/vdb -- mkpart primary 1024M -1s",
      "udevadm settle",

      # Due to #32279, we cannot use encryption for this test yet
      # "echo password | bcachefs format --encrypted /dev/vdb1",
      # "echo password | bcachefs unlock /dev/vdb1",
      "bcachefs format /dev/vdb1",
      "mount -t bcachefs /dev/vdb1 /tmp/mnt",
      "udevadm settle",

      "bcachefs fs usage /tmp/mnt",

      "umount /tmp/mnt",
      "udevadm settle"
    );
  '';
})
