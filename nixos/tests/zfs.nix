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

      machine = { pkgs, ... }: {
        virtualisation.emptyDiskImages = [ 4096 ];
        networking.hostId = "deadbeef";
        boot.kernelPackages = kernelPackage;
        boot.supportedFilesystems = [ "zfs" ];
        boot.zfs.enableUnstable = enableUnstable;

        environment.systemPackages = [ pkgs.parted ];
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
      '' + extraTest;

    };


in {

  stable = makeZfsTest "stable" { };

  unstable = makeZfsTest "unstable" {
    enableUnstable = true;
    extraTest = ''
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
    '';
  };

  installer = (import ./installer.nix { }).zfsroot;
}
