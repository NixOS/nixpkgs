import ./make-test-python.nix (
  { pkgs, lib, ... }:
  let
    # A filesystem image with a (presumably) bootable debian
    debianImage = pkgs.vmTools.diskImageFuns.debian11i386 {
      # os-prober cannot detect systems installed on disks without a partition table
      # so we create the disk ourselves
      createRootFS = with pkgs; ''
        ${parted}/bin/parted --script /dev/vda mklabel msdos
        ${parted}/sbin/parted --script /dev/vda -- mkpart primary ext2 1M -1s
        mkdir /mnt
        ${e2fsprogs}/bin/mkfs.ext4 -O '^metadata_csum_seed' /dev/vda1
        ${util-linux}/bin/mount -t ext4 /dev/vda1 /mnt

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
        "grub2"
        "linux-image-686"
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

    # a part of the configuration of the test vm
    simpleConfig = {
      boot.loader.grub = {
        enable = true;
        useOSProber = true;
        device = "/dev/vda";
        # vda is a filesystem without partition table
        forceInstall = true;
      };
      nix.settings = {
        substituters = lib.mkForce [ ];
        hashed-mirrors = null;
        connect-timeout = 1;
      };
      # save some memory
      documentation.enable = false;
    };
    # /etc/nixos/configuration.nix for the vm
    configFile = pkgs.writeText "configuration.nix" ''
      {config, pkgs, lib, ...}: ({
      imports =
            [ ./hardware-configuration.nix
              <nixpkgs/nixos/modules/testing/test-instrumentation.nix>
            ];
      } // lib.importJSON ${pkgs.writeText "simpleConfig.json" (builtins.toJSON simpleConfig)})
    '';
  in
  {
    name = "os-prober";

    nodes.machine =
      { config, pkgs, ... }:
      (
        simpleConfig
        // {
          imports = [
            ../modules/profiles/installation-device.nix
            ../modules/profiles/base.nix
          ];
          virtualisation.memorySize = 1300;
          # To add the secondary disk:
          virtualisation.qemu.options = [
            "-drive index=2,file=${debianImage}/disk-image.qcow2,read-only,if=virtio"
          ];

          # The test cannot access the network, so any packages
          # nixos-rebuild needs must be included in the VM.
          system.extraDependencies = with pkgs; [
            bintools
            brotli
            brotli.dev
            brotli.lib
            desktop-file-utils
            docbook5
            docbook_xsl_ns
            grub2
            nixos-artwork.wallpapers.simple-dark-gray-bootloader
            perlPackages.FileCopyRecursive
            perlPackages.XMLSAX
            perlPackages.XMLSAXBase
            kbd
            kbd.dev
            kmod.dev
            libarchive
            libarchive.dev
            libxml2.bin
            libxslt.bin
            nixos-artwork.wallpapers.simple-dark-gray-bottom
            perlPackages.ConfigIniFiles
            perlPackages.FileSlurp
            perlPackages.JSON
            perlPackages.ListCompare
            perlPackages.XMLLibXML
            # make-options-doc/default.nix
            (python3.withPackages (p: [ p.mistune ]))
            shared-mime-info
            sudo
            switch-to-configuration-ng
            texinfo
            unionfs-fuse
            xorg.lndir
            os-prober

            # add curl so that rather than seeing the test attempt to download
            # curl's tarball, we see what it's trying to download
            curl
          ];
        }
      );

    testScript = ''
      machine.start()
      machine.succeed("udevadm settle")
      machine.wait_for_unit("multi-user.target")
      print(machine.succeed("lsblk"))

      # check that os-prober works standalone
      machine.succeed(
          "${pkgs.os-prober}/bin/os-prober | grep /dev/vdb1"
      )

      # rebuild and test that debian is available in the grub menu
      machine.succeed("nixos-generate-config")
      machine.copy_from_host(
          "${configFile}",
          "/etc/nixos/configuration.nix",
      )
      machine.succeed("nixos-rebuild boot --show-trace >&2")

      machine.succeed("egrep 'menuentry.*debian' /boot/grub/grub.cfg")
    '';
  }
)
