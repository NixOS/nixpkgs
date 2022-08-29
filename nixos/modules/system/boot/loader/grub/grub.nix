{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.boot.loader.grub;

  efi = config.boot.loader.efi;

  grubPkgs =
    # Package set of targeted architecture
    if cfg.forcei686 then pkgs.pkgsi686Linux else pkgs;

  realGrub = if cfg.version == 1 then grubPkgs.grub
    else if cfg.zfsSupport then grubPkgs.grub2.override { zfsSupport = true; }
    else if cfg.trustedBoot.enable
         then if cfg.trustedBoot.isHPLaptop
              then grubPkgs.trustedGrub-for-HP
              else grubPkgs.trustedGrub
         else grubPkgs.grub2;

  grub =
    # Don't include GRUB if we're only generating a GRUB menu (e.g.,
    # in EC2 instances).
    if cfg.devices == ["nodev"]
    then null
    else realGrub;

  grubEfi =
    # EFI version of Grub v2
    if cfg.efiSupport && (cfg.version == 2)
    then realGrub.override { efiSupport = cfg.efiSupport; }
    else null;

  f = x: if x == null then "" else "" + x;

  grubConfig = args:
    let
      efiSysMountPoint = if args.efiSysMountPoint == null then args.path else args.efiSysMountPoint;
      efiSysMountPoint' = replaceChars [ "/" ] [ "-" ] efiSysMountPoint;
    in
    pkgs.writeText "grub-config.xml" (builtins.toXML
    { splashImage = f cfg.splashImage;
      splashMode = f cfg.splashMode;
      backgroundColor = f cfg.backgroundColor;
      entryOptions = f cfg.entryOptions;
      subEntryOptions = f cfg.subEntryOptions;
      grub = f grub;
      grubTarget = f (grub.grubTarget or "");
      shell = "${pkgs.runtimeShell}";
      fullName = lib.getName realGrub;
      fullVersion = lib.getVersion realGrub;
      grubEfi = f grubEfi;
      grubTargetEfi = if cfg.efiSupport && (cfg.version == 2) then f (grubEfi.grubTarget or "") else "";
      bootPath = args.path;
      storePath = config.boot.loader.grub.storePath;
      bootloaderId = if args.efiBootloaderId == null then "NixOS${efiSysMountPoint'}" else args.efiBootloaderId;
      timeout = if config.boot.loader.timeout == null then -1 else config.boot.loader.timeout;
      users = if cfg.users == {} || cfg.version != 1 then cfg.users else throw "GRUB version 1 does not support user accounts.";
      theme = f cfg.theme;
      inherit efiSysMountPoint;
      inherit (args) devices;
      inherit (efi) canTouchEfiVariables;
      inherit (cfg)
        version extraConfig extraPerEntryConfig extraEntries forceInstall useOSProber
        extraGrubInstallArgs
        extraEntriesBeforeNixOS extraPrepareConfig configurationLimit copyKernels
        default fsIdentifier efiSupport efiInstallAsRemovable gfxmodeEfi gfxmodeBios gfxpayloadEfi gfxpayloadBios;
      path = with pkgs; makeBinPath (
        [ coreutils gnused gnugrep findutils diffutils btrfs-progs util-linux mdadm ]
        ++ optional (cfg.efiSupport && (cfg.version == 2)) efibootmgr
        ++ optionals cfg.useOSProber [ busybox os-prober ]);
      font = if cfg.font == null then ""
        else (if lib.last (lib.splitString "." cfg.font) == "pf2"
             then cfg.font
             else "${convertedFont}");
    });

  bootDeviceCounters = foldr (device: attr: attr // { ${device} = (attr.${device} or 0) + 1; }) {}
    (concatMap (args: args.devices) cfg.mirroredBoots);

  convertedFont = (pkgs.runCommand "grub-font-converted.pf2" {}
           (builtins.concatStringsSep " "
             ([ "${realGrub}/bin/grub-mkfont"
               cfg.font
               "--output" "$out"
             ] ++ (optional (cfg.fontSize!=null) "--size ${toString cfg.fontSize}")))
         );

  defaultSplash = pkgs.nixos-artwork.wallpapers.simple-dark-gray-bootloader.gnomeFilePath;
in

{

  ###### interface

  options = {

    boot.loader.grub = {

      enable = mkOption {
        default = !config.boot.isContainer;
        defaultText = literalExpression "!config.boot.isContainer";
        type = types.bool;
        description = lib.mdDoc ''
          Whether to enable the GNU GRUB boot loader.
        '';
      };

      version = mkOption {
        default = 2;
        example = 1;
        type = types.int;
        description = lib.mdDoc ''
          The version of GRUB to use: `1` for GRUB
          Legacy (versions 0.9x), or `2` (the
          default) for GRUB 2.
        '';
      };

      device = mkOption {
        default = "";
        example = "/dev/disk/by-id/wwn-0x500001234567890a";
        type = types.str;
        description = lib.mdDoc ''
          The device on which the GRUB boot loader will be installed.
          The special value `nodev` means that a GRUB
          boot menu will be generated, but GRUB itself will not
          actually be installed.  To install GRUB on multiple devices,
          use `boot.loader.grub.devices`.
        '';
      };

      devices = mkOption {
        default = [];
        example = [ "/dev/disk/by-id/wwn-0x500001234567890a" ];
        type = types.listOf types.str;
        description = lib.mdDoc ''
          The devices on which the boot loader, GRUB, will be
          installed. Can be used instead of `device` to
          install GRUB onto multiple devices.
        '';
      };

      users = mkOption {
        default = {};
        example = {
          root = { hashedPasswordFile = "/path/to/file"; };
        };
        description = lib.mdDoc ''
          User accounts for GRUB. When specified, the GRUB command line and
          all boot options except the default are password-protected.
          All passwords and hashes provided will be stored in /boot/grub/grub.cfg,
          and will be visible to any local user who can read this file. Additionally,
          any passwords and hashes provided directly in a Nix configuration
          (as opposed to external files) will be copied into the Nix store, and
          will be visible to all local users.
        '';
        type = with types; attrsOf (submodule {
          options = {
            hashedPasswordFile = mkOption {
              example = "/path/to/file";
              default = null;
              type = with types; uniq (nullOr str);
              description = lib.mdDoc ''
                Specifies the path to a file containing the password hash
                for the account, generated with grub-mkpasswd-pbkdf2.
                This hash will be stored in /boot/grub/grub.cfg, and will
                be visible to any local user who can read this file.
              '';
            };
            hashedPassword = mkOption {
              example = "grub.pbkdf2.sha512.10000.674DFFDEF76E13EA...2CC972B102CF4355";
              default = null;
              type = with types; uniq (nullOr str);
              description = lib.mdDoc ''
                Specifies the password hash for the account,
                generated with grub-mkpasswd-pbkdf2.
                This hash will be copied to the Nix store, and will be visible to all local users.
              '';
            };
            passwordFile = mkOption {
              example = "/path/to/file";
              default = null;
              type = with types; uniq (nullOr str);
              description = lib.mdDoc ''
                Specifies the path to a file containing the
                clear text password for the account.
                This password will be stored in /boot/grub/grub.cfg, and will
                be visible to any local user who can read this file.
              '';
            };
            password = mkOption {
              example = "Pa$$w0rd!";
              default = null;
              type = with types; uniq (nullOr str);
              description = lib.mdDoc ''
                Specifies the clear text password for the account.
                This password will be copied to the Nix store, and will be visible to all local users.
              '';
            };
          };
        });
      };

      mirroredBoots = mkOption {
        default = [ ];
        example = [
          { path = "/boot1"; devices = [ "/dev/disk/by-id/wwn-0x500001234567890a" ]; }
          { path = "/boot2"; devices = [ "/dev/disk/by-id/wwn-0x500009876543210a" ]; }
        ];
        description = lib.mdDoc ''
          Mirror the boot configuration to multiple partitions and install grub
          to the respective devices corresponding to those partitions.
        '';

        type = with types; listOf (submodule {
          options = {

            path = mkOption {
              example = "/boot1";
              type = types.str;
              description = lib.mdDoc ''
                The path to the boot directory where GRUB will be written. Generally
                this boot path should double as an EFI path.
              '';
            };

            efiSysMountPoint = mkOption {
              default = null;
              example = "/boot1/efi";
              type = types.nullOr types.str;
              description = lib.mdDoc ''
                The path to the efi system mount point. Usually this is the same
                partition as the above path and can be left as null.
              '';
            };

            efiBootloaderId = mkOption {
              default = null;
              example = "NixOS-fsid";
              type = types.nullOr types.str;
              description = lib.mdDoc ''
                The id of the bootloader to store in efi nvram.
                The default is to name it NixOS and append the path or efiSysMountPoint.
                This is only used if `boot.loader.efi.canTouchEfiVariables` is true.
              '';
            };

            devices = mkOption {
              default = [ ];
              example = [ "/dev/disk/by-id/wwn-0x500001234567890a" "/dev/disk/by-id/wwn-0x500009876543210a" ];
              type = types.listOf types.str;
              description = lib.mdDoc ''
                The path to the devices which will have the GRUB MBR written.
                Note these are typically device paths and not paths to partitions.
              '';
            };

          };
        });
      };

      configurationName = mkOption {
        default = "";
        example = "Stable 2.6.21";
        type = types.str;
        description = lib.mdDoc ''
          GRUB entry name instead of default.
        '';
      };

      storePath = mkOption {
        default = "/nix/store";
        type = types.str;
        description = lib.mdDoc ''
          Path to the Nix store when looking for kernels at boot.
          Only makes sense when copyKernels is false.
        '';
      };

      extraPrepareConfig = mkOption {
        default = "";
        type = types.lines;
        description = lib.mdDoc ''
          Additional bash commands to be run at the script that
          prepares the GRUB menu entries.
        '';
      };

      extraConfig = mkOption {
        default = "";
        example = ''
          serial --unit=0 --speed=115200 --word=8 --parity=no --stop=1
          terminal_input --append serial
          terminal_output --append serial
        '';
        type = types.lines;
        description = lib.mdDoc ''
          Additional GRUB commands inserted in the configuration file
          just before the menu entries.
        '';
      };

      extraGrubInstallArgs = mkOption {
        default = [ ];
        example = [ "--modules=nativedisk ahci pata part_gpt part_msdos diskfilter mdraid1x lvm ext2" ];
        type = types.listOf types.str;
        description = lib.mdDoc ''
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
          ](http://git.savannah.gnu.org/cgit/grub.git/tree/grub-core/commands/nativedisk.c?h=grub-2.04#n326)
          for which disk modules are available.

          The list elements are passed directly as `argv`
          arguments to the `grub-install` program, in order.
        '';
      };

      extraInstallCommands = mkOption {
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
        type = types.lines;
        description = lib.mdDoc ''
          Additional shell commands inserted in the bootloader installer
          script after generating menu entries.
        '';
      };

      extraPerEntryConfig = mkOption {
        default = "";
        example = "root (hd0)";
        type = types.lines;
        description = lib.mdDoc ''
          Additional GRUB commands inserted in the configuration file
          at the start of each NixOS menu entry.
        '';
      };

      extraEntries = mkOption {
        default = "";
        type = types.lines;
        example = ''
          # GRUB 1 example (not GRUB 2 compatible)
          title Windows
            chainloader (hd0,1)+1

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
        description = lib.mdDoc ''
          Any additional entries you want added to the GRUB boot menu.
        '';
      };

      extraEntriesBeforeNixOS = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc ''
          Whether extraEntries are included before the default option.
        '';
      };

      extraFiles = mkOption {
        type = types.attrsOf types.path;
        default = {};
        example = literalExpression ''
          { "memtest.bin" = "''${pkgs.memtest86plus}/memtest.bin"; }
        '';
        description = lib.mdDoc ''
          A set of files to be copied to {file}`/boot`.
          Each attribute name denotes the destination file name in
          {file}`/boot`, while the corresponding
          attribute value specifies the source file.
        '';
      };

      useOSProber = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc ''
          If set to true, append entries for other OSs detected by os-prober.
        '';
      };

      splashImage = mkOption {
        type = types.nullOr types.path;
        example = literalExpression "./my-background.png";
        description = ''
          Background image used for GRUB.
          Set to <literal>null</literal> to run GRUB in text mode.

          <note><para>
          For grub 1:
          It must be a 640x480,
          14-colour image in XPM format, optionally compressed with
          <command>gzip</command> or <command>bzip2</command>.
          </para></note>

          <note><para>
          For grub 2:
          File must be one of .png, .tga, .jpg, or .jpeg. JPEG images must
          not be progressive.
          The image will be scaled if necessary to fit the screen.
          </para></note>
        '';
      };

      backgroundColor = mkOption {
        type = types.nullOr types.str;
        example = "#7EBAE4";
        default = null;
        description = ''
          Background color to be used for GRUB to fill the areas the image isn't filling.

          <note><para>
          This options has no effect for GRUB 1.
          </para></note>
        '';
      };

      entryOptions = mkOption {
        default = "--class nixos --unrestricted";
        type = types.nullOr types.str;
        description = ''
          Options applied to the primary NixOS menu entry.

          <note><para>
          This options has no effect for GRUB 1.
          </para></note>
        '';
      };

      subEntryOptions = mkOption {
        default = "--class nixos";
        type = types.nullOr types.str;
        description = ''
          Options applied to the secondary NixOS submenu entry.

          <note><para>
          This options has no effect for GRUB 1.
          </para></note>
        '';
      };

      theme = mkOption {
        type = types.nullOr types.path;
        example = literalExpression "pkgs.nixos-grub2-theme";
        default = null;
        description = ''
          Grub theme to be used.

          <note><para>
          This options has no effect for GRUB 1.
          </para></note>
        '';
      };

      splashMode = mkOption {
        type = types.enum [ "normal" "stretch" ];
        default = "stretch";
        description = ''
          Whether to stretch the image or show the image in the top-left corner unstretched.

          <note><para>
          This options has no effect for GRUB 1.
          </para></note>
        '';
      };

      font = mkOption {
        type = types.nullOr types.path;
        default = "${realGrub}/share/grub/unicode.pf2";
        defaultText = literalExpression ''"''${pkgs.grub2}/share/grub/unicode.pf2"'';
        description = lib.mdDoc ''
          Path to a TrueType, OpenType, or pf2 font to be used by Grub.
        '';
      };

      fontSize = mkOption {
        type = types.nullOr types.int;
        example = 16;
        default = null;
        description = lib.mdDoc ''
          Font size for the grub menu. Ignored unless `font`
          is set to a ttf or otf font.
        '';
      };

      gfxmodeEfi = mkOption {
        default = "auto";
        example = "1024x768";
        type = types.str;
        description = lib.mdDoc ''
          The gfxmode to pass to GRUB when loading a graphical boot interface under EFI.
        '';
      };

      gfxmodeBios = mkOption {
        default = "1024x768";
        example = "auto";
        type = types.str;
        description = lib.mdDoc ''
          The gfxmode to pass to GRUB when loading a graphical boot interface under BIOS.
        '';
      };

      gfxpayloadEfi = mkOption {
        default = "keep";
        example = "text";
        type = types.str;
        description = lib.mdDoc ''
          The gfxpayload to pass to GRUB when loading a graphical boot interface under EFI.
        '';
      };

      gfxpayloadBios = mkOption {
        default = "text";
        example = "keep";
        type = types.str;
        description = lib.mdDoc ''
          The gfxpayload to pass to GRUB when loading a graphical boot interface under BIOS.
        '';
      };

      configurationLimit = mkOption {
        default = 100;
        example = 120;
        type = types.int;
        description = lib.mdDoc ''
          Maximum of configurations in boot menu. GRUB has problems when
          there are too many entries.
        '';
      };

      copyKernels = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc ''
          Whether the GRUB menu builder should copy kernels and initial
          ramdisks to /boot.  This is done automatically if /boot is
          on a different partition than /.
        '';
      };

      default = mkOption {
        default = "0";
        type = types.either types.int types.str;
        apply = toString;
        description = lib.mdDoc ''
          Index of the default menu item to be booted.
          Can also be set to "saved", which will make GRUB select
          the menu item that was used at the last boot.
        '';
      };

      fsIdentifier = mkOption {
        default = "uuid";
        type = types.enum [ "uuid" "label" "provided" ];
        description = lib.mdDoc ''
          Determines how GRUB will identify devices when generating the
          configuration file. A value of uuid / label signifies that grub
          will always resolve the uuid or label of the device before using
          it in the configuration. A value of provided means that GRUB will
          use the device name as show in {command}`df` or
          {command}`mount`. Note, zfs zpools / datasets are ignored
          and will always be mounted using their labels.
        '';
      };

      zfsSupport = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc ''
          Whether GRUB should be built against libzfs.
          ZFS support is only available for GRUB v2.
          This option is ignored for GRUB v1.
        '';
      };

      efiSupport = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc ''
          Whether GRUB should be built with EFI support.
          EFI support is only available for GRUB v2.
          This option is ignored for GRUB v1.
        '';
      };

      efiInstallAsRemovable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Whether to invoke <literal>grub-install</literal> with
          <literal>--removable</literal>.

          Unless you turn this on, GRUB will install itself somewhere in
          <literal>boot.loader.efi.efiSysMountPoint</literal> (exactly where
          depends on other config variables). If you've set
          <literal>boot.loader.efi.canTouchEfiVariables</literal> *AND* you
          are currently booted in UEFI mode, then GRUB will use
          <literal>efibootmgr</literal> to modify the boot order in the
          EFI variables of your firmware to include this location. If you are
          *not* booted in UEFI mode at the time GRUB is being installed, the
          NVRAM will not be modified, and your system will not find GRUB at
          boot time. However, GRUB will still return success so you may miss
          the warning that gets printed ("<literal>efibootmgr: EFI variables
          are not supported on this system.</literal>").

          If you turn this feature on, GRUB will install itself in a
          special location within <literal>efiSysMountPoint</literal> (namely
          <literal>EFI/boot/boot$arch.efi</literal>) which the firmwares
          are hardcoded to try first, regardless of NVRAM EFI variables.

          To summarize, turn this on if:
          <itemizedlist>
            <listitem><para>You are installing NixOS and want it to boot in UEFI mode,
            but you are currently booted in legacy mode</para></listitem>
            <listitem><para>You want to make a drive that will boot regardless of
            the NVRAM state of the computer (like a USB "removable" drive)</para></listitem>
            <listitem><para>You simply dislike the idea of depending on NVRAM
            state to make your drive bootable</para></listitem>
          </itemizedlist>
        '';
      };

      enableCryptodisk = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc ''
          Enable support for encrypted partitions. GRUB should automatically
          unlock the correct encrypted partition and look for filesystems.
        '';
      };

      forceInstall = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc ''
          Whether to try and forcibly install GRUB even if problems are
          detected. It is not recommended to enable this unless you know what
          you are doing.
        '';
      };

      forcei686 = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc ''
          Whether to force the use of a ia32 boot loader on x64 systems. Required
          to install and run NixOS on 64bit x86 systems with 32bit (U)EFI.
        '';
      };

      trustedBoot = {

        enable = mkOption {
          default = false;
          type = types.bool;
          description = lib.mdDoc ''
            Enable trusted boot. GRUB will measure all critical components during
            the boot process to offer TCG (TPM) support.
          '';
        };

        systemHasTPM = mkOption {
          default = "";
          example = "YES_TPM_is_activated";
          type = types.str;
          description = lib.mdDoc ''
            Assertion that the target system has an activated TPM. It is a safety
            check before allowing the activation of 'trustedBoot.enable'. TrustedBoot
            WILL FAIL TO BOOT YOUR SYSTEM if no TPM is available.
          '';
        };

        isHPLaptop = mkOption {
          default = false;
          type = types.bool;
          description = lib.mdDoc ''
            Use a special version of TrustedGRUB that is needed by some HP laptops
            and works only for the HP laptops.
          '';
        };

      };

    };

  };


  ###### implementation

  config = mkMerge [

    { boot.loader.grub.splashImage = mkDefault (
        if cfg.version == 1 then pkgs.fetchurl {
          url = "http://www.gnome-look.org/CONTENT/content-files/36909-soft-tux.xpm.gz";
          sha256 = "14kqdx2lfqvh40h6fjjzqgff1mwk74dmbjvmqphi6azzra7z8d59";
        }
        # GRUB 1.97 doesn't support gzipped XPMs.
        else defaultSplash);
    }

    (mkIf (cfg.splashImage == defaultSplash) {
      boot.loader.grub.backgroundColor = mkDefault "#2F302F";
      boot.loader.grub.splashMode = mkDefault "normal";
    })

    (mkIf cfg.enable {

      boot.loader.grub.devices = optional (cfg.device != "") cfg.device;

      boot.loader.grub.mirroredBoots = optionals (cfg.devices != [ ]) [
        { path = "/boot"; inherit (cfg) devices; inherit (efi) efiSysMountPoint; }
      ];

      boot.loader.supportsInitrdSecrets = true;

      system.build.installBootLoader =
        let
          install-grub-pl = pkgs.substituteAll {
            src = ./install-grub.pl;
            utillinux = pkgs.util-linux;
            btrfsprogs = pkgs.btrfs-progs;
          };
          perl = pkgs.perl.withPackages (p: with p; [
            FileSlurp FileCopyRecursive
            XMLLibXML XMLSAX XMLSAXBase
            ListCompare JSON
          ]);
        in pkgs.writeScript "install-grub.sh" (''
        #!${pkgs.runtimeShell}
        set -e
        ${optionalString cfg.enableCryptodisk "export GRUB_ENABLE_CRYPTODISK=y"}
      '' + flip concatMapStrings cfg.mirroredBoots (args: ''
        ${perl}/bin/perl ${install-grub-pl} ${grubConfig args} $@
      '') + cfg.extraInstallCommands);

      system.build.grub = grub;

      # Common attribute for boot loaders so only one of them can be
      # set at once.
      system.boot.loader.id = "grub";

      environment.systemPackages = optional (grub != null) grub;

      boot.loader.grub.extraPrepareConfig =
        concatStrings (mapAttrsToList (n: v: ''
          ${pkgs.coreutils}/bin/cp -pf "${v}" "@bootPath@/${n}"
        '') config.boot.loader.grub.extraFiles);

      assertions = [
        {
          assertion = !cfg.zfsSupport || cfg.version == 2;
          message = "Only GRUB version 2 provides ZFS support";
        }
        {
          assertion = cfg.mirroredBoots != [ ];
          message = "You must set the option ‘boot.loader.grub.devices’ or "
            + "'boot.loader.grub.mirroredBoots' to make the system bootable.";
        }
        {
          assertion = cfg.efiSupport || all (c: c < 2) (mapAttrsToList (n: c: if n == "nodev" then 0 else c) bootDeviceCounters);
          message = "You cannot have duplicated devices in mirroredBoots";
        }
        {
          assertion = !cfg.trustedBoot.enable || cfg.version == 2;
          message = "Trusted GRUB is only available for GRUB 2";
        }
        {
          assertion = !cfg.efiSupport || !cfg.trustedBoot.enable;
          message = "Trusted GRUB does not have EFI support";
        }
        {
          assertion = !cfg.zfsSupport || !cfg.trustedBoot.enable;
          message = "Trusted GRUB does not have ZFS support";
        }
        {
          assertion = !cfg.trustedBoot.enable || cfg.trustedBoot.systemHasTPM == "YES_TPM_is_activated";
          message = "Trusted GRUB can break the system! Confirm that the system has an activated TPM by setting 'systemHasTPM'.";
        }
        {
          assertion = cfg.efiInstallAsRemovable -> cfg.efiSupport;
          message = "If you wish to to use boot.loader.grub.efiInstallAsRemovable, then turn on boot.loader.grub.efiSupport";
        }
        {
          assertion = cfg.efiInstallAsRemovable -> !config.boot.loader.efi.canTouchEfiVariables;
          message = "If you wish to to use boot.loader.grub.efiInstallAsRemovable, then turn off boot.loader.efi.canTouchEfiVariables";
        }
      ] ++ flip concatMap cfg.mirroredBoots (args: [
        {
          assertion = args.devices != [ ];
          message = "A boot path cannot have an empty devices string in ${args.path}";
        }
        {
          assertion = hasPrefix "/" args.path;
          message = "Boot paths must be absolute, not ${args.path}";
        }
        {
          assertion = if args.efiSysMountPoint == null then true else hasPrefix "/" args.efiSysMountPoint;
          message = "EFI paths must be absolute, not ${args.efiSysMountPoint}";
        }
      ] ++ forEach args.devices (device: {
        assertion = device == "nodev" || hasPrefix "/" device;
        message = "GRUB devices must be absolute paths, not ${device} in ${args.path}";
      }));
    })

  ];


  imports =
    [ (mkRemovedOptionModule [ "boot" "loader" "grub" "bootDevice" ] "")
      (mkRenamedOptionModule [ "boot" "copyKernels" ] [ "boot" "loader" "grub" "copyKernels" ])
      (mkRenamedOptionModule [ "boot" "extraGrubEntries" ] [ "boot" "loader" "grub" "extraEntries" ])
      (mkRenamedOptionModule [ "boot" "extraGrubEntriesBeforeNixos" ] [ "boot" "loader" "grub" "extraEntriesBeforeNixOS" ])
      (mkRenamedOptionModule [ "boot" "grubDevice" ] [ "boot" "loader" "grub" "device" ])
      (mkRenamedOptionModule [ "boot" "bootMount" ] [ "boot" "loader" "grub" "bootDevice" ])
      (mkRenamedOptionModule [ "boot" "grubSplashImage" ] [ "boot" "loader" "grub" "splashImage" ])
      (mkRemovedOptionModule [ "boot" "loader" "grub" "extraInitrd" ] ''
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
