{ system ? builtins.currentSystem }:

with import ../lib/testing.nix { inherit system; };
with import ../lib/qemu-flags.nix;
with pkgs.lib;

let

  # The configuration to install.
  makeConfig = { bootLoader, grubVersion, grubDevice, grubIdentifier
               , extraConfig, forceGrubReinstallCount ? 0
               }:
    pkgs.writeText "configuration.nix" ''
      { config, lib, pkgs, modulesPath, ... }:

      { imports =
          [ ./hardware-configuration.nix
            <nixpkgs/nixos/modules/testing/test-instrumentation.nix>
          ];

        ${optionalString (bootLoader == "grub") ''
          boot.loader.grub.version = ${toString grubVersion};
          ${optionalString (grubVersion == 1) ''
            boot.loader.grub.splashImage = null;
          ''}
          boot.loader.grub.device = "${grubDevice}";
          boot.loader.grub.extraConfig = "serial; terminal_output.serial";
          boot.loader.grub.fsIdentifier = "${grubIdentifier}";

          boot.loader.grub.configurationLimit = 100 + ${toString forceGrubReinstallCount};
        ''}

        ${optionalString (bootLoader == "systemd-boot") ''
          boot.loader.systemd-boot.enable = true;
        ''}

        users.extraUsers.alice = {
          isNormalUser = true;
          home = "/home/alice";
          description = "Alice Foobar";
        };

        hardware.enableAllFirmware = lib.mkForce false;

        ${replaceChars ["\n"] ["\n  "] extraConfig}
      }
    '';


  channelContents = [ pkgs.rlwrap ];


  # The test script boots a NixOS VM, installs NixOS on an empty hard
  # disk, and then reboot from the hard disk.  It's parameterized with
  # a test script fragment `createPartitions', which must create
  # partitions and filesystems.
  testScriptFun = { bootLoader, createPartitions, grubVersion, grubDevice
                  , grubIdentifier, preBootCommands, extraConfig
                  }:
    let
      iface = if grubVersion == 1 then "ide" else "virtio";
      qemuFlags =
        (if system == "x86_64-linux" then "-m 768 " else "-m 512 ") +
        (optionalString (system == "x86_64-linux") "-cpu kvm64 ");
      hdFlags = ''hda => "vm-state-machine/machine.qcow2", hdaInterface => "${iface}", ''
        + optionalString (bootLoader == "systemd-boot") ''bios => "${pkgs.OVMF.fd}/FV/OVMF.fd", '';
    in
    ''
      $machine->start;

      # Make sure that we get a login prompt etc.
      $machine->succeed("echo hello");
      #$machine->waitForUnit('getty@tty2');
      $machine->waitForUnit("rogue");
      $machine->waitForUnit("nixos-manual");

      # Wait for hard disks to appear in /dev
      $machine->succeed("udevadm settle");

      # Partition the disk.
      ${createPartitions}

      # Create the NixOS configuration.
      $machine->succeed("nixos-generate-config --root /mnt");

      $machine->succeed("cat /mnt/etc/nixos/hardware-configuration.nix >&2");

      $machine->copyFileFromHost(
          "${ makeConfig { inherit bootLoader grubVersion grubDevice grubIdentifier extraConfig; } }",
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
      $machine = createMachine({ ${hdFlags} qemuFlags => "${qemuFlags}", name => "boot-after-install" });

      # For example to enter LUKS passphrase.
      ${preBootCommands}

      # Did /boot get mounted?
      $machine->waitForUnit("local-fs.target");

      ${if bootLoader == "grub" then
          ''$machine->succeed("test -e /boot/grub");''
        else
          ''$machine->succeed("test -e /boot/loader/loader.conf");''
      }

      # Check whether /root has correct permissions.
      $machine->succeed("stat -c '%a' /root") =~ /700/ or die;

      # Did the swap device get activated?
      # uncomment once https://bugs.freedesktop.org/show_bug.cgi?id=86930 is resolved
      $machine->waitForUnit("swap.target");
      $machine->succeed("cat /proc/swaps | grep -q /dev");

      # Check that the store is in good shape
      $machine->succeed("nix-store --verify --check-contents >&2");

      # Check whether the channel works.
      $machine->succeed("nix-env -iA nixos.procps >&2");
      $machine->succeed("type -tP ps | tee /dev/stderr") =~ /.nix-profile/
          or die "nix-env failed";

      # Check that the daemon works, and that non-root users can run builds (this will build a new profile generation through the daemon)
      $machine->succeed("su alice -l -c 'nix-env -iA nixos.procps' >&2");

      # We need to a writable nix-store on next boot.
      $machine->copyFileFromHost(
          "${ makeConfig { inherit bootLoader grubVersion grubDevice grubIdentifier extraConfig; forceGrubReinstallCount = 1; } }",
          "/etc/nixos/configuration.nix");

      # Check whether nixos-rebuild works.
      $machine->succeed("nixos-rebuild switch >&2");

      # Test nixos-option.
      $machine->succeed("nixos-option boot.initrd.kernelModules | grep virtio_console");
      $machine->succeed("nixos-option boot.initrd.kernelModules | grep 'List of modules'");
      $machine->succeed("nixos-option boot.initrd.kernelModules | grep qemu-guest.nix");

      $machine->shutdown;

      # Check whether a writable store build works
      $machine = createMachine({ ${hdFlags} qemuFlags => "${qemuFlags}", name => "rebuild-switch" });
      ${preBootCommands}
      $machine->waitForUnit("multi-user.target");
      $machine->copyFileFromHost(
          "${ makeConfig { inherit bootLoader grubVersion grubDevice grubIdentifier extraConfig; forceGrubReinstallCount = 2; } }",
          "/etc/nixos/configuration.nix");
      $machine->succeed("nixos-rebuild boot >&2");
      $machine->shutdown;

      # And just to be sure, check that the machine still boots after
      # "nixos-rebuild switch".
      $machine = createMachine({ ${hdFlags} qemuFlags => "${qemuFlags}", "boot-after-rebuild-switch" });
      ${preBootCommands}
      $machine->waitForUnit("network.target");
      $machine->shutdown;
    '';


  makeInstallerTest = name:
    { createPartitions, preBootCommands ? "", extraConfig ? ""
    , extraInstallerConfig ? {}
    , bootLoader ? "grub" # either "grub" or "systemd-boot"
    , grubVersion ? 2, grubDevice ? "/dev/vda", grubIdentifier ? "uuid"
    , enableOCR ? false, meta ? {}
    }:
    makeTest {
      inherit enableOCR;
      name = "installer-" + name;
      meta = with pkgs.stdenv.lib.maintainers; {
        # put global maintainers here, individuals go into makeInstallerTest fkt call
        maintainers = [ wkennington ] ++ (meta.maintainers or []);
      };
      nodes = {

        # The configuration of the machine used to run "nixos-install". It
        # also has a web server that simulates cache.nixos.org.
        machine =
          { config, lib, pkgs, ... }:

          { imports =
              [ ../modules/profiles/installation-device.nix
                ../modules/profiles/base.nix
                extraInstallerConfig
              ];

            virtualisation.diskSize = 8 * 1024;
            virtualisation.memorySize = 1024;
            virtualisation.writableStore = true;

            # Use a small /dev/vdb as the root disk for the
            # installer. This ensures the target disk (/dev/vda) is
            # the same during and after installation.
            virtualisation.emptyDiskImages = [ 512 ];
            virtualisation.bootDevice =
              if grubVersion == 1 then "/dev/sdb" else "/dev/vdb";
            virtualisation.qemu.diskInterface =
              if grubVersion == 1 then "scsi" else "virtio";

            boot.loader.systemd-boot.enable = mkIf (bootLoader == "systemd-boot") true;

            hardware.enableAllFirmware = mkForce false;

            # The test cannot access the network, so any packages we
            # need must be included in the VM.
            system.extraDependencies = with pkgs;
              [ sudo
                libxml2.bin
                libxslt.bin
                docbook5
                docbook5_xsl
                unionfs-fuse
                ntp
                nixos-artwork.wallpapers.gnome-dark
                perlPackages.XMLLibXML
                perlPackages.ListCompare

                # add curl so that rather than seeing the test attempt to download
                # curl's tarball, we see what it's trying to download
                curl
              ]
              ++ optional (bootLoader == "grub" && grubVersion == 1) pkgs.grub
              ++ optionals (bootLoader == "grub" && grubVersion == 2) [ pkgs.grub2 pkgs.grub2_efi ];

            nix.binaryCaches = mkForce [ ];
          };

      };

      testScript = testScriptFun {
        inherit bootLoader createPartitions preBootCommands
                grubVersion grubDevice grubIdentifier extraConfig;
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
    };

  # Simple GPT/UEFI configuration using systemd-boot with 3 partitions: ESP, swap & root filesystem
  simpleUefiGummiboot = makeInstallerTest "simpleUefiGummiboot"
    { createPartitions =
        ''
          $machine->succeed(
              "parted /dev/vda mklabel gpt",
              "parted -s /dev/vda -- mkpart ESP fat32 1M 50MiB", # /boot
              "parted -s /dev/vda -- set 1 boot on",
              "parted -s /dev/vda -- mkpart primary linux-swap 50MiB 1024MiB",
              "parted -s /dev/vda -- mkpart primary ext2 1024MiB -1MiB", # /
              "udevadm settle",
              "mkswap /dev/vda2 -L swap",
              "swapon -L swap",
              "mkfs.ext3 -L nixos /dev/vda3",
              "mount LABEL=nixos /mnt",
              "mkfs.vfat -n BOOT /dev/vda1",
              "mkdir -p /mnt/boot",
              "mount LABEL=BOOT /mnt/boot",
          );
        '';
        bootLoader = "systemd-boot";
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

  # Same as the previous, but with fat32 /boot.
  separateBootFat = makeInstallerTest "separateBootFat"
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
              "mkfs.vfat -n BOOT /dev/vda1",
              "mkdir -p /mnt/boot",
              "mount LABEL=BOOT /mnt/boot",
          );
        '';
    };

  # zfs on / with swap
  zfsroot = makeInstallerTest "zfs-root"
    {
      extraInstallerConfig = {
        boot.supportedFilesystems = [ "zfs" ];
      };

      extraConfig = ''
        boot.supportedFilesystems = [ "zfs" ];

        # Using by-uuid overrides the default of by-id, and is unique
        # to the qemu disks, as they don't produce by-id paths for
        # some reason.
        boot.zfs.devNodes = "/dev/disk/by-uuid/";
        networking.hostId = "00000000";
      '';

      createPartitions =
        ''
          $machine->succeed(
              "parted /dev/vda mklabel msdos",
              "parted /dev/vda -- mkpart primary linux-swap 1M 1024M",
              "parted /dev/vda -- mkpart primary 1024M -1s",
              "udevadm settle",

              "mkswap /dev/vda1 -L swap",
              "swapon -L swap",

              "zpool create rpool /dev/vda2",
              "zfs create -o mountpoint=legacy rpool/root",
              "mount -t zfs rpool/root /mnt",

              "udevadm settle"
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

  # Boot off an encrypted root partition
  luksroot = makeInstallerTest "luksroot"
    { createPartitions = ''
        $machine->succeed(
          "parted /dev/vda mklabel msdos",
          "parted /dev/vda -- mkpart primary ext2 1M 50MB", # /boot
          "parted /dev/vda -- mkpart primary linux-swap 50M 1024M",
          "parted /dev/vda -- mkpart primary 1024M -1s", # LUKS
          "udevadm settle",
          "mkswap /dev/vda2 -L swap",
          "swapon -L swap",
          "modprobe dm_mod dm_crypt",
          "echo -n supersecret | cryptsetup luksFormat -q /dev/vda3 -",
          "echo -n supersecret | cryptsetup luksOpen --key-file - /dev/vda3 cryptroot",
          "mkfs.ext3 -L nixos /dev/mapper/cryptroot",
          "mount LABEL=nixos /mnt",
          "mkfs.ext3 -L boot /dev/vda1",
          "mkdir -p /mnt/boot",
          "mount LABEL=boot /mnt/boot",
        );
      '';
      extraConfig = ''
        boot.kernelParams = lib.mkAfter [ "console=tty0" ];
      '';
      enableOCR = true;
      preBootCommands = ''
        $machine->start;
        $machine->waitForText(qr/Enter passphrase/);
        $machine->sendChars("supersecret\n");
      '';
    };

  swraid = makeInstallerTest "swraid"
    { createPartitions =
        ''
          $machine->succeed(
              "parted /dev/vda --"
              . " mklabel msdos"
              . " mkpart primary ext2 1M 100MB" # /boot
              . " mkpart extended 100M -1s"
              . " mkpart logical 102M 1602M" # md0 (root), first device
              . " mkpart logical 1603M 3103M" # md0 (root), second device
              . " mkpart logical 3104M 3360M" # md1 (swap), first device
              . " mkpart logical 3361M 3617M", # md1 (swap), second device
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
          );
        '';
      preBootCommands = ''
        $machine->start;
        $machine->fail("dmesg | grep 'immediate safe mode'");
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
