{ config, options, lib, pkgs, ... }:

let
  cfg = config.boot.loader.grub;

  efi = config.boot.loader.efi;

  grubPkgs =
    # Package set of targeted architecture
    if cfg.forcei686 then pkgs.pkgsi686Linux else pkgs;

  realGrub = if cfg.zfsSupport then grubPkgs.grub2.override { zfsSupport = true; zfs = cfg.zfsPackage; }
    else grubPkgs.grub2;

  grub =
    # Don't include GRUB if we're only generating a GRUB menu (e.g.,
    # in EC2 instances).
    if cfg.devices == ["nodev"]
    then null
    else realGrub;

  grubEfi =
    if cfg.efiSupport
    then realGrub.override { efiSupport = cfg.efiSupport; }
    else null;

  f = x: lib.optionalString (x != null) ("" + x);

  grubConfig = args:
    let
      efiSysMountPoint = if args.efiSysMountPoint == null then args.path else args.efiSysMountPoint;
      efiSysMountPoint' = lib.replaceStrings [ "/" ] [ "-" ] efiSysMountPoint;
    in
    pkgs.writeText "grub-config.xml" (builtins.toXML
    { splashImage = f cfg.splashImage;
      splashMode = f cfg.splashMode;
      backgroundColor = f cfg.backgroundColor;
      entryOptions = f cfg.entryOptions;
      subEntryOptions = f cfg.subEntryOptions;
      # PC platforms (like x86_64-linux) have a non-EFI target (`grubTarget`), but other platforms
      # (like aarch64-linux) have an undefined `grubTarget`. Avoid providing the path to a non-EFI
      # GRUB on those platforms.
      grub = f (if (grub.grubTarget or "") != "" then grub else "");
      grubTarget = f (grub.grubTarget or "");
      shell = "${pkgs.runtimeShell}";
      fullName = lib.getName realGrub;
      fullVersion = lib.getVersion realGrub;
      grubEfi = f grubEfi;
      grubTargetEfi = lib.optionalString cfg.efiSupport (f (grubEfi.grubTarget or ""));
      bootPath = args.path;
      storePath = config.boot.loader.grub.storePath;
      bootloaderId = if args.efiBootloaderId == null then "${config.system.nixos.distroName}${efiSysMountPoint'}" else args.efiBootloaderId;
      timeout = if config.boot.loader.timeout == null then -1 else config.boot.loader.timeout;
      theme = f cfg.theme;
      inherit efiSysMountPoint;
      inherit (args) devices;
      inherit (efi) canTouchEfiVariables;
      inherit (cfg)
        extraConfig extraPerEntryConfig extraEntries forceInstall useOSProber
        extraGrubInstallArgs
        extraEntriesBeforeNixOS extraPrepareConfig configurationLimit copyKernels
        default fsIdentifier efiSupport efiInstallAsRemovable gfxmodeEfi gfxmodeBios gfxpayloadEfi gfxpayloadBios
        users
        timeoutStyle
      ;
      path = with pkgs; makeBinPath (
        [ coreutils gnused gnugrep findutils diffutils btrfs-progs util-linux mdadm ]
        ++ lib.optional cfg.efiSupport efibootmgr
        ++ lib.optionals cfg.useOSProber [ busybox os-prober ]);
      font = lib.optionalString (cfg.font != null) (
             if lib.last (lib.splitString "." cfg.font) == "pf2"
             then cfg.font
             else "${convertedFont}");
    });

  bootDeviceCounters = lib.foldr (device: attr: attr // { ${device} = (attr.${device} or 0) + 1; }) {}
    (lib.concatMap (args: args.devices) cfg.mirroredBoots);

  convertedFont = (pkgs.runCommand "grub-font-converted.pf2" {}
           (builtins.concatStringsSep " "
             ([ "${realGrub}/bin/grub-mkfont"
               cfg.font
               "--output" "$out"
             ] ++ (lib.optional (cfg.fontSize!=null) "--size ${toString cfg.fontSize}")))
         );

  defaultSplash = pkgs.nixos-artwork.wallpapers.simple-dark-gray-bootloader.gnomeFilePath;
in

{

  ###### interface

  options = {

    boot.loader.grub = {

      enable = lib.mkOption {
        default = !config.boot.isContainer;
        defaultText = lib.literalExpression "!config.boot.isContainer";
        type = lib.types.bool;
        description = ''
          Whether to enable the GNU GRUB boot loader.
        '';
      };

      version = lib.mkOption {
        visible = false;
        type = lib.types.int;
      };

      device = lib.mkOption {
        default = "";
        example = "/dev/disk/by-id/wwn-0x500001234567890a";
        type = lib.types.str;
        description = ''
          The device on which the GRUB boot loader will be installed.
          The special value `nodev` means that a GRUB
          boot menu will be generated, but GRUB itself will not
          actually be installed.  To install GRUB on multiple devices,
          use `boot.loader.grub.devices`.
        '';
      };

      devices = lib.mkOption {
        default = [];
        example = [ "/dev/disk/by-id/wwn-0x500001234567890a" ];
        type = lib.types.listOf lib.types.str;
        description = ''
          The devices on which the boot loader, GRUB, will be
          installed. Can be used instead of `device` to
          install GRUB onto multiple devices.
        '';
      };

      users = lib.mkOption {
        default = {};
        example = {
          root = { hashedPasswordFile = "/path/to/file"; };
        };
        description = ''
          User accounts for GRUB. When specified, the GRUB command line and
          all boot options except the default are password-protected.
          All passwords and hashes provided will be stored in /boot/grub/grub.cfg,
          and will be visible to any local user who can read this file. Additionally,
          any passwords and hashes provided directly in a Nix configuration
          (as opposed to external files) will be copied into the Nix store, and
          will be visible to all local users.
        '';
        type = lib.types.attrsOf (lib.types.submodule {
          options = {
            hashedPasswordFile = lib.mkOption {
              example = "/path/to/file";
              default = null;
              type = with lib.types; uniq (nullOr str);
              description = ''
                Specifies the path to a file containing the password hash
                for the account, generated with grub-mkpasswd-pbkdf2.
                This hash will be stored in /boot/grub/grub.cfg, and will
                be visible to any local user who can read this file.
              '';
            };
            hashedPassword = lib.mkOption {
              example = "grub.pbkdf2.sha512.10000.674DFFDEF76E13EA...2CC972B102CF4355";
              default = null;
              type = with lib.types; uniq (nullOr str);
              description = ''
                Specifies the password hash for the account,
                generated with grub-mkpasswd-pbkdf2.
                This hash will be copied to the Nix store, and will be visible to all local users.
              '';
            };
            passwordFile = lib.mkOption {
              example = "/path/to/file";
              default = null;
              type = with lib.types; uniq (nullOr str);
              description = ''
                Specifies the path to a file containing the
                clear text password for the account.
                This password will be stored in /boot/grub/grub.cfg, and will
                be visible to any local user who can read this file.
              '';
            };
            password = lib.mkOption {
              example = "Pa$$w0rd!";
              default = null;
              type = with lib.types; uniq (nullOr str);
              description = ''
                Specifies the clear text password for the account.
                This password will be copied to the Nix store, and will be visible to all local users.
              '';
            };
          };
        });
      };

      mirroredBoots = lib.mkOption {
        default = [ ];
        example = [
          { path = "/boot1"; devices = [ "/dev/disk/by-id/wwn-0x500001234567890a" ]; }
          { path = "/boot2"; devices = [ "/dev/disk/by-id/wwn-0x500009876543210a" ]; }
        ];
        description = ''
          Mirror the boot configuration to multiple partitions and install grub
          to the respective devices corresponding to those partitions.
        '';

        type = with lib.types; listOf (submodule {
          options = {

            path = lib.mkOption {
              example = "/boot1";
              type = lib.types.str;
              description = ''
                The path to the boot directory where GRUB will be written. Generally
                this boot path should double as an EFI path.
              '';
            };

            efiSysMountPoint = lib.mkOption {
              default = null;
              example = "/boot1/efi";
              type = lib.types.nullOr lib.types.str;
              description = ''
                The path to the efi system mount point. Usually this is the same
                partition as the above path and can be left as null.
              '';
            };

            efiBootloaderId = lib.mkOption {
              default = null;
              example = "NixOS-fsid";
              type = lib.types.nullOr lib.types.str;
              description = ''
                The id of the bootloader to store in efi nvram.
                The default is to name it NixOS and append the path or efiSysMountPoint.
                This is only used if `boot.loader.efi.canTouchEfiVariables` is true.
              '';
            };

            devices = lib.mkOption {
              default = [ ];
              example = [ "/dev/disk/by-id/wwn-0x500001234567890a" "/dev/disk/by-id/wwn-0x500009876543210a" ];
              type = lib.types.listOf lib.types.str;
              description = ''
                The path to the devices which will have the GRUB MBR written.
                Note these are typically device paths and not paths to partitions.
              '';
            };

          };
        });
      };

      configurationName = lib.mkOption {
        default = "";
        example = "Stable 2.6.21";
        type = lib.types.str;
        description = ''
          GRUB entry name instead of default.
        '';
      };

      storePath = lib.mkOption {
        default = "/nix/store";
        type = lib.types.str;
        description = ''
          Path to the Nix store when looking for kernels at boot.
          Only makes sense when copyKernels is false.
        '';
      };

      extraPrepareConfig = lib.mkOption {
        default = "";
        type = lib.types.lines;
        description = ''
          Additional bash commands to be run at the script that
          prepares the GRUB menu entries.
        '';
      };

      extraConfig = lib.mkOption {
        default = "";
        example = ''
          serial --unit=0 --speed=115200 --word=8 --parity=no --stop=1
          terminal_input --append serial
          terminal_output --append serial
        '';
        type = lib.types.lines;
        description = ''
          Additional GRUB commands inserted in the configuration file
          just before the menu entries.
        '';
      };

      extraGrubInstallArgs = lib.mkOption {
        default = [ ];
        example = [ "--modules=nativedisk ahci pata part_gpt part_msdos diskfilter mdraid1x lvm ext2" ];
        type = lib.types.listOf lib.types.str;
        description = ''
          Additional arguments passed to `grub-install`.

          A use case for this is to build specific GRUB2 modules
          directly into the GRUB2 kernel image, so that they are available
          and activated even in the `grub rescue` shell.

          They are also necessary when the BIOS/UEFI is bugged and cannot
          correctly read large disks (e.g. above 2 TB), so GRUB2's own
          `nativedisk` and related modules can be used
          to use its own disk drivers. The example shows one such case.
          This is also useful for booting from USB.
          See the
          [
          GRUB source code
          ](https://git.savannah.gnu.org/cgit/grub.git/tree/grub-core/commands/nativedisk.c?h=grub-2.04#n326)
          for which disk modules are available.

          The list elements are passed directly as `argv`
          arguments to the `grub-install` program, in order.
        '';
      };

      extraInstallCommands = lib.mkOption {
        default = "";
        example = ''
          # the example below generates detached signatures that GRUB can verify
          # https://www.gnu.org/software/grub/manual/grub/grub.html#Using-digital-signatures
          ''${pkgs.findutils}/bin/find /boot -not -path "/boot/efi/*" -type f -name '*.sig' -delete
          old_gpg_home=$GNUPGHOME
          export GNUPGHOME="$(mktemp -d)"
          ''${pkgs.gnupg}/bin/gpg --import ''${priv_key} > /dev/null 2>&1
          ''${pkgs.findutils}/bin/find /boot -not -path "/boot/efi/*" -type f -exec ''${pkgs.gnupg}/bin/gpg --detach-sign "{}" \; > /dev/null 2>&1
          rm -rf $GNUPGHOME
          export GNUPGHOME=$old_gpg_home
        '';
        type = lib.types.lines;
        description = ''
          Additional shell commands inserted in the bootloader installer
          script after generating menu entries.
        '';
      };

      extraPerEntryConfig = lib.mkOption {
        default = "";
        example = "root (hd0)";
        type = lib.types.lines;
        description = ''
          Additional GRUB commands inserted in the configuration file
          at the start of each NixOS menu entry.
        '';
      };

      extraEntries = lib.mkOption {
        default = "";
        type = lib.types.lines;
        example = ''
          # GRUB 2 example
          menuentry "Windows 7" {
            chainloader (hd0,4)+1
          }

          # GRUB 2 with UEFI example, chainloading another distro
          menuentry "Fedora" {
            set root=(hd1,1)
            chainloader /efi/fedora/grubx64.efi
          }
        '';
        description = ''
          Any additional entries you want added to the GRUB boot menu.
        '';
      };

      extraEntriesBeforeNixOS = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = ''
          Whether extraEntries are included before the default option.
        '';
      };

      extraFiles = lib.mkOption {
        type = lib.types.attrsOf lib.types.path;
        default = {};
        example = lib.literalExpression ''
          { "memtest.bin" = "''${pkgs.memtest86plus}/memtest.bin"; }
        '';
        description = ''
          A set of files to be copied to {file}`/boot`.
          Each attribute name denotes the destination file name in
          {file}`/boot`, while the corresponding
          attribute value specifies the source file.
        '';
      };

      useOSProber = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = ''
          If set to true, append entries for other OSs detected by os-prober.
        '';
      };

      splashImage = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        example = lib.literalExpression "./my-background.png";
        description = ''
          Background image used for GRUB.
          Set to `null` to run GRUB in text mode.

          ::: {.note}
          File must be one of .png, .tga, .jpg, or .jpeg. JPEG images must
          not be progressive.
          The image will be scaled if necessary to fit the screen.
          :::
        '';
      };

      backgroundColor = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        example = "#7EBAE4";
        default = null;
        description = ''
          Background color to be used for GRUB to fill the areas the image isn't filling.
        '';
      };

      timeoutStyle = lib.mkOption {
        default = "menu";
        type = lib.types.enum [ "menu" "countdown" "hidden" ];
        description = ''
           - `menu` shows the menu.
           - `countdown` uses a text-mode countdown.
           - `hidden` hides GRUB entirely.

          When using a theme, the default value (`menu`) is appropriate for the graphical countdown.

          When attempting to do flicker-free boot, `hidden` should be used.

          See the [GRUB documentation section about `timeout_style`](https://www.gnu.org/software/grub/manual/grub/html_node/timeout.html).

          ::: {.note}
          If this option is set to ‘countdown’ or ‘hidden’ [...] and ESC or F4 are pressed, or SHIFT is held down during that time, it will display the menu and wait for input.
          :::

          From: [Simple configuration handling page, under GRUB_TIMEOUT_STYLE](https://www.gnu.org/software/grub/manual/grub/html_node/Simple-configuration.html).
        '';
      };

      entryOptions = lib.mkOption {
        default = "--class nixos --unrestricted";
        type = lib.types.nullOr lib.types.str;
        description = ''
          Options applied to the primary NixOS menu entry.
        '';
      };

      subEntryOptions = lib.mkOption {
        default = "--class nixos";
        type = lib.types.nullOr lib.types.str;
        description = ''
          Options applied to the secondary NixOS submenu entry.
        '';
      };

      theme = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        example = lib.literalExpression ''"''${pkgs.libsForQt5.breeze-grub}/grub/themes/breeze"'';
        default = null;
        description = ''
          Path to the grub theme to be used.
        '';
      };

      splashMode = lib.mkOption {
        type = lib.types.enum [ "normal" "stretch" ];
        default = "stretch";
        description = ''
          Whether to stretch the image or show the image in the top-left corner unstretched.
        '';
      };

      font = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = "${realGrub}/share/grub/unicode.pf2";
        defaultText = lib.literalExpression ''"''${pkgs.grub2}/share/grub/unicode.pf2"'';
        description = ''
          Path to a TrueType, OpenType, or pf2 font to be used by Grub.
        '';
      };

      fontSize = lib.mkOption {
        type = lib.types.nullOr lib.types.int;
        example = 16;
        default = null;
        description = ''
          Font size for the grub menu. Ignored unless `font`
          is set to a ttf or otf font.
        '';
      };

      gfxmodeEfi = lib.mkOption {
        default = "auto";
        example = "1024x768";
        type = lib.types.str;
        description = ''
          The gfxmode to pass to GRUB when loading a graphical boot interface under EFI.
        '';
      };

      gfxmodeBios = lib.mkOption {
        default = "1024x768";
        example = "auto";
        type = lib.types.str;
        description = ''
          The gfxmode to pass to GRUB when loading a graphical boot interface under BIOS.
        '';
      };

      gfxpayloadEfi = lib.mkOption {
        default = "keep";
        example = "text";
        type = lib.types.str;
        description = ''
          The gfxpayload to pass to GRUB when loading a graphical boot interface under EFI.
        '';
      };

      gfxpayloadBios = lib.mkOption {
        default = "text";
        example = "keep";
        type = lib.types.str;
        description = ''
          The gfxpayload to pass to GRUB when loading a graphical boot interface under BIOS.
        '';
      };

      configurationLimit = lib.mkOption {
        default = 100;
        example = 120;
        type = lib.types.int;
        description = ''
          Maximum of configurations in boot menu. GRUB has problems when
          there are too many entries.
        '';
      };

      copyKernels = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = ''
          Whether the GRUB menu builder should copy kernels and initial
          ramdisks to /boot.  This is done automatically if /boot is
          on a different partition than /.
        '';
      };

      default = lib.mkOption {
        default = "0";
        type = lib.types.either lib.types.int lib.types.str;
        apply = toString;
        description = ''
          Index of the default menu item to be booted.
          Can also be set to "saved", which will make GRUB select
          the menu item that was used at the last boot.
        '';
      };

      fsIdentifier = lib.mkOption {
        default = "uuid";
        type = lib.types.enum [ "uuid" "label" "provided" ];
        description = ''
          Determines how GRUB will identify devices when generating the
          configuration file. A value of uuid / label signifies that grub
          will always resolve the uuid or label of the device before using
          it in the configuration. A value of provided means that GRUB will
          use the device name as show in {command}`df` or
          {command}`mount`. Note, zfs zpools / datasets are ignored
          and will always be mounted using their labels.
        '';
      };

      zfsSupport = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = ''
          Whether GRUB should be built against libzfs.
        '';
      };

      zfsPackage = lib.mkOption {
        type = lib.types.package;
        internal = true;
        default = pkgs.zfs;
        defaultText = lib.literalExpression "pkgs.zfs";
        description = ''
          Which ZFS package to use if `config.boot.loader.grub.zfsSupport` is true.
        '';
      };

      efiSupport = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = ''
          Whether GRUB should be built with EFI support.
        '';
      };

      efiInstallAsRemovable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = ''
          Whether to invoke `grub-install` with
          `--removable`.

          Unless you turn this on, GRUB will install itself somewhere in
          `boot.loader.efi.efiSysMountPoint` (exactly where
          depends on other config variables). If you've set
          `boot.loader.efi.canTouchEfiVariables` *AND* you
          are currently booted in UEFI mode, then GRUB will use
          `efibootmgr` to modify the boot order in the
          EFI variables of your firmware to include this location. If you are
          *not* booted in UEFI mode at the time GRUB is being installed, the
          NVRAM will not be modified, and your system will not find GRUB at
          boot time. However, GRUB will still return success so you may miss
          the warning that gets printed ("`efibootmgr: EFI variables
          are not supported on this system.`").

          If you turn this feature on, GRUB will install itself in a
          special location within `efiSysMountPoint` (namely
          `EFI/boot/boot$arch.efi`) which the firmwares
          are hardcoded to try first, regardless of NVRAM EFI variables.

          To summarize, turn this on if:
          - You are installing NixOS and want it to boot in UEFI mode,
            but you are currently booted in legacy mode
          - You want to make a drive that will boot regardless of
            the NVRAM state of the computer (like a USB "removable" drive)
          - You simply dislike the idea of depending on NVRAM
            state to make your drive bootable
        '';
      };

      enableCryptodisk = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = ''
          Enable support for encrypted partitions. GRUB should automatically
          unlock the correct encrypted partition and look for filesystems.
        '';
      };

      forceInstall = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = ''
          Whether to try and forcibly install GRUB even if problems are
          detected. It is not recommended to enable this unless you know what
          you are doing.
        '';
      };

      forcei686 = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = ''
          Whether to force the use of a ia32 boot loader on x64 systems. Required
          to install and run NixOS on 64bit x86 systems with 32bit (U)EFI.
        '';
      };

    };

  };


  ###### implementation

  config = lib.mkMerge [

    { boot.loader.grub.splashImage = lib.mkDefault defaultSplash; }

    (lib.mkIf (cfg.splashImage == defaultSplash) {
      boot.loader.grub.backgroundColor = lib.mkDefault "#2F302F";
      boot.loader.grub.splashMode = lib.mkDefault "normal";
    })

    (lib.mkIf cfg.enable {

      boot.loader.grub.devices = lib.mkIf (cfg.device != "") [ cfg.device ];

      boot.loader.grub.mirroredBoots = lib.mkIf (cfg.devices != [ ]) [
        { path = "/boot"; inherit (cfg) devices; inherit (efi) efiSysMountPoint; }
      ];

      boot.loader.supportsInitrdSecrets = true;

      system.systemBuilderArgs.configurationName = cfg.configurationName;
      system.systemBuilderCommands = ''
        echo -n "$configurationName" > $out/configuration-name
      '';

      system.build.installBootLoader =
        let
          install-grub-pl = pkgs.substituteAll {
            src = ./install-grub.pl;
            utillinux = pkgs.util-linux;
            btrfsprogs = pkgs.btrfs-progs;
            inherit (config.system.nixos) distroName;
          };
          perl = pkgs.perl.withPackages (p: with p; [
            FileSlurp FileCopyRecursive
            XMLLibXML XMLSAX XMLSAXBase
            ListCompare JSON
          ]);
        in pkgs.writeScript "install-grub.sh" (''
        #!${pkgs.runtimeShell}
        set -e
        ${lib.optionalString cfg.enableCryptodisk "export GRUB_ENABLE_CRYPTODISK=y"}
      '' + lib.flip lib.concatMapStrings cfg.mirroredBoots (args: ''
        ${perl}/bin/perl ${install-grub-pl} ${grubConfig args} $@
      '') + cfg.extraInstallCommands);

      system.build.grub = grub;

      # Common attribute for boot loaders so only one of them can be
      # set at once.
      system.boot.loader.id = "grub";

      environment.systemPackages = lib.mkIf (grub != null) [ grub ];

      boot.loader.grub.extraPrepareConfig =
        lib.concatStrings (lib.mapAttrsToList (n: v: ''
          ${pkgs.coreutils}/bin/install -Dp "${v}" "${efi.efiSysMountPoint}/"${lib.escapeShellArg n}
        '') config.boot.loader.grub.extraFiles);

      assertions = [
        {
          assertion = cfg.mirroredBoots != [ ];
          message = "You must set the option ‘boot.loader.grub.devices’ or "
            + "'boot.loader.grub.mirroredBoots' to make the system bootable.";
        }
        {
          assertion = cfg.efiSupport || lib.all (c: c < 2) (lib.mapAttrsToList (n: c: if n == "nodev" then 0 else c) bootDeviceCounters);
          message = "You cannot have duplicated devices in mirroredBoots";
        }
        {
          assertion = cfg.efiInstallAsRemovable -> cfg.efiSupport;
          message = "If you wish to to use boot.loader.grub.efiInstallAsRemovable, then turn on boot.loader.grub.efiSupport";
        }
        {
          assertion = cfg.efiInstallAsRemovable -> !config.boot.loader.efi.canTouchEfiVariables;
          message = "If you wish to to use boot.loader.grub.efiInstallAsRemovable, then turn off boot.loader.efi.canTouchEfiVariables";
        }
        {
          assertion = !(options.boot.loader.grub.version.isDefined && cfg.version == 1);
          message = "Support for version 0.9x of GRUB was removed after being unsupported upstream for around a decade";
        }
      ] ++ lib.flip lib.concatMap cfg.mirroredBoots (args: [
        {
          assertion = args.devices != [ ];
          message = "A boot path cannot have an empty devices string in ${args.path}";
        }
        {
          assertion = lib.hasPrefix "/" args.path;
          message = "Boot paths must be absolute, not ${args.path}";
        }
        {
          assertion = if args.efiSysMountPoint == null then true else lib.hasPrefix "/" args.efiSysMountPoint;
          message = "EFI paths must be absolute, not ${args.efiSysMountPoint}";
        }
      ] ++ lib.forEach args.devices (device: {
        assertion = device == "nodev" || lib.hasPrefix "/" device;
        message = "GRUB devices must be absolute paths, not ${device} in ${args.path}";
      }));
    })

    (lib.mkIf options.boot.loader.grub.version.isDefined {
      warnings = [ ''
        The boot.loader.grub.version option does not have any effect anymore, please remove it from your configuration.
      '' ];
    })
  ];


  imports =
    [ (lib.mkRemovedOptionModule [ "boot" "loader" "grub" "bootDevice" ] "")
      (lib.mkRenamedOptionModule [ "boot" "copyKernels" ] [ "boot" "loader" "grub" "copyKernels" ])
      (lib.mkRenamedOptionModule [ "boot" "extraGrubEntries" ] [ "boot" "loader" "grub" "extraEntries" ])
      (lib.mkRenamedOptionModule [ "boot" "extraGrubEntriesBeforeNixos" ] [ "boot" "loader" "grub" "extraEntriesBeforeNixOS" ])
      (lib.mkRenamedOptionModule [ "boot" "grubDevice" ] [ "boot" "loader" "grub" "device" ])
      (lib.mkRenamedOptionModule [ "boot" "bootMount" ] [ "boot" "loader" "grub" "bootDevice" ])
      (lib.mkRenamedOptionModule [ "boot" "grubSplashImage" ] [ "boot" "loader" "grub" "splashImage" ])
      (lib.mkRemovedOptionModule [ "boot" "loader" "grub" "trustedBoot" ] ''
        Support for Trusted GRUB has been removed, because the project
        has been retired upstream.
      '')
      (lib.mkRemovedOptionModule [ "boot" "loader" "grub" "extraInitrd" ] ''
        This option has been replaced with the bootloader agnostic
        boot.initrd.secrets option. To migrate to the initrd secrets system,
        extract the extraInitrd archive into your main filesystem:

          # zcat /boot/extra_initramfs.gz | cpio -idvmD /etc/secrets/initrd
          /path/to/secret1
          /path/to/secret2

        then replace boot.loader.grub.extraInitrd with boot.initrd.secrets:

          boot.initrd.secrets = {
            "/path/to/secret1" = "/etc/secrets/initrd/path/to/secret1";
            "/path/to/secret2" = "/etc/secrets/initrd/path/to/secret2";
          };

        See the boot.initrd.secrets option documentation for more information.
      '')
    ];

}
