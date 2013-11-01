{ pkgs, system, ... }:

with pkgs.lib;
with import ../lib/qemu-flags.nix;

let

  # Build the ISO.  This is the regular installation CD but with test
  # instrumentation.
  iso =
    (import ../lib/eval-config.nix {
      inherit system;
      modules =
        [ ../modules/installer/cd-dvd/installation-cd-graphical.nix
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
              ];
          }
        ];
    }).config.system.build.isoImage;


  # The configuration to install.
  config = { fileSystems, testChannel, grubVersion, grubDevice }: pkgs.writeText "configuration.nix"
    ''
      { config, pkgs, modulesPath, ... }:

      { imports =
          [ ./hardware-configuration.nix
            "''${modulesPath}/testing/test-instrumentation.nix"
          ];

        boot.loader.grub.version = ${toString grubVersion};
        ${optionalString (grubVersion == 1) ''
          boot.loader.grub.splashImage = null;
        ''}
        boot.loader.grub.device = "${grubDevice}";
        boot.loader.grub.extraConfig = "serial; terminal_output.serial";
        boot.initrd.kernelModules = [ "virtio_console" ];

        environment.systemPackages = [ ${optionalString testChannel "pkgs.rlwrap"} ];
      }
    '';

  rootFS =
    ''
      fileSystems."/".device = "/dev/disk/by-label/nixos";
    '';

  bootFS =
    ''
      fileSystems."/boot".device = "/dev/disk/by-label/boot";
    '';


  # Configuration of a web server that simulates the Nixpkgs channel
  # distribution server.
  webserver =
    { config, pkgs, ... }:

    { services.httpd.enable = true;
      services.httpd.adminAddr = "foo@example.org";
      services.httpd.servedDirs = singleton
        { urlPath = "/";
          dir = "/tmp/channel";
        };

      virtualisation.writableStore = true;
      virtualisation.pathsInNixDB = channelContents ++ [ pkgs.hello.src ];
      virtualisation.memorySize = 768;
    };

  channelContents = [ pkgs.rlwrap ];


  # The test script boots the CD, installs NixOS on an empty hard
  # disk, and then reboot from the hard disk.  It's parameterized with
  # a test script fragment `createPartitions', which must create
  # partitions and filesystems, and a configuration.nix fragment
  # `fileSystems'.
  testScriptFun = { createPartitions, fileSystems, testChannel, grubVersion, grubDevice }:
    let iface = if grubVersion == 1 then "scsi" else "virtio"; in
    ''
      createDisk("harddisk", 4 * 1024);

      my $machine = createMachine({ hda => "harddisk",
        hdaInterface => "${iface}",
        cdrom => glob("${iso}/iso/*.iso"),
        qemuFlags => '${optionalString testChannel (toString (qemuNICFlags 1 1 2))} ${optionalString (pkgs.stdenv.system == "x86_64-linux") "-cpu kvm64"}'});
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
      $machine->waitForUnit("dhcpcd");

      ${optionalString testChannel ''
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

      # Partition the disk.
      ${createPartitions}

      # Create the NixOS configuration.
      $machine->succeed(
          "nixos-generate-config --root /mnt",
      );

      $machine->succeed("cat /mnt/etc/nixos/hardware-configuration.nix >&2");

      $machine->copyFileFromHost(
          "${ config { inherit fileSystems testChannel grubVersion grubDevice; } }",
          "/mnt/etc/nixos/configuration.nix");

      # Perform the installation.
      $machine->succeed("nixos-install >&2");

      # Do it again to make sure it's idempotent.
      $machine->succeed("nixos-install >&2");

      $machine->shutdown;

      # Now see if we can boot the installation.
      my $machine = createMachine({ hda => "harddisk", hdaInterface => "${iface}" });

      # Did /boot get mounted, if appropriate?
      $machine->waitForUnit("local-fs.target");
      $machine->succeed("test -e /boot/grub");

      # Did the swap device get activated?
      $machine->waitForUnit("swap.target");
      $machine->succeed("cat /proc/swaps | grep -q /dev");

      $machine->succeed("nix-env -i coreutils >&2");
      $machine->succeed("type -tP ls | tee /dev/stderr") =~ /.nix-profile/
          or die "nix-env failed";

      $machine->succeed("nixos-rebuild switch >&2");

      # Test nixos-option.
      $machine->succeed("nixos-option boot.initrd.kernelModules | grep virtio_console");
      $machine->succeed("nixos-option -d boot.initrd.kernelModules | grep 'List of modules'");
      $machine->succeed("nixos-option -l boot.initrd.kernelModules | grep /etc/nixos/configuration.nix");

      $machine->shutdown;

      # And just to be sure, check that the machine still boots after
      # "nixos-rebuild switch".
      my $machine = createMachine({ hda => "harddisk", hdaInterface => "${iface}" });
      $machine->waitForUnit("network.target");
      $machine->shutdown;
    '';


  makeTest = { createPartitions, fileSystems, testChannel ? false, grubVersion ? 2, grubDevice ? "/dev/vda" }:
    { inherit iso;
      nodes = if testChannel then { inherit webserver; } else { };
      testScript = testScriptFun {
        inherit createPartitions fileSystems testChannel grubVersion grubDevice;
      };
    };


in {

  # !!! `parted mkpart' seems to silently create overlapping partitions.


  # The (almost) simplest partitioning scheme: a swap partition and
  # one big filesystem partition.
  simple = makeTest
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
      fileSystems = rootFS;
      testChannel = true;
    };

  # Same as the previous, but now with a separate /boot partition.
  separateBoot = makeTest
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
              "mkdir /mnt/boot",
              "mount LABEL=boot /mnt/boot",
          );
        '';
      fileSystems = rootFS + bootFS;
    };

  # Create two physical LVM partitions combined into one volume group
  # that contains the logical swap and root partitions.
  lvm = makeTest
    { createPartitions =
        ''
          $machine->succeed(
              "parted /dev/vda mklabel msdos",
              "parted /dev/vda -- mkpart primary 1M 2048M", # first PV
              "parted /dev/vda -- set 1 lvm on",
              "parted /dev/vda -- mkpart primary 2048M -1s", # second PV
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
      fileSystems = rootFS;
    };

  /*
  swraid = makeTest
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
      fileSystems = rootFS + bootFS;
    };
  */

  # Test a basic install using GRUB 1.
  grub1 = makeTest
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
      fileSystems = rootFS;
      grubVersion = 1;
      grubDevice = "/dev/sda";
    };

  # Rebuild the CD configuration with a little modification.
  rebuildCD =
    { inherit iso;
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
}
