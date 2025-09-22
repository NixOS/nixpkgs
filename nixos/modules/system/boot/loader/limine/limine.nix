{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.boot.loader.limine;
  efi = config.boot.loader.efi;
  limineInstallConfig = pkgs.writeText "limine-install.json" (
    builtins.toJSON {
      nixPath = config.nix.package;
      efiBootMgrPath = pkgs.efibootmgr;
      liminePath = cfg.package;
      efiMountPoint = efi.efiSysMountPoint;
      fileSystems = config.fileSystems;
      luksDevices = builtins.attrNames config.boot.initrd.luks.devices;
      canTouchEfiVariables = efi.canTouchEfiVariables;
      efiSupport = cfg.efiSupport;
      efiRemovable = cfg.efiInstallAsRemovable;
      secureBoot = cfg.secureBoot;
      biosSupport = cfg.biosSupport;
      biosDevice = cfg.biosDevice;
      partitionIndex = cfg.partitionIndex;
      forceMbr = cfg.forceMbr;
      enrollConfig = cfg.enrollConfig;
      style = cfg.style;
      maxGenerations = if cfg.maxGenerations == null then 0 else cfg.maxGenerations;
      hostArchitecture = pkgs.stdenv.hostPlatform.parsed.cpu;
      timeout = if config.boot.loader.timeout != null then config.boot.loader.timeout else 10;
      enableEditor = cfg.enableEditor;
      extraConfig = cfg.extraConfig;
      extraEntries = cfg.extraEntries;
      additionalFiles = cfg.additionalFiles;
      validateChecksums = cfg.validateChecksums;
      panicOnChecksumMismatch = cfg.panicOnChecksumMismatch;
    }
  );
  defaultWallpaper = pkgs.nixos-artwork.wallpapers.simple-dark-gray-bootloader.gnomeFilePath;
in
{
  meta = {
    inherit (pkgs.limine.meta) maintainers;
  };

  options.boot.loader.limine = {
    enable = lib.mkEnableOption "the Limine Bootloader";
    package = lib.mkPackageOption pkgs "limine" { };

    enableEditor = lib.mkEnableOption null // {
      description = ''
        Whether to allow editing the boot entries before booting them.
        It is recommended to set this to false, as it allows gaining root
        access by passing `init=/bin/sh` as a kernel parameter.
      '';
    };

    maxGenerations = lib.mkOption {
      default = null;
      example = 50;
      type = lib.types.nullOr lib.types.int;
      description = ''
        Maximum number of latest generations in the boot menu.
        Useful to prevent boot partition of running out of disk space.
        `null` means no limit i.e. all generations that were not
        garbage collected yet.
      '';
    };

    extraConfig = lib.mkOption {
      default = "";
      type = lib.types.lines;
      example = lib.literalExpression ''
        serial: yes
      '';
      description = ''
        A string which is prepended to limine.conf. The config format can be found [here](https://github.com/limine-bootloader/limine/blob/trunk/CONFIG.md).
      '';
    };

    extraEntries = lib.mkOption {
      default = "";
      type = lib.types.lines;
      example = lib.literalExpression ''
        /memtest86
          protocol: chainload
          path: boot():///efi/memtest86/memtest86.efi
      '';
      description = ''
        A string which is appended to the end of limine.conf. The config format can be found [here](https://github.com/limine-bootloader/limine/blob/trunk/CONFIG.md).
      '';
    };

    additionalFiles = lib.mkOption {
      default = { };
      type = lib.types.attrsOf lib.types.path;
      example = lib.literalExpression ''
        { "efi/memtest86/memtest86.efi" = "''${pkgs.memtest86-efi}/BOOTX64.efi"; }
      '';
      description = ''
        A set of files to be copied to {file}`/boot`. Each attribute name denotes the
        destination file name in {file}`/boot`, while the corresponding attribute value
        specifies the source file.
      '';
    };

    validateChecksums = lib.mkEnableOption null // {
      default = true;
      description = ''
        Whether to validate file checksums before booting.
      '';
    };

    panicOnChecksumMismatch = lib.mkEnableOption null // {
      description = ''
        Whether or not checksum validation failure should be a fatal
        error at boot time.
      '';
    };

    efiSupport = lib.mkEnableOption null // {
      default = pkgs.stdenv.hostPlatform.isEfi;
      defaultText = lib.literalExpression "pkgs.stdenv.hostPlatform.isEfi";
      description = ''
        Whether or not to install the limine EFI files.
      '';
    };

    efiInstallAsRemovable = lib.mkEnableOption null // {
      default = !efi.canTouchEfiVariables;
      defaultText = lib.literalExpression "!config.boot.loader.efi.canTouchEfiVariables";
      description = ''
        Whether or not to install the limine EFI files as removable.

        See {option}`boot.loader.grub.efiInstallAsRemovable`
      '';
    };

    biosSupport = lib.mkEnableOption null // {
      default = !cfg.efiSupport && pkgs.stdenv.hostPlatform.isx86;
      defaultText = lib.literalExpression "!config.boot.loader.limine.efiSupport && pkgs.stdenv.hostPlatform.isx86";
      description = ''
        Whether or not to install limine for BIOS.
      '';
    };

    biosDevice = lib.mkOption {
      default = "nodev";
      type = lib.types.str;
      description = ''
        Device to install the BIOS version of limine on.
      '';
    };

    partitionIndex = lib.mkOption {
      default = null;
      type = lib.types.nullOr lib.types.int;
      description = ''
        The 1-based index of the dedicated partition for limine's second stage.
      '';
    };

    enrollConfig = lib.mkEnableOption null // {
      default = cfg.panicOnChecksumMismatch;
      defaultText = lib.literalExpression "boot.loader.limine.panicOnChecksumMismatch";
      description = ''
        Whether or not to enroll the config.
        Only works on EFI!
      '';
    };

    forceMbr = lib.mkEnableOption null // {
      description = ''
        Force MBR detection to work even if the safety checks fail, use absolutely only if necessary!
      '';
    };

    secureBoot = {
      enable = lib.mkEnableOption null // {
        description = ''
          Whether to use sign the limine binary with sbctl.

          ::: {.note}
          This requires you to already have generated the keys and enrolled them with {command}`sbctl`.

          To create keys use {command}`sbctl create-keys`.

          To enroll them first reset secure boot to "Setup Mode". This is device specific.
          Then enroll them using {command}`sbctl enroll-keys -m -f`.

          You can now rebuild your system with this option enabled.

          Afterwards turn setup mode off and enable secure boot.
          :::
        '';
      };

      createAndEnrollKeys = lib.mkEnableOption null // {
        internal = true;
        description = ''
          Creates secure boot signing keys and enrolls them during bootloader installation.

          ::: {.note}
          This is used for automated nixos tests.
          NOT INTENDED to be used on a real system.
          :::
        '';
      };

      sbctl = lib.mkPackageOption pkgs "sbctl" { };
    };

    style = {
      wallpapers = lib.mkOption {
        default = [ ];
        example = lib.literalExpression "[ pkgs.nixos-artwork.wallpapers.simple-dark-gray-bootloader.gnomeFilePath ]";
        type = lib.types.listOf lib.types.path;
        description = ''
          A list of wallpapers.
          If more than one is specified, a random one will be selected at boot.
        '';
      };

      wallpaperStyle = lib.mkOption {
        default = "streched";
        type = lib.types.enum [
          "centered"
          "streched"
          "tiled"
        ];
        description = ''
          How the wallpaper should be fit to the screen.
        '';
      };

      backdrop = lib.mkOption {
        default = null;
        example = "7EBAE4";
        type = lib.types.nullOr lib.types.str;
        description = ''
          Color to fill the rest of the screen with when wallpaper_style is centered in RRGGBB format.
        '';
      };

      interface = {
        resolution = lib.mkOption {
          default = null;
          type = lib.types.nullOr lib.types.str;
          description = ''
            The resolution of the interface.
          '';
        };

        branding = lib.mkOption {
          default = null;
          type = lib.types.nullOr lib.types.str;
          description = ''
            The title at the top of the screen.
          '';
        };

        brandingColor = lib.mkOption {
          default = null;
          type = lib.types.nullOr lib.types.int;
          description = ''
            Color index of the title at the top of the screen in the range of 0-7 (Limine defaults to 6 (cyan)).
          '';
        };

        helpHidden = lib.mkEnableOption null // {
          description = ''
            Whether or not to hide the keybinds at the top of the screen.
          '';
        };
      };
      graphicalTerminal = {
        font = {
          scale = lib.mkOption {
            default = null;
            example = lib.literalExpression "2x2";
            type = lib.types.nullOr lib.types.str;
            description = ''
              The scale of the font in the format <width>x<height>.
            '';
          };

          spacing = lib.mkOption {
            default = null;
            type = lib.types.nullOr lib.types.int;
            description = ''
              The horizontal spacing between characters in pixels.
            '';
          };
        };

        palette = lib.mkOption {
          default = null;
          type = lib.types.nullOr lib.types.str;
          description = ''
            A ; seperated array of 8 colors in the format RRGGBB:
            black, red, green, brown, blue, magenta, cyan, and gray.
          '';
        };

        brightPalette = lib.mkOption {
          default = null;
          type = lib.types.nullOr lib.types.str;
          description = ''
            A ; seperated array of 8 colors in the format RRGGBB:
            dark gray, bright red, bright green, yellow, bright blue, bright magenta, bright cyan, and white.
          '';
        };

        foreground = lib.mkOption {
          default = null;
          type = lib.types.nullOr lib.types.str;
          description = ''
            Text foreground color (RRGGBB).
          '';
        };

        background = lib.mkOption {
          default = null;
          type = lib.types.nullOr lib.types.str;
          description = ''
            Text background color (TTRRGGBB). TT is transparency.
          '';
        };

        brightForeground = lib.mkOption {
          default = null;
          type = lib.types.nullOr lib.types.str;
          description = ''
            Text foreground bright color (RRGGBB).
          '';
        };

        brightBackground = lib.mkOption {
          default = null;
          type = lib.types.nullOr lib.types.str;
          description = ''
            Text background bright color (RRGGBB).
          '';
        };

        margin = lib.mkOption {
          default = null;
          type = lib.types.nullOr lib.types.int;
          description = ''
            The amount of margin around the terminal.
          '';
        };

        marginGradient = lib.mkOption {
          default = null;
          type = lib.types.nullOr lib.types.int;
          description = ''
            The thickness in pixels for the margin around the terminal.
          '';
        };
      };
    };
  };

  config = lib.mkMerge [
    {
      boot.loader.limine.style.wallpapers = lib.mkDefault [ defaultWallpaper ];
    }
    (lib.mkIf (cfg.style.wallpapers == [ defaultWallpaper ]) {
      boot.loader.limine.style.backdrop = lib.mkDefault "2F302F";
      boot.loader.limine.style.wallpaperStyle = lib.mkDefault "streched";
    })
    (lib.mkIf cfg.enable {
      assertions = [
        {
          assertion =
            pkgs.stdenv.hostPlatform.isx86_64
            || pkgs.stdenv.hostPlatform.isi686
            || pkgs.stdenv.hostPlatform.isAarch64;
          message = "Limine can only be installed on aarch64 & x86 platforms";
        }
        {
          assertion = cfg.efiSupport || cfg.biosSupport;
          message = "Both UEFI support and BIOS support for Limine are disabled, this will result in an unbootable system";
        }
      ];

      boot.loader.grub.enable = lib.mkDefault false;

      boot.loader.supportsInitrdSecrets = true;

      system = {
        boot.loader.id = "limine";
        build.installBootLoader = pkgs.replaceVarsWith {
          src = ./limine-install.py;
          isExecutable = true;
          replacements = {
            python3 = pkgs.python3.withPackages (python-packages: [ python-packages.psutil ]);
            configPath = limineInstallConfig;
          };
        };
      };
    })
    (lib.mkIf (cfg.enable && cfg.secureBoot.enable) {
      assertions = [
        {
          assertion = cfg.enrollConfig;
          message = "Disabling enrollConfig allows bypassing secure boot.";
        }
        {
          assertion = cfg.validateChecksums;
          message = "Disabling validateChecksums allows bypassing secure boot.";
        }
        {
          assertion = cfg.panicOnChecksumMismatch;
          message = "Disabling panicOnChecksumMismatch allows bypassing secure boot.";
        }
        {
          assertion = cfg.efiSupport;
          message = "Secure boot is only supported on EFI systems.";
        }
      ];

      boot.loader.limine.enrollConfig = true;
      boot.loader.limine.validateChecksums = true;
      boot.loader.limine.panicOnChecksumMismatch = true;
    })

    # Fwupd binary needs to be signed in secure boot mode
    (lib.mkIf (cfg.enable && cfg.secureBoot.enable && config.services.fwupd.enable) {
      systemd.services.fwupd = {
        environment.FWUPD_EFIAPPDIR = "/run/fwupd-efi";
      };

      systemd.services.fwupd-efi = {
        description = "Sign fwupd EFI app for secure boot";
        wantedBy = [ "fwupd.service" ];
        partOf = [ "fwupd.service" ];
        before = [ "fwupd.service" ];

        unitConfig.ConditionPathIsDirectory = "/var/lib/sbctl";
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          RuntimeDirectory = "fwupd-efi";
        };

        script = ''
          cp ${config.services.fwupd.package.fwupd-efi}/libexec/fwupd/efi/fwupd*.efi /run/fwupd-efi/
          chmod +w /run/fwupd-efi/fwupd*.efi
          ${lib.getExe cfg.secureBoot.sbctl} sign /run/fwupd-efi/fwupd*.efi
        '';
      };

      services.fwupd.uefiCapsuleSettings = {
        DisableShimForSecureBoot = true;
      };
    })
  ];
}
