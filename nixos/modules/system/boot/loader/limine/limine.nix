{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.boot.loader.limine;
  efi = config.boot.loader.efi;
  limineInstallConfig = pkgs.writeText "limine-install.json" (builtins.toJSON {
    nixPath = config.nix.package;
    efiBootMgrPath = pkgs.efibootmgr;
    liminePath = cfg.package;
    efiMountPoint = efi.efiSysMountPoint;
    fileSystems = config.fileSystems;
    luksDevices = config.boot.initrd.luks.devices;
    canTouchEfiVariables = efi.canTouchEfiVariables;
    maxGenerations = if cfg.maxGenerations == null then 0 else cfg.maxGenerations;
    hostArchitecture = pkgs.stdenv.hostPlatform.parsed.cpu;
    timeout = if config.boot.loader.timeout != null then config.boot.loader.timeout else 10;
    enableEditor = cfg.enableEditor;
    additionalEntries = cfg.additionalEntries;
    additionalFiles = cfg.additionalFiles;
    forceMbr = cfg.forceMbr;
    useStorePaths = cfg.useStorePaths;
    validateChecksums = cfg.validateChecksums;
    panicOnChecksumMismatch = cfg.panicOnChecksumMismatch;
  });

in
{
  options.boot.loader.limine = {
    enable = mkOption {
      default = false;
      type = types.bool;
      description = mdDoc ''
        Whether to enable the Limine bootloader.
      '';
    };

    enableEditor = mkOption {
      default = true;
      type = types.bool;
      description = mdDoc ''
        Whether to allow editing the boot entries before booting them.
        It is recommended to set this to false, as it allows gaining root
        access by passing `init=/bin/sh` as a kernel parameter.
      '';
    };

    maxGenerations = mkOption {
      default = 10;
      example = 50;
      type = types.nullOr types.int;
      description = mdDoc ''
        Maximum number of latest generations in the boot menu.
        Useful to prevent boot partition of running out of disk space.

        `null` means no limit i.e. all generations that were not
        garbage collected yet.
      '';
    };

    additionalEntries = mkOption {
      default = { };
      type = types.attrsOf types.str;
      example = literalExpression ''
        {
          "memtest86" = '''
            PROTOCOL=chainload
            IMAGE_PATH=boot:///efi/memtest86/memtest86.efi
          ''';
        }
      '';
      description = mdDoc ''
        Any additional entries you want added to the Limine boot menu. Each attribute denotes
        the display name of the boot entry, which need be formatted according to the Limine
        documentation which you can find [here](https://github.com/limine-bootloader/limine/blob/trunk/CONFIG.md).
      '';
    };

    additionalFiles = mkOption {
      default = { };
      type = types.attrsOf types.path;
      example = literalExpression ''
        { "efi/memtest86/memtest86.efi" = "''${pkgs.memtest86-efi}/BOOTX64.efi"; }
      '';
      description = mdDoc ''
        A set of files to be copied to {file}`/boot`. Each attribute name denotes the
        destination file name in {file}`/boot`, while the corresponding attribute value
        specifies the source file.
      '';
    };

    forceMbr = mkOption {
      default = false;
      type = types.bool;
      description = mdDoc ''
        Force MBR detection to work even if the safety checks fail, use absolutely only if necessary!
      '';
    };

    useStorePaths = mkOption {
      default = false;
      type = types.bool;
      description = mdDoc ''
        Use direct Nix store paths instead of copying boot files onto the boot partition. This is
        noticeably slower but can greatly reduce the space usage on the boot partition.
      '';
    };

    validateChecksums = mkOption {
      default = true;
      type = types.bool;
      description = mdDoc ''
        Whether to validate file checksums before booting.
      '';
    };

    panicOnChecksumMismatch = mkOption {
      default = false;
      type = types.bool;
      description = mdDoc ''
        Whether or not checksum validation failure should be a fatal
        error at boot time.
      '';
    };

    package = mkOption {
      default = pkgs.limine;
      defaultText = literalExpression "pkgs.limine";
      type = types.package;
      description = mdDoc ''
        Which Limine package to use for installation.
      '';
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = pkgs.stdenv.hostPlatform.isx86;
        message = "Limine can only be installed on x86 platforms";
      }
    ];

    boot.loader.grub.enable = mkDefault false;
    system = {
      boot.loader.id = "limine";
      build.installBootLoader = pkgs.substituteAll {
        src = ./limine-install.py;
        isExecutable = true;

        python3 = (pkgs.python3.withPackages (python-packages: [ python-packages.psutil ]));
        configPath = limineInstallConfig;
      };
    };
  };
}
