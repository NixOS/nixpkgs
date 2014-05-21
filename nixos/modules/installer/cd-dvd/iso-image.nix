# This module creates a bootable ISO image containing the given NixOS
# configuration.  The derivation for the ISO image will be placed in
# config.system.build.isoImage.

{ config, lib, pkgs, ... }:

with lib;

let

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
  efiDir = pkgs.runCommand "efi-directory" {} ''
    mkdir -p $out/efi/boot
    cp -v ${pkgs.gummiboot}/lib/gummiboot/gummiboot${targetArch}.efi $out/efi/boot/boot${targetArch}.efi
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


  config = {

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

    fileSystems."/" =
      { fsType = "tmpfs";
        device = "none";
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

    fileSystems."/nix/.ro-store" =
      { fsType = "squashfs";
        device = "/iso/nix-store.squashfs";
        options = "loop";
        neededForBoot = true;
      };

    fileSystems."/nix/.rw-store" =
      { fsType = "tmpfs";
        device = "none";
        options = "mode=0755";
        neededForBoot = true;
      };

    boot.initrd.availableKernelModules = [ "squashfs" "iso9660" ];

    boot.initrd.kernelModules = [ "loop" ];

    # In stage 1, mount a tmpfs on top of /nix/store (the squashfs
    # image) to make this a live CD.
    boot.initrd.postMountCommands =
      ''
        mkdir -p $targetRoot/nix/store
        unionfs -o allow_other,cow,nonempty,chroot=$targetRoot,max_files=32768 /nix/.rw-store=RW:/nix/.ro-store=RO $targetRoot/nix/store
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
        { source = pkgs.substituteAll  {
            name = "grub.cfg";
            src = pkgs.writeText "grub.cfg-in" grubCfg;
            bootRoot = "/boot";
          };
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
      ] ++ optionals config.isoImage.makeEfiBootable [
        { source = efiImg;
          target = "/boot/efi.img";
        }
        { source = "${efiDir}/efi";
          target = "/efi";
        }
        { source = "${efiDir}/loader";
          target = "/loader";
        }
      ] ++ mapAttrsToList (n: v: { source = v; target = "/boot/${n}"; }) config.boot.loader.grub.extraFiles;

    # The Grub menu.
    boot.loader.grub.extraEntries =
      ''
        menuentry "NixOS ${config.system.nixosVersion} Installer" {
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
    # contents of the CD to a bootable USB stick. Need unionfs-fuse for union mounts
    boot.initrd.supportedFilesystems = [ "vfat" "unionfs-fuse" ];

  };

}
