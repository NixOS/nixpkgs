# This module creates a bootable ISO image containing the given NixOS
# configuration.  The derivation for the ISO image will be placed in
# config.system.build.isoImage.

{ config, pkgs, ... }:

with pkgs.lib;

let

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
      example =
        [ { source = pkgs.memtest86 + "/memtest.bin";
            target = "boot/memtest.bin";
          }
        ];
      description = ''
        This option lists files to be copied to fixed locations in the
        generated ISO image.
      '';
    };

    isoImage.storeContents = mkOption {
      example = [pkgs.stdenv];
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


  };


  # The Grub image.
  grubImage = pkgs.runCommand "grub_eltorito" {}
    ''
      ${pkgs.grub2}/bin/grub-mkimage -O i386-pc -o tmp biosdisk iso9660 help linux linux16 chain png jpeg echo gfxmenu reboot
      cat ${pkgs.grub2}/lib/grub/*/cdboot.img tmp > $out
    ''; # */


  # The configuration file for Grub.
  grubCfg =
    ''
      set default=${builtins.toString config.boot.loader.grub.default}
      set timeout=${builtins.toString config.boot.loader.grub.timeout}

      if loadfont /boot/grub/unicode.pf2; then
        set gfxmode=640x480
        insmod gfxterm
        insmod vbe
        terminal_output gfxterm

        insmod png
        if background_image /boot/grub/splash.png; then
          set color_normal=white/black
          set color_highlight=black/white
        else
          set menu_color_normal=cyan/blue
          set menu_color_highlight=white/blue
        fi

      fi

      ${config.boot.loader.grub.extraEntries}
    '';


  # The efi boot image
  efiImg = pkgs.runCommand "efi-image_eltorito" {}
    ''
      #Let's hope 10M is enough
      dd bs=2048 count=5120 if=/dev/zero of="$out"
      ${pkgs.dosfstools}/sbin/mkfs.vfat "$out"
      ${pkgs.mtools}/bin/mmd -i "$out" efi
      ${pkgs.mtools}/bin/mmd -i "$out" efi/boot
      ${pkgs.mtools}/bin/mmd -i "$out" efi/nixos
      ${pkgs.mtools}/bin/mmd -i "$out" loader
      ${pkgs.mtools}/bin/mmd -i "$out" loader/entries
      ${pkgs.mtools}/bin/mcopy -v -i "$out" \
        ${pkgs.gummiboot}/bin/gummiboot.efi ::efi/boot/boot${targetArch}.efi
      ${pkgs.mtools}/bin/mcopy -v -i "$out" \
        ${config.boot.kernelPackages.kernel + "/bzImage"} ::bzImage
      ${pkgs.mtools}/bin/mcopy -v -i "$out" \
        ${config.system.build.initialRamdisk + "/initrd"} ::efi/nixos/initrd
      echo "title NixOS LiveCD" > boot-params
      echo "linux /bzImage" >> boot-params
      echo "initrd /efi/nixos/initrd" >> boot-params
      echo "options init=${config.system.build.toplevel}/init ${toString config.boot.kernelParams}" >> boot-params
      ${pkgs.mtools}/bin/mcopy -v -i "$out" boot-params ::loader/entries/nixos-livecd.conf
      echo "default nixos-livecd" > boot-params
      echo "timeout 5" >> boot-params
      ${pkgs.mtools}/bin/mcopy -v -i "$out" boot-params ::loader/loader.conf
    '';

  targetArch = if pkgs.stdenv.isi686 then
    "IA32"
  else if pkgs.stdenv.isx86_64 then
    "x64"
  else
    throw "Unsupported architecture";

in

{
  require = options;

  boot.loader.grub.version = 2;

  # Don't build the GRUB menu builder script, since we don't need it
  # here and it causes a cyclic dependency.
  boot.loader.grub.enable = false;

  # !!! Hack - attributes expected by other modules.
  system.boot.loader.kernelFile = "bzImage";
  environment.systemPackages = [ pkgs.grub2 ];

  # In stage 1 of the boot, mount the CD as the root FS by label so
  # that we don't need to know its device.  We pass the label of the
  # root filesystem on the kernel command line, rather than in
  # `fileSystems' below.  This allows CD-to-USB converters such as
  # UNetbootin to rewrite the kernel command line to pass the label or
  # UUID of the USB stick.  It would be nicer to write
  # `root=/dev/disk/by-label/...' here, but UNetbootin doesn't
  # recognise that.
  boot.kernelParams = [ "root=LABEL=${config.isoImage.volumeID}" ];

  # Note that /dev/root is a symlink to the actual root device
  # specified on the kernel command line, created in the stage 1 init
  # script.
  fileSystems."/".device = "/dev/root";

  fileSystems."/nix/store" =
    { fsType = "squashfs";
      device = "/nix-store.squashfs";
      options = "loop";
    };

  boot.initrd.availableKernelModules = [ "squashfs" "iso9660" ];

  boot.initrd.kernelModules = [ "loop" ];

  boot.kernelModules = pkgs.stdenv.lib.optional config.isoImage.makeEfiBootable "efivars";

  # In stage 1, mount a tmpfs on top of / (the ISO image) and
  # /nix/store (the squashfs image) to make this a live CD.
  boot.initrd.postMountCommands =
    ''
      mkdir -p /unionfs-chroot/ro-root
      mount --rbind $targetRoot /unionfs-chroot/ro-root

      mkdir /unionfs-chroot/rw-root
      mount -t tmpfs -o "mode=755" none /unionfs-chroot/rw-root
      mkdir /mnt-root-union
      unionfs -o allow_other,cow,chroot=/unionfs-chroot,max_files=32768 /rw-root=RW:/ro-root=RO /mnt-root-union
      oldTargetRoot=$targetRoot
      targetRoot=/mnt-root-union

      mkdir /unionfs-chroot/rw-store
      mount -t tmpfs -o "mode=755" none /unionfs-chroot/rw-store
      mkdir -p $oldTargetRoot/nix/store
      unionfs -o allow_other,cow,nonempty,chroot=/unionfs-chroot,max_files=32768 /rw-store=RW:/ro-root/nix/store=RO /mnt-root-union/nix/store
    '';

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
    [ { source = grubImage;
        target = "/boot/grub/grub_eltorito";
      }
      { source = pkgs.writeText "grub.cfg" grubCfg;
        target = "/boot/grub/grub.cfg";
      }
      { source = config.boot.kernelPackages.kernel + "/bzImage";
        target = "/boot/bzImage";
      }
      { source = config.system.build.initialRamdisk + "/initrd";
        target = "/boot/initrd";
      }
      { source = "${pkgs.grub2}/share/grub/unicode.pf2";
        target = "/boot/grub/unicode.pf2";
      }
      { source = config.boot.loader.grub.splashImage;
        target = "/boot/grub/splash.png";
      }
      { source = config.system.build.squashfsStore;
        target = "/nix-store.squashfs";
      }
      { # Quick hack: need a mount point for the store.
        source = pkgs.runCommand "empty" {} "ensureDir $out";
        target = "/nix/store";
      }
    ] ++ pkgs.stdenv.lib.optionals config.isoImage.makeEfiBootable [
      { source = efiImg;
        target = "/boot/efi.img";
      }
    ];

  # The Grub menu.
  boot.loader.grub.extraEntries =
    ''
      menuentry "NixOS Installer / Rescue" {
        linux /boot/bzImage init=${config.system.build.toplevel}/init ${toString config.boot.kernelParams}
        initrd /boot/initrd
      }

      menuentry "Boot from hard disk" {
        set root=(hd0)
        chainloader +1
      }
    '';

  boot.loader.grub.timeout = 10;

  # Create the ISO image.
  system.build.isoImage = import ../../../lib/make-iso9660-image.nix ({
    inherit (pkgs) stdenv perl cdrkit pathsFromGraph;

    inherit (config.isoImage) isoName compressImage volumeID contents;

    bootable = true;
    bootImage = "/boot/grub/grub_eltorito";
  } // pkgs.stdenv.lib.optionalAttrs config.isoImage.makeEfiBootable {
    efiBootable = true;
    efiBootImage = "boot/efi.img";
  });

  boot.postBootCommands =
    ''
      # After booting, register the contents of the Nix store on the
      # CD in the Nix database in the tmpfs.
      ${config.environment.nix}/bin/nix-store --load-db < /nix/store/nix-path-registration

      # nixos-rebuild also requires a "system" profile and an
      # /etc/NIXOS tag.
      touch /etc/NIXOS
      ${config.environment.nix}/bin/nix-env -p /nix/var/nix/profiles/system --set /run/current-system
    '';

  # Add vfat support to the initrd to enable people to copy the
  # contents of the CD to a bootable USB stick. Need unionfs-fuse for union mounts
  boot.initrd.supportedFilesystems = [ "vfat" "unionfs-fuse" ];
    
}
