{ system ? builtins.currentSystem }:

let
  inherit (import ../lib/testing.nix { inherit system; }) pkgs makeTest;

  mkStorageTest = name: attrs: makeTest {
    name = "storage-${name}";

    machine = { lib, config, pkgs, ... }: {
      imports = lib.singleton (attrs.extraMachineConfig or {});
      environment.systemPackages = [
        pkgs.nixpart pkgs.file pkgs.btrfs-progs pkgs.xfsprogs pkgs.lvm2
      ];
      virtualisation.emptyDiskImages =
        lib.genList (lib.const 4096) (attrs.diskImages or 2);
      environment.etc."nixpart.json".source = (import ../lib/eval-config.nix {
        modules = pkgs.lib.singleton attrs.config;
        inherit system;
      }).config.system.build.nixpart-spec;
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
        $machine->succeed('nixpart -v --json /etc/nixpart.json >&2');
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
          $machine->succeed('nixpart -vm --json /etc/nixpart.json >&2');
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

      ${pkgs.lib.optionalString (attrs ? prepare) ''
        $machine->nest("Preparing disks:", sub {
          $machine->succeed("${pkgs.writeScript "prepare.sh" attrs.prepare}");
        });
      ''}

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
      ensureMountPoint("/mnt");
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
      ensureMountPoint("/mnt");
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
      ensureMountPoint("/mnt");
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
      ensureMountPoint("/mnt");
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
      ensureMountPoint("/mnt");
      ensureMountPoint("/mnt/boot");
    '';
  };

  matchers = let
    # Match by sysfs path:
    match5 = "/sys/devices/pci0000:00/0000:00:0e.0/virtio11/block/vdf";

    # Match by UUID:
    match6 = "aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee";

    # Do a bit of a more complicated matching based of the number that's
    # occuring within the disk name ("match7") and walk the available
    # devices from /dev/vda to /dev/vdN until we get to the number from the
    # disk name, whilst skipping /dev/vda.
    match7 = ''
      num="''${disk//[^0-9]}"
      for i in /dev/vd?; do
        num=$((num - 1))
        if [ $num -lt 0 ]; then echo "$i"; break; fi
      done
    '';

  in {
    diskImages = 8;

    prepare = ''
      mkfs.xfs -L match2 /dev/vdc
      mkfs.xfs -m uuid=${match6} /dev/vdg
    '';

    extraMachineConfig = {
      # This is in order to fake a disk ID for match1 (/dev/vdb).
      services.udev.extraRules = ''
        KERNEL=="vdb", SUBSYSTEM=="block", SYMLINK+="disk/by-id/match1"
      '';
    };

    config = {
      storage = {
        disk.match1.match.id = "match1";      # vdb
        disk.match2.match.label = "match2";   # vdc
        disk.match3.match.name = "vdd";       # vdd
        disk.match4.match.path = "/dev/vde";  # vde
        disk.match5.match.sysfsPath = match5; # vdf
        disk.match6.match.uuid = match6;      # vdg
        disk.match7.match.script = match7;    # vdh
        disk.match8.match.physicalPos = 9;    # vdi
      };

      # This basically creates a bunch of filesystem option definitions for
      # match1 to match8.
      fileSystems = builtins.listToAttrs (builtins.genList (idx: let
        name = "match${toString (idx + 1)}";
      in {
        name = "/${name}";
        value.storage = "disk.${name}";
        value.fsType = "ext4";
        # We need to add a label here, because things like UUIDs and labels
        # that were created before the partitioning step are no longer present.
        value.label = name;
      }) 8);
    };

    testScript = ''
      nixpart;
      ensurePartition("/dev/vdb", "ext4");
      ensurePartition("/dev/vdc", "ext4");
      ensurePartition("/dev/vdd", "ext4");
      ensurePartition("/dev/vde", "ext4");
      ensurePartition("/dev/vdf", "ext4");
      ensurePartition("/dev/vdg", "ext4");
      ensurePartition("/dev/vdh", "ext4");
      ensurePartition("/dev/vdi", "ext4");

      remountAndCheck;

      ensureMountPoint("/mnt/match1");
      ensureMountPoint("/mnt/match2");
      ensureMountPoint("/mnt/match3");
      ensureMountPoint("/mnt/match4");
      ensureMountPoint("/mnt/match5");
      ensureMountPoint("/mnt/match6");
      ensureMountPoint("/mnt/match7");
      ensureMountPoint("/mnt/match8");
    '';
  };
}
