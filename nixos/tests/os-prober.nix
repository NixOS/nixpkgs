import ./make-test.nix ({pkgs, lib, ...}:
let
  # A filesystem image with a (presumably) bootable debian
  debianImage = pkgs.vmTools.diskImageFuns.debian9i386 {
    # os-prober cannot detect systems installed on disks without a partition table
    # so we create the disk ourselves
    createRootFS = with pkgs; ''
      ${parted}/bin/parted --script /dev/vda mklabel msdos
      ${parted}/sbin/parted --script /dev/vda -- mkpart primary ext2 1M -1s
      mkdir /mnt
      ${e2fsprogs}/bin/mkfs.ext4 /dev/vda1
      ${utillinux}/bin/mount -t ext4 /dev/vda1 /mnt

      if test -e /mnt/.debug; then
        exec ${bash}/bin/sh
      fi
      touch /mnt/.debug

      mkdir /mnt/proc /mnt/dev /mnt/sys
    '';
    extraPackages = [
      # /etc/os-release
      "base-files"
      # make the disk bootable-looking
      "grub2" "linux-image-686"
    ];
    # install grub
    postInstall = ''
      ln -sf /proc/self/mounts > /etc/mtab
      PATH=/usr/bin:/bin:/usr/sbin:/sbin $chroot /mnt \
        grub-install /dev/vda --force
      PATH=/usr/bin:/bin:/usr/sbin:/sbin $chroot /mnt \
        update-grub
    '';
  };

  # options to add the disk to the test vm
  QEMU_OPTS = "-drive index=2,file=${debianImage}/disk-image.qcow2,read-only,if=virtio";

  # a part of the configuration of the test vm
  simpleConfig = {
    boot.loader.grub = {
      enable = true;
      useOSProber = true;
      device = "/dev/vda";
      # vda is a filesystem without partition table
      forceInstall = true;
    };
    nix.binaryCaches = lib.mkForce [ ];
    nix.extraOptions = ''
      hashed-mirrors =
      connect-timeout = 1
    '';
    # save some memory
    documentation.enable = false;
  };
  # /etc/nixos/configuration.nix for the vm
  configFile = pkgs.writeText "configuration.nix"  ''
    {config, pkgs, ...}: ({
    imports =
          [ ./hardware-configuration.nix
            <nixpkgs/nixos/modules/testing/test-instrumentation.nix>
          ];
    } // (builtins.fromJSON (builtins.readFile ${
      pkgs.writeText "simpleConfig.json" (builtins.toJSON simpleConfig)
    })))
  '';
in {
  name = "os-prober";

  machine = { config, pkgs, ... }: (simpleConfig // {
      imports = [ ../modules/profiles/installation-device.nix
                  ../modules/profiles/base.nix ];
      virtualisation.memorySize = 1024;
      # The test cannot access the network, so any packages
      # nixos-rebuild needs must be included in the VM.
      system.extraDependencies = with pkgs;
        [ sudo
          libxml2.bin
          libxslt.bin
          desktop-file-utils
          docbook5
          docbook_xsl_ns
          unionfs-fuse
          ntp
          nixos-artwork.wallpapers.simple-dark-gray-bottom
          perlPackages.XMLLibXML
          perlPackages.ListCompare
          shared-mime-info
          texinfo
          xorg.lndir
          grub2

          # add curl so that rather than seeing the test attempt to download
          # curl's tarball, we see what it's trying to download
          curl
        ];
  });

  testScript = ''
    # hack to add the secondary disk
    $machine->{startCommand} = "QEMU_OPTS=\"\$QEMU_OPTS \"${lib.escapeShellArg QEMU_OPTS} ".$machine->{startCommand};

    $machine->start;
    $machine->succeed("udevadm settle");
    $machine->waitForUnit("multi-user.target");

    # check that os-prober works standalone
    $machine->succeed("${pkgs.os-prober}/bin/os-prober | grep /dev/vdb1");

    # rebuild and test that debian is available in the grub menu
    $machine->succeed("nixos-generate-config");
    $machine->copyFileFromHost(
        "${configFile}",
        "/etc/nixos/configuration.nix");
    $machine->succeed("nixos-rebuild boot >&2");

    $machine->succeed("egrep 'menuentry.*debian' /boot/grub/grub.cfg");
  '';
})
