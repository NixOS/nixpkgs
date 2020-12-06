{ system ? builtins.currentSystem,
  config ? {},
  pkgs ? import ../.. { inherit system config; }
}:

with import ../lib/testing-python.nix { inherit system pkgs; };

let

  makeZfsTest = name:
    { kernelPackage ? pkgs.linuxPackages_latest
    , enableUnstable ? false
    , extraTest ? ""
    }:
    makeTest {
      name = "zfs-" + name;
      meta = with pkgs.stdenv.lib.maintainers; {
        maintainers = [ adisbladis ];
      };

      machine = { pkgs, lib, ... }: {
        virtualisation.emptyDiskImages = [ 4096 ];
        networking.hostId = "deadbeef";
        boot.kernelPackages = kernelPackage;
        boot.supportedFilesystems = [ "zfs" ];
        boot.zfs.enableUnstable = enableUnstable;

        environment.systemPackages = [ pkgs.parted ];

        # Setup regular fileSystems machinery to ensure forceImportAll can be
        # tested via the regular service units.
        fileSystems = lib.mkVMOverride {
          "/forcepool" = {
            device = "forcepool";
            fsType = "zfs";
            options = [ "noauto" ];
          };
        };

        # forcepool doesn't exist at first boot, and we need to manually test
        # the import after tweaking the hostId.
        systemd.services.zfs-import-forcepool.wantedBy = lib.mkVMOverride [];
        systemd.targets.zfs.wantedBy = lib.mkVMOverride [];
        boot.zfs.forceImportAll = true;
        # /dev/disk/by-id doesn't get populated in the NixOS test framework
        boot.zfs.devNodes = "/dev/disk/by-uuid";
      };

      testScript = ''
        machine.succeed(
            "modprobe zfs",
            "zpool status",
            "ls /dev",
            "mkdir /tmp/mnt",
            "udevadm settle",
            "parted --script /dev/vdb mklabel msdos",
            "parted --script /dev/vdb -- mkpart primary 1024M -1s",
            "udevadm settle",
            "zpool create rpool /dev/vdb1",
            "zfs create -o mountpoint=legacy rpool/root",
            "mount -t zfs rpool/root /tmp/mnt",
            "udevadm settle",
            "umount /tmp/mnt",
            "zpool destroy rpool",
            "udevadm settle",
        )

        machine.succeed(
            'echo password | zpool create -o altroot="/tmp/mnt" '
            + "-O encryption=aes-256-gcm -O keyformat=passphrase rpool /dev/vdb1",
            "zfs create -o mountpoint=legacy rpool/root",
            "mount -t zfs rpool/root /tmp/mnt",
            "udevadm settle",
            "umount /tmp/mnt",
            "zpool destroy rpool",
            "udevadm settle",
        )

        with subtest("boot.zfs.forceImportAll works"):
            machine.succeed(
                "rm /etc/hostid",
                "zgenhostid deadcafe",
                "zpool create forcepool /dev/vdb1 -O mountpoint=legacy",
            )
            machine.shutdown()
            machine.start()
            machine.succeed("udevadm settle")
            machine.fail("zpool import forcepool")
            machine.succeed(
                "systemctl start zfs-import-forcepool.service",
                "mount -t zfs forcepool /tmp/mnt",
            )
      '' + extraTest;

    };


in {

  stable = makeZfsTest "stable" { };

  unstable = makeZfsTest "unstable" {
    enableUnstable = true;
  };

  installer = (import ./installer.nix { }).zfsroot;
}
