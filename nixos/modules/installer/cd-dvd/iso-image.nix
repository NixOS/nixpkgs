# This module creates a bootable ISO image containing the given NixOS
# configuration.  The derivation for the ISO image will be placed in
# config.system.build.isoImage.

{ config, lib, pkgs, ... }:

with lib;

let
  # Timeout in syslinux is in units of 1/10 of a second.
  # null means max timeout (35996, just under 1h in 1/10 seconds)
  # 0 means disable timeout
  syslinuxTimeout = if config.boot.loader.timeout == null then
      35996
    else
      config.boot.loader.timeout * 10;

  # The configuration file for syslinux.

  # Notes on syslinux configuration and UNetbootin compatibility:
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
    SERIAL 0 115200
    TIMEOUT ${builtins.toString syslinuxTimeout}
    UI vesamenu.c32
    MENU BACKGROUND /isolinux/background.png

    ${config.isoImage.syslinuxTheme}

    DEFAULT boot

    LABEL boot
    MENU LABEL ${config.isoImage.prependToMenuLabel}${config.system.nixos.distroName} ${config.system.nixos.label}${config.isoImage.appendToMenuLabel}
    LINUX /boot/${config.system.boot.loader.kernelFile}
    APPEND init=${config.system.build.toplevel}/init ${toString config.boot.kernelParams}
    INITRD /boot/${config.system.boot.loader.initrdFile}

    # A variant to boot with 'nomodeset'
    LABEL boot-nomodeset
    MENU LABEL ${config.isoImage.prependToMenuLabel}${config.system.nixos.distroName} ${config.system.nixos.label}${config.isoImage.appendToMenuLabel} (nomodeset)
    LINUX /boot/${config.system.boot.loader.kernelFile}
    APPEND init=${config.system.build.toplevel}/init ${toString config.boot.kernelParams} nomodeset
    INITRD /boot/${config.system.boot.loader.initrdFile}

    # A variant to boot with 'copytoram'
    LABEL boot-copytoram
    MENU LABEL ${config.isoImage.prependToMenuLabel}${config.system.nixos.distroName} ${config.system.nixos.label}${config.isoImage.appendToMenuLabel} (copytoram)
    LINUX /boot/${config.system.boot.loader.kernelFile}
    APPEND init=${config.system.build.toplevel}/init ${toString config.boot.kernelParams} copytoram
    INITRD /boot/${config.system.boot.loader.initrdFile}

    # A variant to boot with verbose logging to the console
    LABEL boot-debug
    MENU LABEL ${config.isoImage.prependToMenuLabel}${config.system.nixos.distroName} ${config.system.nixos.label}${config.isoImage.appendToMenuLabel} (debug)
    LINUX /boot/${config.system.boot.loader.kernelFile}
    APPEND init=${config.system.build.toplevel}/init ${toString config.boot.kernelParams} loglevel=7
    INITRD /boot/${config.system.boot.loader.initrdFile}

    # A variant to boot with a serial console enabled
    LABEL boot-serial
    MENU LABEL ${config.isoImage.prependToMenuLabel}${config.system.nixos.distroName} ${config.system.nixos.label}${config.isoImage.appendToMenuLabel} (serial console=ttyS0,115200n8)
    LINUX /boot/${config.system.boot.loader.kernelFile}
    APPEND init=${config.system.build.toplevel}/init ${toString config.boot.kernelParams} console=ttyS0,115200n8
    INITRD /boot/${config.system.boot.loader.initrdFile}
  '';

  isolinuxMemtest86Entry = ''
    LABEL memtest
    MENU LABEL Memtest86+
    LINUX /boot/memtest.bin
    APPEND ${toString config.boot.loader.grub.memtest86.params}
  '';

  isolinuxCfg = concatStringsSep "\n"
    ([ baseIsolinuxCfg ] ++ optional config.boot.loader.grub.memtest86.enable isolinuxMemtest86Entry);

in

{
  imports = [
    ./systemd-boot-efi-image.nix
  ];

  options = {

    isoImage.isoName = mkOption {
      default = "${config.isoImage.isoBaseName}.iso";
      type = lib.types.str;
      description = lib.mdDoc ''
        Name of the generated ISO image file.
      '';
    };

    isoImage.isoBaseName = mkOption {
      default = config.system.nixos.distroId;
      type = lib.types.str;
      description = lib.mdDoc ''
        Prefix of the name of the generated ISO image file.
      '';
    };

    isoImage.compressImage = mkOption {
      default = false;
      type = lib.types.bool;
      description = lib.mdDoc ''
        Whether the ISO image should be compressed using
        {command}`zstd`.
      '';
    };

    isoImage.squashfsCompression = mkOption {
      default = with pkgs.stdenv.hostPlatform; "xz -Xdict-size 100% "
                + lib.optionalString isx86 "-Xbcj x86"
                # Untested but should also reduce size for these platforms
                + lib.optionalString isAarch "-Xbcj arm"
                + lib.optionalString (isPower && is32bit && isBigEndian) "-Xbcj powerpc"
                + lib.optionalString (isSparc) "-Xbcj sparc";
      type = lib.types.str;
      description = lib.mdDoc ''
        Compression settings to use for the squashfs nix store.
      '';
      example = "zstd -Xcompression-level 6";
    };

    isoImage.edition = mkOption {
      default = "";
      type = lib.types.str;
      description = lib.mdDoc ''
        Specifies which edition string to use in the volume ID of the generated
        ISO image.
      '';
    };

    isoImage.volumeID = mkOption {
      # nixos-$EDITION-$RELEASE-$ARCH
      default = "nixos${optionalString (config.isoImage.edition != "") "-${config.isoImage.edition}"}-${config.system.nixos.release}-${pkgs.stdenv.hostPlatform.uname.processor}";
      type = lib.types.str;
      description = lib.mdDoc ''
        Specifies the label or volume ID of the generated ISO image.
        Note that the label is used by stage 1 of the boot process to
        mount the CD, so it should be reasonably distinctive.
      '';
    };

    isoImage.contents = mkOption {
      example = literalExpression ''
        [ { source = pkgs.memtest86 + "/memtest.bin";
            target = "boot/memtest.bin";
          }
        ]
      '';
      description = lib.mdDoc ''
        This option lists files to be copied to fixed locations in the
        generated ISO image.
      '';
    };

    isoImage.storeContents = mkOption {
      example = literalExpression "[ pkgs.stdenv ]";
      description = lib.mdDoc ''
        This option lists additional derivations to be included in the
        Nix store in the generated ISO image.
      '';
    };

    isoImage.includeSystemBuildDependencies = mkOption {
      default = false;
      type = lib.types.bool;
      description = lib.mdDoc ''
        Set this option to include all the needed sources etc in the
        image. It significantly increases image size. Use that when
        you want to be able to keep all the sources needed to build your
        system or when you are going to install the system on a computer
        with slow or non-existent network connection.
      '';
    };

    isoImage.makeBiosBootable = mkOption {
      # Before this option was introduced, images were BIOS-bootable if the
      # hostPlatform was x86-based. This option is enabled by default for
      # backwards compatibility.
      #
      # Also note that syslinux package currently cannot be cross-compiled from
      # non-x86 platforms, so the default is false on non-x86 build platforms.
      default = pkgs.stdenv.buildPlatform.isx86 && pkgs.stdenv.hostPlatform.isx86;
      defaultText = lib.literalMD ''
        `true` if both build and host platforms are x86-based architectures,
        e.g. i686 and x86_64.
      '';
      type = lib.types.bool;
      description = lib.mdDoc ''
        Whether the ISO image should be a BIOS-bootable disk.
      '';
    };

    isoImage.makeEfiBootable = mkOption {
      default = false;
      type = lib.types.bool;
      description = lib.mdDoc ''
        Whether the ISO image should be an EFI-bootable volume.
      '';
    };

    isoImage.makeUsbBootable = mkOption {
      default = false;
      type = lib.types.bool;
      description = lib.mdDoc ''
        Whether the ISO image should be bootable from CD as well as USB.
      '';
    };

    isoImage.efiSplashImage = mkOption {
      default = pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/a9e05d7deb38a8e005a2b52575a3f59a63a4dba0/bootloader/efi-background.png";
          sha256 = "18lfwmp8yq923322nlb9gxrh5qikj1wsk6g5qvdh31c4h5b1538x";
        };
      description = lib.mdDoc ''
        The splash image to use in the EFI bootloader.
      '';
    };

    isoImage.splashImage = mkOption {
      default = pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/a9e05d7deb38a8e005a2b52575a3f59a63a4dba0/bootloader/isolinux/bios-boot.png";
          sha256 = "1wp822zrhbg4fgfbwkr7cbkr4labx477209agzc0hr6k62fr6rxd";
        };
      description = lib.mdDoc ''
        The splash image to use in the legacy-boot bootloader.
      '';
    };

    isoImage.grubTheme = mkOption {
      default = pkgs.nixos-grub2-theme;
      type = types.nullOr (types.either types.path types.package);
      description = lib.mdDoc ''
        The grub2 theme used for UEFI boot.
      '';
    };

    isoImage.syslinuxTheme = mkOption {
      default = ''
        MENU TITLE ${config.system.nixos.distroName}
        MENU RESOLUTION 800 600
        MENU CLEAR
        MENU ROWS 6
        MENU CMDLINEROW -4
        MENU TIMEOUTROW -3
        MENU TABMSGROW  -2
        MENU HELPMSGROW -1
        MENU HELPMSGENDROW -1
        MENU MARGIN 0

        #                                FG:AARRGGBB  BG:AARRGGBB   shadow
        MENU COLOR BORDER       30;44      #00000000    #00000000   none
        MENU COLOR SCREEN       37;40      #FF000000    #00E2E8FF   none
        MENU COLOR TABMSG       31;40      #80000000    #00000000   none
        MENU COLOR TIMEOUT      1;37;40    #FF000000    #00000000   none
        MENU COLOR TIMEOUT_MSG  37;40      #FF000000    #00000000   none
        MENU COLOR CMDMARK      1;36;40    #FF000000    #00000000   none
        MENU COLOR CMDLINE      37;40      #FF000000    #00000000   none
        MENU COLOR TITLE        1;36;44    #00000000    #00000000   none
        MENU COLOR UNSEL        37;44      #FF000000    #00000000   none
        MENU COLOR SEL          7;37;40    #FFFFFFFF    #FF5277C3   std
      '';
      type = types.str;
      description = lib.mdDoc ''
        The syslinux theme used for BIOS boot.
      '';
    };

    isoImage.prependToMenuLabel = mkOption {
      default = "";
      type = types.str;
      example = "Install ";
      description = lib.mdDoc ''
        The string to prepend before the menu label for the NixOS system.
        This will be directly prepended (without whitespace) to the NixOS version
        string, like for example if it is set to `XXX`:

        `XXXNixOS 99.99-pre666`
      '';
    };

    isoImage.appendToMenuLabel = mkOption {
      default = " Installer";
      type = types.str;
      example = " Live System";
      description = lib.mdDoc ''
        The string to append after the menu label for the NixOS system.
        This will be directly appended (without whitespace) to the NixOS version
        string, like for example if it is set to `XXX`:

        `NixOS 99.99-pre666XXX`
      '';
    };

    isoImage.graphicalGrub = mkOption {
      default = false;
      type = types.bool;
      example = true;
      description = lib.mdDoc ''
        Whether to use textmode or graphical grub.
        false means we use textmode grub.
      '';
    };

  };

  # store them in lib so we can mkImageMediaOverride the
  # entire file system layout in installation media (only)
  config.lib.isoFileSystems = {
    "/" = mkImageMediaOverride
      {
        fsType = "tmpfs";
        options = [ "mode=0755" ];
      };

    # Note that /dev/root is a symlink to the actual root device
    # specified on the kernel command line, created in the stage 1
    # init script.
    "/iso" = mkImageMediaOverride
      { device = "/dev/root";
        neededForBoot = true;
        noCheck = true;
      };

    # In stage 1, mount a tmpfs on top of /nix/store (the squashfs
    # image) to make this a live CD.
    "/nix/.ro-store" = mkImageMediaOverride
      { fsType = "squashfs";
        device = "/iso/nix-store.squashfs";
        options = [ "loop" ];
        neededForBoot = true;
      };

    "/nix/.rw-store" = mkImageMediaOverride
      { fsType = "tmpfs";
        options = [ "mode=0755" ];
        neededForBoot = true;
      };

    "/nix/store" = mkImageMediaOverride
      { fsType = "overlay";
        device = "overlay";
        options = [
          "lowerdir=/nix/.ro-store"
          "upperdir=/nix/.rw-store/store"
          "workdir=/nix/.rw-store/work"
        ];
        depends = [
          "/nix/.ro-store"
          "/nix/.rw-store/store"
          "/nix/.rw-store/work"
        ];
      };
  };

  config = {
    assertions = [
      {
        # Syslinux (and isolinux) only supports x86-based architectures.
        assertion = config.isoImage.makeBiosBootable -> pkgs.stdenv.hostPlatform.isx86;
        message = "BIOS boot is only supported on x86-based architectures.";
      }
      {
        assertion = !(stringLength config.isoImage.volumeID > 32);
        # https://wiki.osdev.org/ISO_9660#The_Primary_Volume_Descriptor
        # Volume Identifier can only be 32 bytes
        message = let
          length = stringLength config.isoImage.volumeID;
          howmany = toString length;
          toomany = toString (length - 32);
        in
        "isoImage.volumeID ${config.isoImage.volumeID} is ${howmany} characters. That is ${toomany} characters longer than the limit of 32.";
      }
    ];

    environment.systemPackages = optional (config.isoImage.makeBiosBootable) pkgs.syslinux;

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

    fileSystems = config.lib.isoFileSystems;

    boot.initrd.availableKernelModules = [ "squashfs" "iso9660" "uas" "overlay" ];

    boot.initrd.kernelModules = [ "loop" "overlay" ];

    # Closures to be copied to the Nix store on the CD, namely the init
    # script and the top-level system configuration directory.
    isoImage.storeContents =
      [ config.system.build.toplevel ] ++
      optional config.isoImage.includeSystemBuildDependencies
        config.system.build.toplevel.drvPath;

    # Create the squashfs image that contains the Nix store.
    system.build.squashfsStore = pkgs.callPackage ../../../lib/make-squashfs.nix {
      storeContents = config.isoImage.storeContents;
      comp = config.isoImage.squashfsCompression;
    };

    # Individual files to be included on the CD, outside of the Nix
    # store on the CD.
    isoImage.contents =
      [
        { source = config.boot.kernelPackages.kernel + "/" + config.system.boot.loader.kernelFile;
          target = "/boot/" + config.system.boot.loader.kernelFile;
        }
        { source = config.system.build.initialRamdisk + "/" + config.system.boot.loader.initrdFile;
          target = "/boot/" + config.system.boot.loader.initrdFile;
        }
        { source = config.system.build.squashfsStore;
          target = "/nix-store.squashfs";
        }
        { source = pkgs.writeText "version" config.system.nixos.label;
          target = "/version.txt";
        }
      ] ++ optionals (config.boot.loader.grub.memtest86.enable && config.isoImage.makeBiosBootable) [
        { source = "${pkgs.memtest86plus}/memtest.bin";
          target = "/boot/memtest.bin";
        }
      ] ++ optionals (config.isoImage.makeBiosBootable) [
        { source = config.isoImage.splashImage;
          target = "/isolinux/background.png";
        }
        { source = pkgs.substituteAll  {
            name = "isolinux.cfg";
            src = pkgs.writeText "isolinux.cfg-in" isolinuxCfg;
            bootRoot = "/boot";
          };
          target = "/isolinux/isolinux.cfg";
        }
        { source = "${pkgs.syslinux}/share/syslinux";
          target = "/isolinux";
        }
      ];

    boot.loader.timeout = 10;

    # Create the ISO image.
    system.build.isoImage = pkgs.callPackage ../../../lib/make-iso9660-image.nix ({
      inherit (config.isoImage) isoName compressImage volumeID contents;
      bootable = config.isoImage.makeBiosBootable;
      bootImage = "/isolinux/isolinux.bin";
      syslinux = if config.isoImage.makeBiosBootable then pkgs.syslinux else null;
    } // optionalAttrs (config.isoImage.makeUsbBootable && config.isoImage.makeBiosBootable) {
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
