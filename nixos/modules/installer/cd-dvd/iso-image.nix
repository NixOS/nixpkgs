# This module creates a bootable ISO image containing the given NixOS
# configuration.  The derivation for the ISO image will be placed in
# config.system.build.isoImage.

{ config, lib, pkgs, ... }:

with lib;

let
  # Timeout in syslinux is in units of 1/10 of a second.
  # 0 is used to disable timeouts.
  syslinuxTimeout = if config.boot.loader.timeout == null then
      0
    else
      max (config.boot.loader.timeout * 10) 1;


  max = x: y: if x > y then x else y;

  # The configuration file for syslinux.

  # Notes on syslinux configuration and UNetbootin compatiblity:
  #   * Do not use '/syslinux/syslinux.cfg' as the path for this
  #     configuration. UNetbootin will not parse the file and use it as-is.
  #     This results in a broken configuration if the partition label does
  #     not match the specified config.isoImage.volumeID. For this reason
  #     we're using '/isolinux/isolinux.cfg'.
  #   * Use APPEND instead of adding command-line arguments directly after
  #     the LINUX entries.
  #   * COM32 entries (chainload, reboot, poweroff) are not recognized. They
  #     result in incorrect boot entries.

  baseIsolinuxCfg = ''
    SERIAL 0 38400
    TIMEOUT ${builtins.toString syslinuxTimeout}
    UI vesamenu.c32
    MENU TITLE NixOS
    MENU BACKGROUND /isolinux/background.png
    DEFAULT boot

    LABEL boot
    MENU LABEL NixOS ${config.system.nixos.label}${config.isoImage.appendToMenuLabel}
    LINUX /boot/${config.system.boot.loader.kernelFile}
    APPEND init=${config.system.build.toplevel}/init ${toString config.boot.kernelParams}
    INITRD /boot/${config.system.boot.loader.initrdFile}

    # A variant to boot with 'nomodeset'
    LABEL boot-nomodeset
    MENU LABEL NixOS ${config.system.nixos.label}${config.isoImage.appendToMenuLabel} (nomodeset)
    LINUX /boot/${config.system.boot.loader.kernelFile}
    APPEND init=${config.system.build.toplevel}/init ${toString config.boot.kernelParams} nomodeset
    INITRD /boot/${config.system.boot.loader.initrdFile}

    # A variant to boot with 'copytoram'
    LABEL boot-copytoram
    MENU LABEL NixOS ${config.system.nixos.label}${config.isoImage.appendToMenuLabel} (copytoram)
    LINUX /boot/${config.system.boot.loader.kernelFile}
    APPEND init=${config.system.build.toplevel}/init ${toString config.boot.kernelParams} copytoram
    INITRD /boot/${config.system.boot.loader.initrdFile}

    # A variant to boot with verbose logging to the console
    LABEL boot-nomodeset
    MENU LABEL NixOS ${config.system.nixos.label}${config.isoImage.appendToMenuLabel} (debug)
    LINUX /boot/${config.system.boot.loader.kernelFile}
    APPEND init=${config.system.build.toplevel}/init ${toString config.boot.kernelParams} loglevel=7
    INITRD /boot/${config.system.boot.loader.initrdFile}
  '';

  isolinuxMemtest86Entry = ''
    LABEL memtest
    MENU LABEL Memtest86+
    LINUX /boot/memtest.bin
    APPEND ${toString config.boot.loader.grub.memtest86.params}
  '';

  isolinuxCfg = baseIsolinuxCfg + (optionalString config.boot.loader.grub.memtest86.enable isolinuxMemtest86Entry);

  # The EFI boot image.
  efiDir = pkgs.runCommand "efi-directory" {} ''
    mkdir -p $out/EFI/boot
    cp -v ${pkgs.systemd}/lib/systemd/boot/efi/systemd-boot${targetArch}.efi $out/EFI/boot/boot${targetArch}.efi
    mkdir -p $out/loader/entries

    cat << EOF > $out/loader/entries/nixos-iso.conf
    title NixOS ${config.system.nixos.label}${config.isoImage.appendToMenuLabel}
    linux /boot/${config.system.boot.loader.kernelFile}
    initrd /boot/${config.system.boot.loader.initrdFile}
    options init=${config.system.build.toplevel}/init ${toString config.boot.kernelParams}
    EOF

    # A variant to boot with 'nomodeset'
    cat << EOF > $out/loader/entries/nixos-iso-nomodeset.conf
    title NixOS ${config.system.nixos.label}${config.isoImage.appendToMenuLabel}
    version nomodeset
    linux /boot/${config.system.boot.loader.kernelFile}
    initrd /boot/${config.system.boot.loader.initrdFile}
    options init=${config.system.build.toplevel}/init ${toString config.boot.kernelParams} nomodeset
    EOF

    # A variant to boot with 'copytoram'
    cat << EOF > $out/loader/entries/nixos-iso-copytoram.conf
    title NixOS ${config.system.nixos.label}${config.isoImage.appendToMenuLabel}
    version copytoram
    linux /boot/${config.system.boot.loader.kernelFile}
    initrd /boot/${config.system.boot.loader.initrdFile}
    options init=${config.system.build.toplevel}/init ${toString config.boot.kernelParams} copytoram
    EOF

    # A variant to boot with verbose logging to the console
    cat << EOF > $out/loader/entries/nixos-iso-debug.conf
    title NixOS ${config.system.nixos.label}${config.isoImage.appendToMenuLabel} (debug)
    linux /boot/${config.system.boot.loader.kernelFile}
    initrd /boot/${config.system.boot.loader.initrdFile}
    options init=${config.system.build.toplevel}/init ${toString config.boot.kernelParams} loglevel=7
    EOF

    cat << EOF > $out/loader/loader.conf
    default nixos-iso
    timeout ${builtins.toString config.boot.loader.timeout}
    EOF
  '';

  efiImg = pkgs.runCommand "efi-image_eltorito" { buildInputs = [ pkgs.mtools pkgs.libfaketime ]; }
    # Be careful about determinism: du --apparent-size,
    #   dates (cp -p, touch, mcopy -m, faketime for label), IDs (mkfs.vfat -i)
    ''
      mkdir ./contents && cd ./contents
      cp -rp "${efiDir}"/* .
      mkdir ./boot
      cp -p "${config.boot.kernelPackages.kernel}/${config.system.boot.loader.kernelFile}" \
        "${config.system.build.initialRamdisk}/${config.system.boot.loader.initrdFile}" ./boot/
      touch --date=@0 ./*

      usage_size=$(du -sb --apparent-size . | tr -cd '[:digit:]')
      # Make the image 110% as big as the files need to make up for FAT overhead
      image_size=$(( ($usage_size * 110) / 100 ))
      # Make the image fit blocks of 1M
      block_size=$((1024*1024))
      image_size=$(( ($image_size / $block_size + 1) * $block_size ))
      echo "Usage size: $usage_size"
      echo "Image size: $image_size"
      truncate --size=$image_size "$out"
      ${pkgs.libfaketime}/bin/faketime "2000-01-01 00:00:00" ${pkgs.dosfstools}/sbin/mkfs.vfat -i 12345678 -n EFIBOOT "$out"
      mcopy -bpsvm -i "$out" ./* ::
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
      default = "${config.isoImage.isoBaseName}.iso";
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
      description = ''
        Set this option to include all the needed sources etc in the
        image. It significantly increases image size. Use that when
        you want to be able to keep all the sources needed to build your
        system or when you are going to install the system on a computer
        with slow or non-existent network connection.
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

    isoImage.appendToMenuLabel = mkOption {
      default = " Installer";
      example = " Live System";
      description = ''
        The string to append after the menu label for the NixOS system.
        This will be directly appended (without whitespace) to the NixOS version
        string, like for example if it is set to <literal>XXX</literal>:

        <para><literal>NixOS 99.99-pre666XXX</literal></para>
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
    environment.systemPackages = [ pkgs.grub2 pkgs.grub2_efi pkgs.syslinux ];

    # In stage 1 of the boot, mount the CD as the root FS by label so
    # that we don't need to know its device.  We pass the label of the
    # root filesystem on the kernel command line, rather than in
    # `fileSystems' below.  This allows CD-to-USB converters such as
    # UNetbootin to rewrite the kernel command line to pass the label or
    # UUID of the USB stick.  It would be nicer to write
    # `root=/dev/disk/by-label/...' here, but UNetbootin doesn't
    # recognise that.
    boot.kernelParams =
      [ "root=LABEL=${config.isoImage.volumeID}"
        "boot.shell_on_fail"
      ];

    fileSystems."/" =
      { fsType = "tmpfs";
        options = [ "mode=0755" ];
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
        options = [ "loop" ];
        neededForBoot = true;
      };

    fileSystems."/nix/.rw-store" =
      { fsType = "tmpfs";
        options = [ "mode=0755" ];
        neededForBoot = true;
      };

    fileSystems."/nix/store" =
      { fsType = "unionfs-fuse";
        device = "unionfs";
        options = [ "allow_other" "cow" "nonempty" "chroot=/mnt-root" "max_files=32768" "hide_meta_files" "dirs=/nix/.rw-store=rw:/nix/.ro-store=ro" ];
      };

    boot.initrd.availableKernelModules = [ "squashfs" "iso9660" "usb-storage" "uas" ];

    boot.blacklistedKernelModules = [ "nouveau" ];

    boot.initrd.kernelModules = [ "loop" ];

    # Closures to be copied to the Nix store on the CD, namely the init
    # script and the top-level system configuration directory.
    isoImage.storeContents =
      [ config.system.build.toplevel ] ++
      optional config.isoImage.includeSystemBuildDependencies
        config.system.build.toplevel.drvPath;

    # Create the squashfs image that contains the Nix store.
    system.build.squashfsStore = pkgs.callPackage ../../../lib/make-squashfs.nix {
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
        { source = config.boot.kernelPackages.kernel + "/" + config.system.boot.loader.kernelFile;
          target = "/boot/" + config.system.boot.loader.kernelFile;
        }
        { source = config.system.build.initialRamdisk + "/" + config.system.boot.loader.initrdFile;
          target = "/boot/" + config.system.boot.loader.initrdFile;
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
        { source = pkgs.writeText "version" config.system.nixos.label;
          target = "/version.txt";
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
      ] ++ optionals config.boot.loader.grub.memtest86.enable [
        { source = "${pkgs.memtest86plus}/memtest.bin";
          target = "/boot/memtest.bin";
        }
      ];

    boot.loader.timeout = 10;

    # Create the ISO image.
    system.build.isoImage = pkgs.callPackage ../../../lib/make-iso9660-image.nix ({
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
        ${config.nix.package.out}/bin/nix-store --load-db < /nix/store/nix-path-registration

        # nixos-rebuild also requires a "system" profile and an
        # /etc/NIXOS tag.
        touch /etc/NIXOS
        ${config.nix.package.out}/bin/nix-env -p /nix/var/nix/profiles/system --set /run/current-system
      '';

    # Add vfat support to the initrd to enable people to copy the
    # contents of the CD to a bootable USB stick.
    boot.initrd.supportedFilesystems = [ "vfat" ];

  };

}
