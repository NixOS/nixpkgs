# This module creates a bootable ISO image containing the given NixOS
# configuration.  The derivation for the ISO image will be placed in
# config.system.build.isoImage.

{ config, lib, pkgs, ... }:

with lib;

let

  # The configuration file for syslinux.
  isolinuxCfg =
    ''
    SERIAL 0 38400
    UI vesamenu.c32
    MENU TITLE NixOS
    MENU BACKGROUND /isolinux/background.png

    LABEL boot
    MENU LABEL Boot NixOS
    LINUX /boot/bzImage init=${config.system.build.toplevel}/init ${toString config.boot.kernelParams}
    INITRD /boot/initrd

    LABEL chain
    MENU LABEL Boot existing OS
    COM32 chain.c32
    APPEND hd0 0

    LABEL reboot
    MENU LABEL Reboot
    COM32 reboot.c32

    LABEL poweroff
    MENU LABEL Power Off
    COM32 poweroff.c32
    '';

  # The efi boot image
  efiDir = pkgs.runCommand "efi-directory" {} ''
    mkdir -p $out/EFI/boot
    cp -v ${pkgs.gummiboot}/lib/gummiboot/gummiboot${targetArch}.efi $out/EFI/boot/boot${targetArch}.efi
    mkdir -p $out/loader/entries
    echo "title NixOS LiveCD" > $out/loader/entries/nixos-livecd.conf
    echo "linux /boot/bzImage" >> $out/loader/entries/nixos-livecd.conf
    echo "initrd /boot/initrd" >> $out/loader/entries/nixos-livecd.conf
    echo "options init=${config.system.build.toplevel}/init ${toString config.boot.kernelParams}" >> $out/loader/entries/nixos-livecd.conf
    echo "default nixos-livecd" > $out/loader/loader.conf
    echo "timeout 5" >> $out/loader/loader.conf
  '';

  efiImg = pkgs.runCommand "efi-image_eltorito" { buildInputs = [ pkgs.mtools ]; }
    ''
      #Let's hope 10M is enough
      dd bs=2048 count=5120 if=/dev/zero of="$out"
      ${pkgs.dosfstools}/sbin/mkfs.vfat "$out"
      mcopy -svi "$out" ${efiDir}/* ::
      mmd -i "$out" boot
      mcopy -v -i "$out" \
        ${config.boot.kernelPackages.kernel}/bzImage ::boot/bzImage
      mcopy -v -i "$out" \
        ${config.system.build.initialRamdisk}/initrd ::boot/initrd
    ''; # */

  targetArch = if pkgs.stdenv.isi686 then
    "ia32"
  else if pkgs.stdenv.isx86_64 then
    "x64"
  else
    throw "Unsupported architecture";

in

{
  options = {

    isoImage.isoName = mkOption {
      default = "${config.isoImage.isoName}.iso";
      description = ''
        Name of the generated ISO image file.
      '';
    };

    isoImage.isoBaseName = mkOption {
      default = "nixos";
      description = ''
        Prefix of the name of the generated ISO image file.
      '';
    };

    isoImage.compressImage = mkOption {
      default = false;
      description = ''
        Whether the ISO image should be compressed using
        <command>bzip2</command>.
      '';
    };

    isoImage.volumeID = mkOption {
      default = "NIXOS_BOOT_CD";
      description = ''
        Specifies the label or volume ID of the generated ISO image.
        Note that the label is used by stage 1 of the boot process to
        mount the CD, so it should be reasonably distinctive.
      '';
    };

    isoImage.contents = mkOption {
      example = literalExample ''
        [ { source = pkgs.memtest86 + "/memtest.bin";
            target = "boot/memtest.bin";
          }
        ]
      '';
      description = ''
        This option lists files to be copied to fixed locations in the
        generated ISO image.
      '';
    };

    isoImage.storeContents = mkOption {
      example = literalExample "[ pkgs.stdenv ]";
      description = ''
        This option lists additional derivations to be included in the
        Nix store in the generated ISO image.
      '';
    };

    isoImage.includeSystemBuildDependencies = mkOption {
      default = false;
      example = true;
      description = ''
        Set this option to include all the needed sources etc in the
        image. It significantly increases image size. Use that when
        you want to be able to keep all the sources needed to build your
        system or when you are going to install the system on a computer
        with slow on non-existent network connection.
      '';
    };

    isoImage.makeEfiBootable = mkOption {
      default = false;
      description = ''
        Whether the ISO image should be an efi-bootable volume.
      '';
    };

    isoImage.makeUsbBootable = mkOption {
      default = false;
      description = ''
        Whether the ISO image should be bootable from CD as well as USB.
      '';
    };

    isoImage.splashImage = mkOption {
      default = pkgs.fetchurl {
          url = https://raw.githubusercontent.com/NixOS/nixos-artwork/5729ab16c6a5793c10a2913b5a1b3f59b91c36ee/ideas/grub-splash/grub-nixos-1.png;
          sha256 = "43fd8ad5decf6c23c87e9026170a13588c2eba249d9013cb9f888da5e2002217";
        };
      description = ''
        The splash image to use in the bootloader.
      '';
    };

  };


  config = {

    boot.loader.grub.version = 2;

    # Don't build the GRUB menu builder script, since we don't need it
    # here and it causes a cyclic dependency.
    boot.loader.grub.enable = false;

    # !!! Hack - attributes expected by other modules.
    system.boot.loader.kernelFile = "bzImage";
    environment.systemPackages = [ pkgs.grub2 pkgs.syslinux ];

    # In stage 1 of the boot, mount the CD as the root FS by label so
    # that we don't need to know its device.  We pass the label of the
    # root filesystem on the kernel command line, rather than in
    # `fileSystems' below.  This allows CD-to-USB converters such as
    # UNetbootin to rewrite the kernel command line to pass the label or
    # UUID of the USB stick.  It would be nicer to write
    # `root=/dev/disk/by-label/...' here, but UNetbootin doesn't
    # recognise that.
    boot.kernelParams = [ "root=LABEL=${config.isoImage.volumeID}" ];

    fileSystems."/" =
      { fsType = "tmpfs";
        options = "mode=0755";
      };

    # Note that /dev/root is a symlink to the actual root device
    # specified on the kernel command line, created in the stage 1
    # init script.
    fileSystems."/iso" =
      { device = "/dev/root";
        neededForBoot = true;
        noCheck = true;
      };

    # In stage 1, mount a tmpfs on top of /nix/store (the squashfs
    # image) to make this a live CD.
    fileSystems."/nix/.ro-store" =
      { fsType = "squashfs";
        device = "/iso/nix-store.squashfs";
        options = "loop";
        neededForBoot = true;
      };

    fileSystems."/nix/.rw-store" =
      { fsType = "tmpfs";
        options = "mode=0755";
        neededForBoot = true;
      };

    fileSystems."/nix/store" =
      { fsType = "unionfs-fuse";
        device = "unionfs";
        options = "allow_other,cow,nonempty,chroot=/mnt-root,max_files=32768,hide_meta_files,dirs=/nix/.rw-store=rw:/nix/.ro-store=ro";
      };

    boot.initrd.availableKernelModules = [ "squashfs" "iso9660" "usb-storage" ];

    boot.initrd.kernelModules = [ "loop" ];

    # Closures to be copied to the Nix store on the CD, namely the init
    # script and the top-level system configuration directory.
    isoImage.storeContents =
      [ config.system.build.toplevel ] ++
      optional config.isoImage.includeSystemBuildDependencies
        config.system.build.toplevel.drvPath;

    # Create the squashfs image that contains the Nix store.
    system.build.squashfsStore = import ../../../lib/make-squashfs.nix {
      inherit (pkgs) stdenv squashfsTools perl pathsFromGraph;
      storeContents = config.isoImage.storeContents;
    };

    # Individual files to be included on the CD, outside of the Nix
    # store on the CD.
    isoImage.contents =
      [ { source = pkgs.substituteAll  {
            name = "isolinux.cfg";
            src = pkgs.writeText "isolinux.cfg-in" isolinuxCfg;
            bootRoot = "/boot";
          };
          target = "/isolinux/isolinux.cfg";
        }
        { source = config.boot.kernelPackages.kernel + "/bzImage";
          target = "/boot/bzImage";
        }
        { source = config.system.build.initialRamdisk + "/initrd";
          target = "/boot/initrd";
        }
        { source = config.system.build.squashfsStore;
          target = "/nix-store.squashfs";
        }
        { source = "${pkgs.syslinux}/share/syslinux";
          target = "/isolinux";
        }
        { source = config.isoImage.splashImage;
          target = "/isolinux/background.png";
        }
      ] ++ optionals config.isoImage.makeEfiBootable [
        { source = efiImg;
          target = "/boot/efi.img";
        }
        { source = "${efiDir}/EFI";
          target = "/EFI";
        }
        { source = "${efiDir}/loader";
          target = "/loader";
        }
      ];

    # Create the ISO image.
    system.build.isoImage = import ../../../lib/make-iso9660-image.nix ({
      inherit (pkgs) stdenv perl pathsFromGraph xorriso syslinux;

      inherit (config.isoImage) isoName compressImage volumeID contents;

      bootable = true;
      bootImage = "/isolinux/isolinux.bin";
    } // optionalAttrs config.isoImage.makeUsbBootable {
      usbBootable = true;
      isohybridMbrImage = "${pkgs.syslinux}/share/syslinux/isohdpfx.bin";
    } // optionalAttrs config.isoImage.makeEfiBootable {
      efiBootable = true;
      efiBootImage = "boot/efi.img";
    });

    boot.postBootCommands =
      ''
        # After booting, register the contents of the Nix store on the
        # CD in the Nix database in the tmpfs.
        ${config.nix.package}/bin/nix-store --load-db < /nix/store/nix-path-registration

        # nixos-rebuild also requires a "system" profile and an
        # /etc/NIXOS tag.
        touch /etc/NIXOS
        ${config.nix.package}/bin/nix-env -p /nix/var/nix/profiles/system --set /run/current-system
      '';

    # Add vfat support to the initrd to enable people to copy the
    # contents of the CD to a bootable USB stick.
    boot.initrd.supportedFilesystems = [ "vfat" ];

  };

}
