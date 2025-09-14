# This module creates a bootable ISO image containing the given NixOS
# configuration.  The derivation for the ISO image will be placed in
# config.system.build.isoImage.
{
  config,
  lib,
  utils,
  pkgs,
  ...
}:
let
  # Builds a single menu entry
  menuBuilderGrub2 =
    {
      name,
      class,
      image,
      params,
      initrd,
    }:
    ''
      menuentry '${name}' --class ${class} {
        # Fallback to UEFI console for boot, efifb sometimes has difficulties.
        terminal_output console

        linux ${image} \''${isoboot} ${params}
        initrd ${initrd}
      }
    '';

  # Builds all menu entries
  buildMenuGrub2 =
    {
      cfg ? config,
      params ? [ ],
    }:
    let
      menuConfig = {
        name = lib.concatStrings [
          cfg.isoImage.prependToMenuLabel
          cfg.system.nixos.distroName
          " "
          cfg.system.nixos.label
          cfg.isoImage.appendToMenuLabel
          (lib.optionalString (cfg.isoImage.configurationName != null) (" " + cfg.isoImage.configurationName))
        ];
        params = "init=${cfg.system.build.toplevel}/init ${toString cfg.boot.kernelParams} ${toString params}";
        image = "/boot/${cfg.boot.kernelPackages.kernel + "/" + cfg.system.boot.loader.kernelFile}";
        initrd = "/boot/${cfg.system.build.initialRamdisk + "/" + cfg.system.boot.loader.initrdFile}";
        class = "installer";
      };
    in
    ''
      ${lib.optionalString cfg.isoImage.showConfiguration (menuBuilderGrub2 menuConfig)}
      ${lib.concatStringsSep "\n" (
        lib.mapAttrsToList (
          specName:
          { configuration, ... }:
          buildMenuGrub2 {
            cfg = configuration;
            inherit params;
          }
        ) cfg.specialisation
      )}
    '';

  targetArch = if config.boot.loader.grub.forcei686 then "ia32" else pkgs.stdenv.hostPlatform.efiArch;

  # Timeout in syslinux is in units of 1/10 of a second.
  # null means max timeout (35996, just under 1h in 1/10 seconds)
  # 0 means disable timeout
  syslinuxTimeout =
    if config.boot.loader.timeout == null then 35996 else config.boot.loader.timeout * 10;

  # Timeout in grub is in seconds.
  # null means max timeout (infinity)
  # 0 means disable timeout
  grubEfiTimeout = if config.boot.loader.timeout == null then -1 else config.boot.loader.timeout;

  optionsSubMenus = [
    {
      title = "Copy ISO Files to RAM";
      class = "copytoram";
      params = [ "copytoram" ];
    }
    {
      title = "No modesetting";
      class = "nomodeset";
      params = [ "nomodeset" ];
    }
    {
      title = "Debug Console Output";
      class = "debug";
      params = [ "debug" ];
    }
    # If we boot into a graphical environment where X is autoran
    # and always crashes, it makes the media unusable. Allow the user
    # to disable this.
    {
      title = "Disable display-manager";
      class = "quirk-disable-displaymanager";
      params = [
        "systemd.mask=display-manager.service"
        "plymouth.enable=0"
      ];
    }
    # Some laptop and convertibles have the panel installed in an
    # inconvenient way, rotated away from the keyboard.
    # Those entries makes it easier to use the installer.
    {
      title = "Rotate framebuffer Clockwise";
      class = "rotate-90cw";
      params = [ "fbcon=rotate:1" ];
    }
    {
      title = "Rotate framebuffer Upside-Down";
      class = "rotate-180";
      params = [ "fbcon=rotate:2" ];
    }
    {
      title = "Rotate framebuffer Counter-Clockwise";
      class = "rotate-90ccw";
      params = [ "fbcon=rotate:3" ];
    }
    # Serial access is a must!
    {
      title = "Serial console=ttyS0,115200n8";
      class = "serial";
      params = [ "console=ttyS0,115200n8" ];
    }
  ];

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

  menuBuilderIsolinux =
    {
      cfg ? config,
      label,
      params ? [ ],
    }:
    ''
      ${lib.optionalString cfg.isoImage.showConfiguration ''
        LABEL ${label}
        MENU LABEL ${cfg.isoImage.prependToMenuLabel}${cfg.system.nixos.distroName} ${cfg.system.nixos.label}${cfg.isoImage.appendToMenuLabel}${
          lib.optionalString (cfg.isoImage.configurationName != null) (" " + cfg.isoImage.configurationName)
        }
        LINUX /boot/${cfg.boot.kernelPackages.kernel + "/" + cfg.system.boot.loader.kernelFile}
        APPEND init=${cfg.system.build.toplevel}/init ${toString cfg.boot.kernelParams} ${toString params}
        INITRD /boot/${cfg.system.build.initialRamdisk + "/" + cfg.system.boot.loader.initrdFile}
      ''}

      ${lib.concatStringsSep "\n\n" (
        lib.mapAttrsToList (
          name: specCfg:
          menuBuilderIsolinux {
            cfg = specCfg.configuration;
            label = "${label}-${name}";
            inherit params;
          }
        ) cfg.specialisation
      )}
    '';

  baseIsolinuxCfg = ''
    SERIAL 0 115200
    TIMEOUT ${builtins.toString syslinuxTimeout}
    UI vesamenu.c32
    MENU BACKGROUND /isolinux/background.png

    ${config.isoImage.syslinuxTheme}

    DEFAULT boot

    ${menuBuilderIsolinux { label = "boot"; }}

    MENU BEGIN Options

    ${lib.concatMapStringsSep "\n" (
      {
        title,
        class,
        params,
      }:
      ''
        MENU BEGIN ${title}
        ${menuBuilderIsolinux {
          label = "boot-${class}";
          inherit params;
        }}
        MENU END
      ''
    ) optionsSubMenus}

    MENU END
  '';

  isolinuxMemtest86Entry = ''
    LABEL memtest
    MENU LABEL Memtest86+
    LINUX /boot/memtest.bin
    APPEND ${toString config.boot.loader.grub.memtest86.params}
  '';

  isolinuxCfg = lib.concatStringsSep "\n" (
    [ baseIsolinuxCfg ] ++ lib.optional config.boot.loader.grub.memtest86.enable isolinuxMemtest86Entry
  );

  refindBinary =
    if targetArch == "x64" || targetArch == "aa64" then "refind_${targetArch}.efi" else null;

  # Setup instructions for rEFInd.
  refind =
    if refindBinary != null then
      ''
        # Adds rEFInd to the ISO.
        cp -v ${pkgs.refind}/share/refind/${refindBinary} $out/EFI/BOOT/
      ''
    else
      "# No refind for ${targetArch}";

  grubPkgs = if config.boot.loader.grub.forcei686 then pkgs.pkgsi686Linux else pkgs;

  grubMenuCfg = ''
    set textmode=${lib.boolToString (config.isoImage.forceTextMode)}

    #
    # Menu configuration
    #

    # Search using a "marker file"
    search --set=root --file /EFI/nixos-installer-image

    insmod gfxterm
    insmod png
    set gfxpayload=keep
    set gfxmode=${
      lib.concatStringsSep "," [
        # GRUB will use the first valid mode listed here.
        # `auto` will sometimes choose the smallest valid mode it detects.
        # So instead we'll list a lot of possibly valid modes :/
        #"3840x2160"
        #"2560x1440"
        "1920x1200"
        "1920x1080"
        "1366x768"
        "1280x800"
        "1280x720"
        "1200x1920"
        "1024x768"
        "800x1280"
        "800x600"
        "auto"
      ]
    }

    if [ "\$textmode" == "false" ]; then
      terminal_output gfxterm
      terminal_input  console
    else
      terminal_output console
      terminal_input  console
      # Sets colors for console term.
      set menu_color_normal=cyan/blue
      set menu_color_highlight=white/blue
    fi

    ${
      # When there is a theme configured, use it, otherwise use the background image.
      if config.isoImage.grubTheme != null then
        ''
          # Sets theme.
          set theme=(\$root)/EFI/BOOT/grub-theme/theme.txt
          # Load theme fonts
          $(find ${config.isoImage.grubTheme} -iname '*.pf2' -printf "loadfont (\$root)/EFI/BOOT/grub-theme/%P\n")
        ''
      else
        ''
          if background_image (\$root)/EFI/BOOT/efi-background.png; then
            # Black background means transparent background when there
            # is a background image set... This seems undocumented :(
            set color_normal=black/black
            set color_highlight=white/blue
          else
            # Falls back again to proper colors.
            set menu_color_normal=cyan/blue
            set menu_color_highlight=white/blue
          fi
        ''
    }

    hiddenentry 'Text mode' --hotkey 't' {
      loadfont (\$root)/EFI/BOOT/unicode.pf2
      set textmode=true
      terminal_output console
    }

    ${lib.optionalString (config.isoImage.grubTheme != null) ''
      hiddenentry 'GUI mode' --hotkey 'g' {
        $(find ${config.isoImage.grubTheme} -iname '*.pf2' -printf "loadfont (\$root)/EFI/BOOT/grub-theme/%P\n")
        set textmode=false
        terminal_output gfxterm
      }
    ''}
  '';

  # The EFI boot image.
  # Notes about grub:
  #  * Yes, the grubMenuCfg has to be repeated in all submenus. Otherwise you
  #    will get white-on-black console-like text on sub-menus. *sigh*
  efiDir =
    pkgs.runCommand "efi-directory"
      {
        nativeBuildInputs = [ pkgs.buildPackages.grub2_efi ];
        strictDeps = true;
      }
      ''
        mkdir -p $out/EFI/BOOT

        # Add a marker so GRUB can find the filesystem.
        touch $out/EFI/nixos-installer-image

        # ALWAYS required modules.
        MODULES=(
          # Basic modules for filesystems and partition schemes
          "fat"
          "iso9660"
          "part_gpt"
          "part_msdos"

          # Basic stuff
          "normal"
          "boot"
          "linux"
          "configfile"
          "loopback"
          "chain"
          "halt"

          # Allows rebooting into firmware setup interface
          "efifwsetup"

          # EFI Graphics Output Protocol
          "efi_gop"

          # User commands
          "ls"

          # System commands
          "search"
          "search_label"
          "search_fs_uuid"
          "search_fs_file"
          "echo"

          # We're not using it anymore, but we'll leave it in so it can be used
          # by user, with the console using "C"
          "serial"

          # Graphical mode stuff
          "gfxmenu"
          "gfxterm"
          "gfxterm_background"
          "gfxterm_menu"
          "test"
          "loadenv"
          "all_video"
          "videoinfo"

          # File types for graphical mode
          "png"
        )

        echo "Building GRUB with modules:"
        for mod in ''${MODULES[@]}; do
          echo " - $mod"
        done

        # Modules that may or may not be available per-platform.
        echo "Adding additional modules:"
        for mod in efi_uga; do
          if [ -f ${grubPkgs.grub2_efi}/lib/grub/${grubPkgs.grub2_efi.grubTarget}/$mod.mod ]; then
            echo " - $mod"
            MODULES+=("$mod")
          fi
        done

        # Make our own efi program, we can't rely on "grub-install" since it seems to
        # probe for devices, even with --skip-fs-probe.
        grub-mkimage \
          --directory=${grubPkgs.grub2_efi}/lib/grub/${grubPkgs.grub2_efi.grubTarget} \
          -o $out/EFI/BOOT/BOOT${lib.toUpper targetArch}.EFI \
          -p /EFI/BOOT \
          -O ${grubPkgs.grub2_efi.grubTarget} \
          ''${MODULES[@]}
        cp ${grubPkgs.grub2_efi}/share/grub/unicode.pf2 $out/EFI/BOOT/

        cat <<EOF > $out/EFI/BOOT/grub.cfg

        set timeout=${toString grubEfiTimeout}

        clear
        # This message will only be viewable on the default (UEFI) console.
        echo ""
        echo "Loading graphical boot menu..."
        echo ""
        echo "Press 't' to use the text boot menu on this console..."
        echo ""

        ${grubMenuCfg}

        # If the parameter iso_path is set, append the findiso parameter to the kernel
        # line. We need this to allow the nixos iso to be booted from grub directly.
        if [ \''${iso_path} ] ; then
          set isoboot="findiso=\''${iso_path}"
        fi

        #
        # Menu entries
        #

        ${buildMenuGrub2 { }}
        submenu "Options" --class submenu --class hidpi {
          ${grubMenuCfg}

          ${lib.concatMapStringsSep "\n" (
            {
              title,
              class,
              params,
            }:
            ''
              submenu "${title}" --class ${class} {
                ${grubMenuCfg}
                ${buildMenuGrub2 { inherit params; }}
              }
            ''
          ) optionsSubMenus}
        }

        ${lib.optionalString (refindBinary != null) ''
          # GRUB apparently cannot do "chainloader" operations on "CD".
          if [ "\$root" != "cd0" ]; then
            menuentry 'rEFInd' --class refind {
              # Force root to be the FAT partition
              # Otherwise it breaks rEFInd's boot
              search --set=root --no-floppy --fs-uuid 1234-5678
              chainloader (\$root)/EFI/BOOT/${refindBinary}
            }
          fi
        ''}
        menuentry 'Firmware Setup' --class settings {
          fwsetup
          clear
          echo ""
          echo "If you see this message, your EFI system doesn't support this feature."
          echo ""
        }
        menuentry 'Shutdown' --class shutdown {
          halt
        }
        EOF

        grub-script-check $out/EFI/BOOT/grub.cfg

        ${refind}
      '';

  efiImg =
    pkgs.runCommand "efi-image_eltorito"
      {
        nativeBuildInputs = [
          pkgs.buildPackages.mtools
          pkgs.buildPackages.libfaketime
          pkgs.buildPackages.dosfstools
        ];
        strictDeps = true;
      }
      # Be careful about determinism: du --apparent-size,
      #   dates (cp -p, touch, mcopy -m, faketime for label), IDs (mkfs.vfat -i)
      ''
        mkdir ./contents && cd ./contents
        mkdir -p ./EFI/BOOT
        cp -rp "${efiDir}"/EFI/BOOT/{grub.cfg,*.EFI,*.efi} ./EFI/BOOT

        # Rewrite dates for everything in the FS
        find . -exec touch --date=2000-01-01 {} +

        # Round up to the nearest multiple of 1MB, for more deterministic du output
        usage_size=$(( $(du -s --block-size=1M --apparent-size . | tr -cd '[:digit:]') * 1024 * 1024 ))
        # Make the image 110% as big as the files need to make up for FAT overhead
        image_size=$(( ($usage_size * 110) / 100 ))
        # Make the image fit blocks of 1M
        block_size=$((1024*1024))
        image_size=$(( ($image_size / $block_size + 1) * $block_size ))
        echo "Usage size: $usage_size"
        echo "Image size: $image_size"
        truncate --size=$image_size "$out"
        mkfs.vfat --invariant -i 12345678 -n EFIBOOT "$out"

        # Force a fixed order in mcopy for better determinism, and avoid file globbing
        for d in $(find EFI -type d | sort); do
          faketime "2000-01-01 00:00:00" mmd -i "$out" "::/$d"
        done

        for f in $(find EFI -type f | sort); do
          mcopy -pvm -i "$out" "$f" "::/$f"
        done

        # Verify the FAT partition.
        fsck.vfat -vn "$out"
      ''; # */

in

{
  imports = [
    (lib.mkRenamedOptionModuleWith {
      sinceRelease = 2505;
      from = [
        "isoImage"
        "isoBaseName"
      ];
      to = [
        "image"
        "baseName"
      ];
    })
    (lib.mkRenamedOptionModuleWith {
      sinceRelease = 2505;
      from = [
        "isoImage"
        "isoName"
      ];
      to = [
        "image"
        "fileName"
      ];
    })
    ../../image/file-options.nix
  ];

  options = {

    isoImage.compressImage = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = ''
        Whether the ISO image should be compressed using
        {command}`zstd`.
      '';
    };

    isoImage.squashfsCompression = lib.mkOption {
      default = "zstd -Xcompression-level 19";
      type = lib.types.nullOr lib.types.str;
      description = ''
        Compression settings to use for the squashfs nix store.
        `null` disables compression.
      '';
      example = "zstd -Xcompression-level 6";
    };

    isoImage.edition = lib.mkOption {
      default = "";
      type = lib.types.str;
      description = ''
        Specifies which edition string to use in the volume ID of the generated
        ISO image.
      '';
    };

    isoImage.volumeID = lib.mkOption {
      # nixos-$EDITION-$RELEASE-$ARCH
      default = "nixos${
        lib.optionalString (config.isoImage.edition != "") "-${config.isoImage.edition}"
      }-${config.system.nixos.release}-${pkgs.stdenv.hostPlatform.uname.processor}";
      type = lib.types.str;
      description = ''
        Specifies the label or volume ID of the generated ISO image.
        Note that the label is used by stage 1 of the boot process to
        mount the CD, so it should be reasonably distinctive.
      '';
    };

    isoImage.contents = lib.mkOption {
      example = lib.literalExpression ''
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

    isoImage.storeContents = lib.mkOption {
      example = lib.literalExpression "[ pkgs.stdenv ]";
      description = ''
        This option lists additional derivations to be included in the
        Nix store in the generated ISO image.
      '';
    };

    isoImage.includeSystemBuildDependencies = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = ''
        Set this option to include all the needed sources etc in the
        image. It significantly increases image size. Use that when
        you want to be able to keep all the sources needed to build your
        system or when you are going to install the system on a computer
        with slow or non-existent network connection.
      '';
    };

    isoImage.makeBiosBootable = lib.mkOption {
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
      description = ''
        Whether the ISO image should be a BIOS-bootable disk.
      '';
    };

    isoImage.makeEfiBootable = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = ''
        Whether the ISO image should be an EFI-bootable volume.
      '';
    };

    isoImage.makeUsbBootable = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = ''
        Whether the ISO image should be bootable from CD as well as USB.
      '';
    };

    isoImage.efiSplashImage = lib.mkOption {
      default = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/a9e05d7deb38a8e005a2b52575a3f59a63a4dba0/bootloader/efi-background.png";
        sha256 = "18lfwmp8yq923322nlb9gxrh5qikj1wsk6g5qvdh31c4h5b1538x";
      };
      description = ''
        The splash image to use in the EFI bootloader.
      '';
    };

    isoImage.splashImage = lib.mkOption {
      default = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/a9e05d7deb38a8e005a2b52575a3f59a63a4dba0/bootloader/isolinux/bios-boot.png";
        sha256 = "1wp822zrhbg4fgfbwkr7cbkr4labx477209agzc0hr6k62fr6rxd";
      };
      description = ''
        The splash image to use in the legacy-boot bootloader.
      '';
    };

    isoImage.grubTheme = lib.mkOption {
      default = pkgs.nixos-grub2-theme;
      type = lib.types.nullOr (lib.types.either lib.types.path lib.types.package);
      description = ''
        The grub2 theme used for UEFI boot.
      '';
    };

    isoImage.syslinuxTheme = lib.mkOption {
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
      type = lib.types.str;
      description = ''
        The syslinux theme used for BIOS boot.
      '';
    };

    isoImage.prependToMenuLabel = lib.mkOption {
      default = "";
      type = lib.types.str;
      example = "Install ";
      description = ''
        The string to prepend before the menu label for the NixOS system.
        This will be directly prepended (without whitespace) to the NixOS version
        string, like for example if it is set to `XXX`:

        `XXXNixOS 99.99-pre666`
      '';
    };

    isoImage.appendToMenuLabel = lib.mkOption {
      default = " Installer";
      type = lib.types.str;
      example = " Live System";
      description = ''
        The string to append after the menu label for the NixOS system.
        This will be directly appended (without whitespace) to the NixOS version
        string, like for example if it is set to `XXX`:

        `NixOS 99.99-pre666XXX`
      '';
    };

    isoImage.configurationName = lib.mkOption {
      default = null;
      type = lib.types.nullOr lib.types.str;
      example = "GNOME";
      description = ''
        The name of the configuration in the title of the boot entry.
      '';
    };

    isoImage.showConfiguration = lib.mkEnableOption "show this configuration in the menu" // {
      default = true;
    };

    isoImage.forceTextMode = lib.mkOption {
      default = false;
      type = lib.types.bool;
      example = true;
      description = ''
        Whether to use text mode instead of graphical grub.
        A value of `true` means graphical mode is not tried to be used.

        This is useful for validating that graphics mode usage is not at the root cause of a problem with the iso image.

        If text mode is required off-handedly (e.g. for serial use) you can use the `T` key, after being prompted, to use text mode for the current boot.
      '';
    };

  };

  # store them in lib so we can mkImageMediaOverride the
  # entire file system layout in installation media (only)
  config.lib.isoFileSystems = {
    "/" = lib.mkImageMediaOverride {
      fsType = "tmpfs";
      options = [ "mode=0755" ];
    };

    # Note that /dev/root is a symlink to the actual root device
    # specified on the kernel command line, created in the stage 1
    # init script.
    "/iso" = lib.mkImageMediaOverride {
      device =
        if config.boot.initrd.systemd.enable then
          "/dev/disk/by-label/${config.isoImage.volumeID}"
        else
          "/dev/root";
      neededForBoot = true;
      noCheck = true;
    };

    # In stage 1, mount a tmpfs on top of /nix/store (the squashfs
    # image) to make this a live CD.
    "/nix/.ro-store" = lib.mkImageMediaOverride {
      fsType = "squashfs";
      device = "${lib.optionalString config.boot.initrd.systemd.enable "/sysroot"}/iso/nix-store.squashfs";
      options = [
        "loop"
      ]
      ++ lib.optional (config.boot.kernelPackages.kernel.kernelAtLeast "6.2") "threads=multi";
      neededForBoot = true;
    };

    "/nix/.rw-store" = lib.mkImageMediaOverride {
      fsType = "tmpfs";
      options = [ "mode=0755" ];
      neededForBoot = true;
    };

    "/nix/store" = lib.mkImageMediaOverride {
      overlay = {
        lowerdir = [ "/nix/.ro-store" ];
        upperdir = "/nix/.rw-store/store";
        workdir = "/nix/.rw-store/work";
      };
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
        assertion = !(lib.stringLength config.isoImage.volumeID > 32);
        # https://wiki.osdev.org/ISO_9660#The_Primary_Volume_Descriptor
        # Volume Identifier can only be 32 bytes
        message =
          let
            length = lib.stringLength config.isoImage.volumeID;
            howmany = toString length;
            toomany = toString (length - 32);
          in
          "isoImage.volumeID ${config.isoImage.volumeID} is ${howmany} characters. That is ${toomany} characters longer than the limit of 32.";
      }
      (
        let
          badSpecs = lib.filterAttrs (
            specName: specCfg: specCfg.configuration.isoImage.volumeID != config.isoImage.volumeID
          ) config.specialisation;
        in
        {
          assertion = badSpecs == { };
          message = ''
            All specialisations must use the same 'isoImage.volumeID'.

            Specialisations with different volumeIDs:

            ${lib.concatMapStringsSep "\n" (specName: ''
              - ${specName}
            '') (builtins.attrNames badSpecs)}
          '';
        }
      )
    ];

    # Don't build the GRUB menu builder script, since we don't need it
    # here and it causes a cyclic dependency.
    boot.loader.grub.enable = lib.mkImageMediaOverride false;

    environment.systemPackages = [
      grubPkgs.grub2
    ]
    ++ lib.optional (config.isoImage.makeBiosBootable) pkgs.syslinux;
    system.extraDependencies = [ grubPkgs.grub2_efi ];

    # In stage 1 of the boot, mount the CD as the root FS by label so
    # that we don't need to know its device.  We pass the label of the
    # root filesystem on the kernel command line, rather than in
    # `fileSystems' below.  This allows CD-to-USB converters such as
    # UNetbootin to rewrite the kernel command line to pass the label or
    # UUID of the USB stick.  It would be nicer to write
    # `root=/dev/disk/by-label/...' here, but UNetbootin doesn't
    # recognise that.
    boot.kernelParams = lib.optionals (!config.boot.initrd.systemd.enable) [
      "boot.shell_on_fail"
      "root=LABEL=${config.isoImage.volumeID}"
    ];

    fileSystems = config.lib.isoFileSystems;

    boot.initrd.availableKernelModules = [
      "squashfs"
      "iso9660"
      "uas"
      "overlay"
    ];

    boot.initrd.kernelModules = [
      "loop"
      "overlay"
    ];

    boot.initrd.systemd = lib.mkIf config.boot.initrd.systemd.enable {
      emergencyAccess = true;

      # Most of util-linux is not included by default.
      initrdBin = [ config.boot.initrd.systemd.package.util-linux ];
      services.copytoram = {
        description = "Copy ISO contents to RAM";
        requiredBy = [ "initrd.target" ];
        before = [
          "${utils.escapeSystemdPath "/sysroot/nix/.ro-store"}.mount"
          "initrd-switch-root.target"
        ];
        unitConfig = {
          RequiresMountsFor = "/sysroot/iso";
          ConditionKernelCommandLine = "copytoram";
        };
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };
        path = [
          pkgs.coreutils
          config.boot.initrd.systemd.package.util-linux
        ];
        script = ''
          device=$(findmnt -n -o SOURCE --target /sysroot/iso)
          fsSize=$(blockdev --getsize64 "$device" || stat -Lc '%s' "$device")
          mkdir -p /tmp-iso
          mount --bind --make-private /sysroot/iso /tmp-iso
          umount /sysroot/iso
          mount -t tmpfs -o size="$fsSize" tmpfs /sysroot/iso
          cp -r /tmp-iso/* /sysroot/iso/
          umount /tmp-iso
          rm -r /tmp-iso
        '';
      };
    };

    # Closures to be copied to the Nix store on the CD, namely the init
    # script and the top-level system configuration directory.
    isoImage.storeContents = [
      config.system.build.toplevel
    ]
    ++ lib.optional config.isoImage.includeSystemBuildDependencies config.system.build.toplevel.drvPath;

    # Individual files to be included on the CD, outside of the Nix
    # store on the CD.
    isoImage.contents =
      let
        cfgFiles =
          cfg:
          lib.optionals cfg.isoImage.showConfiguration ([
            {
              source = cfg.boot.kernelPackages.kernel + "/" + cfg.system.boot.loader.kernelFile;
              target = "/boot/" + cfg.boot.kernelPackages.kernel + "/" + cfg.system.boot.loader.kernelFile;
            }
            {
              source = cfg.system.build.initialRamdisk + "/" + cfg.system.boot.loader.initrdFile;
              target = "/boot/" + cfg.system.build.initialRamdisk + "/" + cfg.system.boot.loader.initrdFile;
            }
          ])
          ++ lib.concatLists (
            lib.mapAttrsToList (_: { configuration, ... }: cfgFiles configuration) cfg.specialisation
          );
      in
      [
        {
          source = pkgs.writeText "version" config.system.nixos.label;
          target = "/version.txt";
        }
      ]
      ++ lib.unique (cfgFiles config)
      ++ lib.optionals (config.isoImage.makeBiosBootable) [
        {
          source = config.isoImage.splashImage;
          target = "/isolinux/background.png";
        }
        {
          source = pkgs.writeText "isolinux.cfg" isolinuxCfg;
          target = "/isolinux/isolinux.cfg";
        }
        {
          source = "${pkgs.syslinux}/share/syslinux";
          target = "/isolinux";
        }
      ]
      ++ lib.optionals config.isoImage.makeEfiBootable [
        {
          source = efiImg;
          target = "/boot/efi.img";
        }
        {
          source = "${efiDir}/EFI";
          target = "/EFI";
        }
        {
          source = config.isoImage.efiSplashImage;
          target = "/EFI/BOOT/efi-background.png";
        }
      ]
      ++ lib.optionals (config.isoImage.makeEfiBootable && !config.boot.initrd.systemd.enable) [
        # http://www.supergrubdisk.org/wiki/Loopback.cfg
        # This feature will be removed, and thus is not supported by systemd initrd
        {
          source = (pkgs.writeTextDir "grub/loopback.cfg" "source /EFI/BOOT/grub.cfg") + "/grub";
          target = "/boot/grub";
        }
      ]
      ++ lib.optionals (config.boot.loader.grub.memtest86.enable && config.isoImage.makeBiosBootable) [
        {
          source = "${pkgs.memtest86plus}/memtest.bin";
          target = "/boot/memtest.bin";
        }
      ]
      ++ lib.optionals (config.isoImage.grubTheme != null) [
        {
          source = config.isoImage.grubTheme;
          target = "/EFI/BOOT/grub-theme";
        }
      ];

    boot.loader.timeout = 10;

    # Create the ISO image.
    image.extension = if config.isoImage.compressImage then "iso.zst" else "iso";
    image.filePath = "iso/${config.image.fileName}";
    image.baseName = "nixos${
      lib.optionalString (config.isoImage.edition != "") "-${config.isoImage.edition}"
    }-${config.system.nixos.label}-${pkgs.stdenv.hostPlatform.system}";
    system.build.image = config.system.build.isoImage;
    system.build.isoImage = pkgs.callPackage ../../../lib/make-iso9660-image.nix (
      {
        inherit (config.isoImage) compressImage volumeID contents;
        isoName = "${config.image.baseName}.iso";
        bootable = config.isoImage.makeBiosBootable;
        bootImage = "/isolinux/isolinux.bin";
        syslinux = if config.isoImage.makeBiosBootable then pkgs.syslinux else null;
        squashfsContents = config.isoImage.storeContents;
        squashfsCompression = config.isoImage.squashfsCompression;
      }
      // lib.optionalAttrs (config.isoImage.makeUsbBootable && config.isoImage.makeBiosBootable) {
        usbBootable = true;
        isohybridMbrImage = "${pkgs.syslinux}/share/syslinux/isohdpfx.bin";
      }
      // lib.optionalAttrs config.isoImage.makeEfiBootable {
        efiBootable = true;
        efiBootImage = "boot/efi.img";
      }
    );

    boot.postBootCommands = ''
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
