{ system ? builtins.currentSystem }:

let
  inherit (import ../lib/testing.nix { inherit system; }) pkgs makeTest;

  mkStorageTest = name: attrs: makeTest {
    name = "storage-${name}";

    machine = { config, pkgs, ... }: {
      environment.systemPackages = [
        pkgs.nixpart pkgs.file pkgs.btrfs-progs pkgs.xfsprogs pkgs.lvm2
      ];
      virtualisation.emptyDiskImages = [ 4096 4096 ];
      environment.etc."storage.xml".text = let
        config = (import ../lib/eval-config.nix {
          modules = pkgs.lib.singleton attrs.config;
        }).config;
      in builtins.toXML {
        inherit (config) storage fileSystems swapDevices;
      };
    };

    testScript = ''
      my $diskStart;
      my @mtab;

      sub getMtab {
        my $mounts = $machine->succeed("cat /proc/mounts");
        chomp $mounts;
        return map [split], split /\n/, $mounts;
      }

      sub ensureSanity {
        # Check whether the filesystem in /dev/vda is still intact
        my $newDiskStart = $machine->succeed("dd if=/dev/vda bs=512 count=1");
        if ($diskStart ne $newDiskStart) {
          $machine->log("Something went wrong, the partitioner wrote " .
                        "something into the first 512 bytes of /dev/vda!");
          die;
        }

        # Check whether nixpart has unmounted anything
        my @currentMtab = getMtab;
        for my $mount (@mtab) {
          my $path = $mount->[1];
          unless (grep { $_->[1] eq $path } @currentMtab) {
            $machine->log("The partitioner seems to have unmounted $path.");
            die;
          }
        }
      }

      sub nixpart {
        $machine->succeed('nixpart -v --xml /etc/storage.xml >&2');
        ensureSanity;
      }

      sub ensurePartition {
        my ($name, $match) = @_;
        my $path = $name =~ /^\// ? $name : "/dev/disk/by-label/$name";
        my $out = $machine->succeed("file -Ls $path");
        my @matches = grep(/^$path: .*$match/i, $out);
        if (!@matches) {
          $machine->log("Partition on $path was expected to have a " .
                        "file system that matches $match, but instead " .
                        "has: $out");
          die;
        }
      }

      sub ensureNoPartition {
        $machine->succeed("test ! -e /dev/$_[0]");
      }

      sub ensureMountPoint {
        $machine->succeed("mountpoint $_[0]");
      }

      sub remountAndCheck {
        $machine->nest("Remounting partitions:", sub {
          # XXX: "findmnt -ARunl -oTARGET /mnt" seems to NOT print all mounts!
          my $getmountsCmd = "cat /proc/mounts | cut -d' ' -f2 | grep '^/mnt'";
          # Insert canaries first
          my $canaries = $machine->succeed($getmountsCmd . " | while read p;" .
                                           " do touch \"\$p/canary\";" .
                                           " echo \"\$p/canary\"; done");
          # Now unmount manually
          $machine->succeed($getmountsCmd . " | tac | xargs -r umount");
          # /mnt should be empty or non-existing
          my $found = $machine->succeed("find /mnt -mindepth 1");
          chomp $found;
          if ($found) {
            $machine->log("Cruft found in /mnt:\n$found");
            die;
          }
          # Try to remount with nixpart
          $machine->succeed("nixpart -vm --xml /etc/storage.xml");
          ensureMountPoint("/mnt");
          # Check if our beloved canaries are dead
          chomp $canaries;
          $machine->nest("Checking canaries:", sub {
            for my $canary (split /\n/, $canaries) {
              $machine->succeed("test -e '$canary'");
            }
          });
        });
      }

      $machine->waitForUnit("multi-user.target");

      # Gather mounts and superblock
      @mtab = getMtab;
      $diskStart = $machine->succeed("dd if=/dev/vda bs=512 count=1");

      $machine->execute("mkdir /mnt");

      ${attrs.testScript}
    '';
  };

in pkgs.lib.mapAttrs mkStorageTest {
  ext = {
    config = {
      storage = {
        disk.vdb.clear = true;
        disk.vdb.initlabel = true;

        partition.boot.size.mib = 100;
        partition.boot.targetDevice = "disk.vdb";
        partition.swap.size.mib = 500;
        partition.swap.targetDevice = "disk.vdb";
        partition.nix.size.mib = 500;
        partition.nix.targetDevice = "disk.vdb";
        partition.root.size = "fill";
        partition.root.targetDevice = "disk.vdb";
      };

      fileSystems."/boot" = {
        label = "boot";
        fsType = "ext2";
        storage = "partition.boot";
      };

      fileSystems."/nix" = {
        label = "nix";
        fsType = "ext3";
        storage = "partition.nix";
      };

      fileSystems."/" = {
        label = "root";
        fsType = "ext4";
        storage = "partition.root";
      };

      swapDevices = [
        { label = "swap"; storage = "partition.swap"; }
      ];
    };

    testScript = ''
      nixpart;
      ensurePartition("boot", "ext2");
      ensurePartition("swap", "swap");
      ensurePartition("nix", "ext3");
      ensurePartition("root", "ext4");
      ensurePartition("/dev/vdb", "boot sector");
      ensureNoPartition("vdb6");
      ensureNoPartition("vdc1");
      remountAndCheck;
      ensureMountPoint("/mnt/boot");
      ensureMountPoint("/mnt/nix");
    '';
  };

  btrfs = {
    config = {
      storage = {
        disk.vdb.clear = true;
        disk.vdb.initlabel = true;

        partition.swap1.size.mib = 500;
        partition.swap1.targetDevice = "disk.vdb";
        partition.btrfs1.size = "fill";
        partition.btrfs1.targetDevice = "disk.vdb";

        disk.vdc.clear = true;
        disk.vdc.initlabel = true;

        partition.swap2.size.mib = 500;
        partition.swap2.targetDevice = "disk.vdc";
        partition.btrfs2.size = "fill";
        partition.btrfs2.targetDevice = "disk.vdc";

        btrfs.root.data = 0;
        btrfs.root.metadata = 1;
        btrfs.root.devices = [ "partition.btrfs1" "partition.btrfs2" ];
      };

      fileSystems."/" = {
        label = "root";
        storage = "btrfs.root";
      };

      swapDevices = [
        { label = "swap1"; storage = "partition.swap1"; }
        { label = "swap2"; storage = "partition.swap2"; }
      ];
    };

    testScript = ''
      $machine->succeed("modprobe btrfs");
      nixpart;
      ensurePartition("swap1", "swap");
      ensurePartition("swap2", "swap");
      ensurePartition("/dev/vdb2", "btrfs");
      ensurePartition("/dev/vdc2", "btrfs");
      ensureNoPartition("vdb3");
      ensureNoPartition("vdc3");
      remountAndCheck;
    '';
  };

  f2fs = {
    config = {
      storage = {
        disk.vdb.clear = true;
        disk.vdb.initlabel = true;

        partition.swap.size.mib = 500;
        partition.swap.targetDevice = "disk.vdb";
        partition.boot.size.mib = 100;
        partition.boot.targetDevice = "disk.vdb";
        partition.root.size = "fill";
        partition.root.targetDevice = "disk.vdb";
      };

      fileSystems."/boot" = {
        label = "boot";
        fsType = "f2fs";
        storage = "partition.boot";
      };

      fileSystems."/" = {
        label = "root";
        fsType = "f2fs";
        storage = "partition.root";
      };

      swapDevices = [
        { label = "swap"; storage = "partition.swap"; }
      ];
    };

    testScript = ''
      $machine->succeed("modprobe f2fs");
      nixpart;
      ensurePartition("swap", "swap");
      ensurePartition("boot", "f2fs");
      ensurePartition("root", "f2fs");
      remountAndCheck;
      ensureMountPoint("/mnt/boot", "f2fs");
    '';
  };

  mdraid = {
    config = {
      storage = {
        disk.vdb.clear = true;
        disk.vdb.initlabel = true;

        partition.raid01.size.mib = 200;
        partition.raid01.targetDevice = "disk.vdb";
        partition.swap1.size.mib = 500;
        partition.swap1.targetDevice = "disk.vdb";
        partition.raid11.size = "fill";
        partition.raid11.targetDevice = "disk.vdb";

        disk.vdc.clear = true;
        disk.vdc.initlabel = true;

        partition.raid02.size.mib = 200;
        partition.raid02.targetDevice = "disk.vdc";
        partition.swap2.size.mib = 500;
        partition.swap2.targetDevice = "disk.vdc";
        partition.raid12.size = "fill";
        partition.raid12.targetDevice = "disk.vdc";

        mdraid.boot.level = 1;
        mdraid.boot.devices = [ "partition.raid01" "partition.raid02" ];

        mdraid.root.level = 1;
        mdraid.root.devices = [ "partition.raid11" "partition.raid12" ];
      };

      fileSystems."/boot" = {
        label = "boot";
        fsType = "ext3";
        storage = "mdraid.boot";
      };

      fileSystems."/" = {
        label = "root";
        fsType = "xfs";
        storage = "mdraid.root";
      };

      swapDevices = [
        { label = "swap1"; storage = "partition.swap1"; }
        { label = "swap2"; storage = "partition.swap2"; }
      ];
    };

    testScript = ''
      nixpart;
      ensurePartition("swap1", "swap");
      ensurePartition("swap2", "swap");
      ensurePartition("/dev/md0", "ext3");
      ensurePartition("/dev/md1", "xfs");
      ensureNoPartition("vdb4");
      ensureNoPartition("vdc4");
      ensureNoPartition("md2");
      remountAndCheck;
      ensureMountPoint("/mnt/boot");
    '';
  };

  raidLvmCrypt = {
    config = {
      storage = {
        disk.vdb.clear = true;
        disk.vdb.initlabel = true;

        partition.raid1.size = "fill";
        partition.raid1.targetDevice = "disk.vdb";

        disk.vdc.clear = true;
        disk.vdc.initlabel = true;

        partition.raid2.size = "fill";
        partition.raid2.targetDevice = "disk.vdc";

        mdraid.raid.level = 1;
        mdraid.raid.devices = [ "partition.raid1" "partition.raid2" ];

        /* TODO!
        luks.volroot.passphrase = "x";
        luks.volroot.targetDevice = "mdraid.raid";
        */

        volgroup.nixos.devices = [ "luks.volroot" ];

        logvol.boot.size.mib = 200;
        logvol.boot.group = "volgroup.nixos";

        logvol.swap.size.mib = 500;
        logvol.swap.group = "volgroup.nixos";

        logvol.root.size = "fill";
        logvol.root.group = "volgroup.nixos";
      };

      fileSystems."/boot" = {
        label = "boot";
        fsType = "ext3";
        storage = "logvol.boot";
      };

      fileSystems."/" = {
        label = "root";
        fsType = "ext4";
        storage = "logvol.root";
      };

      swapDevices = [
        { label = "swap"; storage = "logvol.swap"; }
      ];
    };

    testScript = ''
      nixpart;
      ensurePartition("/dev/vdb1", "data");
      ensureNoPartition("vdb2");
      ensurePartition("/dev/vdc1", "data");
      ensureNoPartition("vdc2");

      ensurePartition("/dev/md0", "luks");
      ensureNoPartition("md1");

      ensurePartition("/dev/nixos/boot", "ext3");
      ensurePartition("/dev/nixos/swap", "swap");
      ensurePartition("/dev/nixos/root", "ext4");

      remountAndCheck;
      ensureMountPoint("/mnt/boot");
    '';
  };
}
