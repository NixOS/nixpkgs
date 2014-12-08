{ system ? builtins.currentSystem }:

with import ../lib/testing.nix { inherit system; };
with import ../lib/qemu-flags.nix;
with pkgs.lib;

let

  # Build the ISO.  This is the regular minimal installation CD but
  # with test instrumentation.
  iso =
    (import ../lib/eval-config.nix {
      inherit system;
      modules =
        [ ../modules/installer/cd-dvd/installation-cd-minimal.nix
          ../modules/testing/test-instrumentation.nix
          { key = "serial";
            boot.loader.grub.timeout = mkOverride 0 0;

            # The test cannot access the network, so any sources we
            # need must be included in the ISO.
            isoImage.storeContents =
              [ pkgs.glibcLocales
                pkgs.sudo
                pkgs.docbook5
                pkgs.docbook5_xsl
                pkgs.grub
                pkgs.perlPackages.XMLLibXML
                pkgs.unionfs-fuse
                pkgs.gummiboot
              ];
          }
        ];
    }).config.system.build.isoImage;


  # The configuration to install.
  makeConfig = { testChannel, grubVersion, grubDevice, grubIdentifier
    , readOnly ? true, forceGrubReinstallCount ? 0 }:
    pkgs.writeText "configuration.nix" ''
      { config, lib, pkgs, modulesPath, ... }:

      { imports =
          [ ./hardware-configuration.nix
            <nixpkgs/nixos/modules/testing/test-instrumentation.nix>
            <nixpkgs/nixos/modules/profiles/minimal.nix>
          ];

        boot.loader.grub.version = ${toString grubVersion};
        ${optionalString (grubVersion == 1) ''
          boot.loader.grub.splashImage = null;
        ''}
        boot.loader.grub.device = "${grubDevice}";
        boot.loader.grub.extraConfig = "serial; terminal_output.serial";
        boot.loader.grub.fsIdentifier = "${grubIdentifier}";

        boot.loader.grub.configurationLimit = 100 + ${toString forceGrubReinstallCount};

        ${optionalString (!readOnly) "nix.readOnlyStore = false;"}

        environment.systemPackages = [ ${optionalString testChannel "pkgs.rlwrap"} ];
      }
    '';


  # Configuration of a web server that simulates the Nixpkgs channel
  # distribution server.
  webserver =
    { config, lib, pkgs, ... }:

    { services.httpd.enable = true;
      services.httpd.adminAddr = "foo@example.org";
      services.httpd.servedDirs = singleton
        { urlPath = "/";
          dir = "/tmp/channel";
        };

      virtualisation.writableStore = true;
      virtualisation.pathsInNixDB = channelContents ++ [ pkgs.hello.src ];
      virtualisation.memorySize = 768;

      networking.firewall.allowedTCPPorts = [ 80 ];
    };

  channelContents = [ pkgs.rlwrap ];


  efiBios = pkgs.runCommand "ovmf-bios" {} ''
    mkdir $out
    ln -s ${pkgs.OVMF}/FV/OVMF.fd $out/bios.bin
  '';


  # The test script boots the CD, installs NixOS on an empty hard
  # disk, and then reboot from the hard disk.  It's parameterized with
  # a test script fragment `createPartitions', which must create
  # partitions and filesystems.
  testScriptFun = { createPartitions, testChannel, grubVersion, grubDevice, grubIdentifier }:
    let
      # FIXME: OVMF doesn't boot from virtio http://www.mail-archive.com/edk2-devel@lists.sourceforge.net/msg01501.html
      iface = if grubVersion == 1 then "scsi" else "virtio";
      qemuFlags =
        (if iso.system == "x86_64-linux" then "-m 768 " else "-m 512 ") +
        (optionalString (iso.system == "x86_64-linux") "-cpu kvm64 ");
      hdFlags =''hda => "harddisk", hdaInterface => "${iface}", '';
    in
    ''
      createDisk("harddisk", 4 * 1024);

      my $machine = createMachine({ ${hdFlags}
        cdrom => glob("${iso}/iso/*.iso"),
        qemuFlags => "${qemuFlags} " . '${optionalString testChannel (toString (qemuNICFlags 1 1 2))}' });
      $machine->start;

      ${optionalString testChannel ''
        # Create a channel on the web server containing a few packages
        # to simulate the Nixpkgs channel.
        $webserver->start;
        $webserver->waitForUnit("httpd");
        $webserver->succeed(
            "nix-push --bzip2 --dest /tmp/channel --manifest --url-prefix http://nixos.org/channels/nixos-unstable " .
            "${toString channelContents} >&2");
        $webserver->succeed("mkdir /tmp/channel/sha256");
        $webserver->succeed("cp ${pkgs.hello.src} /tmp/channel/sha256/${pkgs.hello.src.outputHash}");
      ''}

      # Make sure that we get a login prompt etc.
      $machine->succeed("echo hello");
      #$machine->waitForUnit('getty@tty2');
      $machine->waitForUnit("rogue");
      $machine->waitForUnit("nixos-manual");

      ${optionalString testChannel ''
        $machine->waitForUnit("dhcpcd");

        # Allow the machine to talk to the fake nixos.org.
        $machine->succeed(
            "rm /etc/hosts",
            "echo 192.168.1.1 nixos.org cache.nixos.org tarballs.nixos.org > /etc/hosts",
            "ifconfig eth1 up 192.168.1.2",
        );

        # Test nix-env.
        $machine->fail("hello");
        $machine->succeed("nix-env -i hello");
        $machine->succeed("hello") =~ /Hello, world/
            or die "bad `hello' output";
      ''}

      # Wait for hard disks to appear in /dev
      $machine->succeed("udevadm settle");

      # Partition the disk.
      ${createPartitions}

      # Create the NixOS configuration.
      $machine->succeed(
          "nixos-generate-config --root /mnt",
      );

      $machine->succeed("cat /mnt/etc/nixos/hardware-configuration.nix >&2");

      $machine->copyFileFromHost(
          "${ makeConfig { inherit testChannel grubVersion grubDevice grubIdentifier; } }",
          "/mnt/etc/nixos/configuration.nix");

      # Perform the installation.
      $machine->succeed("nixos-install < /dev/null >&2");

      # Do it again to make sure it's idempotent.
      $machine->succeed("nixos-install < /dev/null >&2");

      $machine->succeed("umount /mnt/boot || true");
      $machine->succeed("umount /mnt");
      $machine->succeed("sync");

      $machine->shutdown;

      # Now see if we can boot the installation.
      $machine = createMachine({ ${hdFlags} qemuFlags => "${qemuFlags}" });

      # Did /boot get mounted?
      $machine->waitForUnit("local-fs.target");

      $machine->succeed("test -e /boot/grub");

      # Did the swap device get activated?
      # uncomment once https://bugs.freedesktop.org/show_bug.cgi?id=86930 is resolved
      #$machine->waitForUnit("swap.target");
      $machine->waitUntilSucceeds("cat /proc/swaps | grep -q /dev");

      # Check whether the channel works.
      $machine->succeed("nix-env -i coreutils >&2");
      $machine->succeed("type -tP ls | tee /dev/stderr") =~ /.nix-profile/
          or die "nix-env failed";

      # We need to a writable nix-store on next boot
      $machine->copyFileFromHost(
          "${ makeConfig { inherit testChannel grubVersion grubDevice grubIdentifier; readOnly = false; forceGrubReinstallCount = 1; } }",
          "/etc/nixos/configuration.nix");

      # Check whether nixos-rebuild works.
      $machine->succeed("nixos-rebuild switch >&2");

      # Test nixos-option.
      $machine->succeed("nixos-option boot.initrd.kernelModules | grep virtio_console");
      $machine->succeed("nixos-option boot.initrd.kernelModules | grep 'List of modules'");
      $machine->succeed("nixos-option  boot.initrd.kernelModules | grep qemu-guest.nix");

      $machine->shutdown;

      # Check whether a writable store build works
      $machine = createMachine({ ${hdFlags} qemuFlags => "${qemuFlags}" });
      $machine->waitForUnit("multi-user.target");
      $machine->copyFileFromHost(
          "${ makeConfig { inherit testChannel grubVersion grubDevice grubIdentifier; readOnly = false; forceGrubReinstallCount = 2; } }",
          "/etc/nixos/configuration.nix");
      $machine->succeed("nixos-rebuild boot >&2");
      $machine->shutdown;

      # And just to be sure, check that the machine still boots after
      # "nixos-rebuild switch".
      $machine = createMachine({ ${hdFlags} qemuFlags => "${qemuFlags}" });
      $machine->waitForUnit("network.target");
      $machine->shutdown;
    '';


  makeInstallerTest = name:
    { createPartitions, testChannel ? false, grubVersion ? 2, grubDevice ? "/dev/vda", grubIdentifier ? "uuid" }:
    makeTest {
      inherit iso;
      name = "installer-" + name;
      nodes = if testChannel then { inherit webserver; } else { };
      testScript = testScriptFun {
        inherit createPartitions testChannel grubVersion grubDevice grubIdentifier;
      };
    };


in {

  # !!! `parted mkpart' seems to silently create overlapping partitions.


  # The (almost) simplest partitioning scheme: a swap partition and
  # one big filesystem partition.
  simple = makeInstallerTest "simple"
    { createPartitions =
        ''
          $machine->succeed(
              "parted /dev/vda mklabel msdos",
              "parted /dev/vda -- mkpart primary linux-swap 1M 1024M",
              "parted /dev/vda -- mkpart primary ext2 1024M -1s",
              "udevadm settle",
              "mkswap /dev/vda1 -L swap",
              "swapon -L swap",
              "mkfs.ext3 -L nixos /dev/vda2",
              "mount LABEL=nixos /mnt",
          );
        '';
      testChannel = true;
    };

  # Same as the previous, but now with a separate /boot partition.
  separateBoot = makeInstallerTest "separateBoot"
    { createPartitions =
        ''
          $machine->succeed(
              "parted /dev/vda mklabel msdos",
              "parted /dev/vda -- mkpart primary ext2 1M 50MB", # /boot
              "parted /dev/vda -- mkpart primary linux-swap 50MB 1024M",
              "parted /dev/vda -- mkpart primary ext2 1024M -1s", # /
              "udevadm settle",
              "mkswap /dev/vda2 -L swap",
              "swapon -L swap",
              "mkfs.ext3 -L nixos /dev/vda3",
              "mount LABEL=nixos /mnt",
              "mkfs.ext3 -L boot /dev/vda1",
              "mkdir -p /mnt/boot",
              "mount LABEL=boot /mnt/boot",
          );
        '';
    };

  # Create two physical LVM partitions combined into one volume group
  # that contains the logical swap and root partitions.
  lvm = makeInstallerTest "lvm"
    { createPartitions =
        ''
          $machine->succeed(
              "parted /dev/vda mklabel msdos",
              "parted /dev/vda -- mkpart primary 1M 2048M", # PV1
              "parted /dev/vda -- set 1 lvm on",
              "parted /dev/vda -- mkpart primary 2048M -1s", # PV2
              "parted /dev/vda -- set 2 lvm on",
              "udevadm settle",
              "pvcreate /dev/vda1 /dev/vda2",
              "vgcreate MyVolGroup /dev/vda1 /dev/vda2",
              "lvcreate --size 1G --name swap MyVolGroup",
              "lvcreate --size 2G --name nixos MyVolGroup",
              "mkswap -f /dev/MyVolGroup/swap -L swap",
              "swapon -L swap",
              "mkfs.xfs -L nixos /dev/MyVolGroup/nixos",
              "mount LABEL=nixos /mnt",
          );
        '';
    };

  swraid = makeInstallerTest "swraid"
    { createPartitions =
        ''
          $machine->succeed(
              "parted /dev/vda --"
              . " mklabel msdos"
              . " mkpart primary ext2 1M 30MB" # /boot
              . " mkpart extended 30M -1s"
              . " mkpart logical 31M 1531M" # md0 (root), first device
              . " mkpart logical 1540M 3040M" # md0 (root), second device
              . " mkpart logical 3050M 3306M" # md1 (swap), first device
              . " mkpart logical 3320M 3576M", # md1 (swap), second device
              "udevadm settle",
              "ls -l /dev/vda* >&2",
              "cat /proc/partitions >&2",
              "mdadm --create --force /dev/md0 --metadata 1.2 --level=raid1 --raid-devices=2 /dev/vda5 /dev/vda6",
              "mdadm --create --force /dev/md1 --metadata 1.2 --level=raid1 --raid-devices=2 /dev/vda7 /dev/vda8",
              "udevadm settle",
              "mkswap -f /dev/md1 -L swap",
              "swapon -L swap",
              "mkfs.ext3 -L nixos /dev/md0",
              "mount LABEL=nixos /mnt",
              "mkfs.ext3 -L boot /dev/vda1",
              "mkdir /mnt/boot",
              "mount LABEL=boot /mnt/boot",
              "udevadm settle",
              "mdadm -W /dev/md0", # wait for sync to finish; booting off an unsynced device tends to fail
              "mdadm -W /dev/md1",
          );
        '';
    };

  # Test a basic install using GRUB 1.
  grub1 = makeInstallerTest "grub1"
    { createPartitions =
        ''
          $machine->succeed(
              "parted /dev/sda mklabel msdos",
              "parted /dev/sda -- mkpart primary linux-swap 1M 1024M",
              "parted /dev/sda -- mkpart primary ext2 1024M -1s",
              "udevadm settle",
              "mkswap /dev/sda1 -L swap",
              "swapon -L swap",
              "mkfs.ext3 -L nixos /dev/sda2",
              "mount LABEL=nixos /mnt",
          );

        '';
      grubVersion = 1;
      grubDevice = "/dev/sda";
    };

  # Rebuild the CD configuration with a little modification.
  rebuildCD = makeTest
    { inherit iso;
      name = "rebuild-cd";
      nodes = { };
      testScript =
        ''
          my $machine = createMachine({ cdrom => glob("${iso}/iso/*.iso"), qemuFlags => '-m 768' });
          $machine->start;

          # Enable sshd service.
          $machine->succeed(
            "sed -i 's,^}\$,systemd.services.sshd.wantedBy = pkgs.lib.mkOverride 0 [\"multi-user.target\"]; },' /etc/nixos/configuration.nix"
          );

          $machine->succeed("cat /etc/nixos/configuration.nix >&2");

          # Apply the new CD configuration.
          $machine->succeed("nixos-rebuild test");

          # Connect to it-self.
          $machine->waitForUnit("sshd");
          $machine->waitForOpenPort(22);

          $machine->shutdown;
        '';
    };

  # Test using labels to identify volumes in grub
  simpleLabels = makeInstallerTest "simpleLabels" {
    createPartitions = ''
      $machine->succeed(
        "sgdisk -Z /dev/vda",
        "sgdisk -n 1:0:+1M -n 2:0:+1G -N 3 -t 1:ef02 -t 2:8200 -t 3:8300 -c 3:root /dev/vda",
        "mkswap /dev/vda2 -L swap",
        "swapon -L swap",
        "mkfs.ext4 -L root /dev/vda3",
        "mount LABEL=root /mnt",
      );
    '';
    grubIdentifier = "label";
  };

  # Test using the provided disk name within grub
  # TODO: Fix udev so the symlinks are unneeded in /dev/disks
  simpleProvided = makeInstallerTest "simpleProvided" {
    createPartitions = ''
      my $UUID = "\$(blkid -s UUID -o value /dev/vda2)";
      $machine->succeed(
        "sgdisk -Z /dev/vda",
        "sgdisk -n 1:0:+1M -n 2:0:+100M -n 3:0:+1G -N 4 -t 1:ef02 -t 2:8300 -t 3:8200 -t 4:8300 -c 2:boot -c 4:root /dev/vda",
        "mkswap /dev/vda3 -L swap",
        "swapon -L swap",
        "mkfs.ext4 -L boot /dev/vda2",
        "mkfs.ext4 -L root /dev/vda4",
      );
      $machine->execute("ln -s ../../vda2 /dev/disk/by-uuid/$UUID");
      $machine->execute("ln -s ../../vda4 /dev/disk/by-label/root");
      $machine->succeed(
        "mount /dev/disk/by-label/root /mnt",
        "mkdir /mnt/boot",
        "mount /dev/disk/by-uuid/$UUID /mnt/boot"
      );
    '';
    grubIdentifier = "provided";
  };

  # Simple btrfs grub testing
  btrfsSimple = makeInstallerTest "btrfsSimple" {
    createPartitions = ''
      $machine->succeed(
        "sgdisk -Z /dev/vda",
        "sgdisk -n 1:0:+1M -n 2:0:+1G -N 3 -t 1:ef02 -t 2:8200 -t 3:8300 -c 3:root /dev/vda",
        "mkswap /dev/vda2 -L swap",
        "swapon -L swap",
        "mkfs.btrfs -L root /dev/vda3",
        "mount LABEL=root /mnt",
      );
    '';
  };

  # Test to see if we can detect /boot and /nix on subvolumes
  btrfsSubvols = makeInstallerTest "btrfsSubvols" {
    createPartitions = ''
      $machine->succeed(
        "sgdisk -Z /dev/vda",
        "sgdisk -n 1:0:+1M -n 2:0:+1G -N 3 -t 1:ef02 -t 2:8200 -t 3:8300 -c 3:root /dev/vda",
        "mkswap /dev/vda2 -L swap",
        "swapon -L swap",
        "mkfs.btrfs -L root /dev/vda3",
        "btrfs device scan",
        "mount LABEL=root /mnt",
        "btrfs subvol create /mnt/boot",
        "btrfs subvol create /mnt/nixos",
        "btrfs subvol create /mnt/nixos/default",
        "umount /mnt",
        "mount -o defaults,subvol=nixos/default LABEL=root /mnt",
        "mkdir /mnt/boot",
        "mount -o defaults,subvol=boot LABEL=root /mnt/boot",
      );
    '';
  };

  # Test to see if we can detect default and aux subvolumes correctly
  btrfsSubvolDefault = makeInstallerTest "btrfsSubvolDefault" {
    createPartitions = ''
      $machine->succeed(
        "sgdisk -Z /dev/vda",
        "sgdisk -n 1:0:+1M -n 2:0:+1G -N 3 -t 1:ef02 -t 2:8200 -t 3:8300 -c 3:root /dev/vda",
        "mkswap /dev/vda2 -L swap",
        "swapon -L swap",
        "mkfs.btrfs -L root /dev/vda3",
        "btrfs device scan",
        "mount LABEL=root /mnt",
        "btrfs subvol create /mnt/badpath",
        "btrfs subvol create /mnt/badpath/boot",
        "btrfs subvol create /mnt/nixos",
        "btrfs subvol set-default \$(btrfs subvol list /mnt | grep 'nixos' | awk '{print \$2}') /mnt",
        "umount /mnt",
        "mount -o defaults LABEL=root /mnt",
        "mkdir -p /mnt/badpath/boot", # Help ensure the detection mechanism is actually looking up subvolumes
        "mkdir /mnt/boot",
        "mount -o defaults,subvol=badpath/boot LABEL=root /mnt/boot",
      );
    '';
  };
}
