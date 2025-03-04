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
      luksDevices = config.boot.initrd.luks.devices;
      canTouchEfiVariables = efi.canTouchEfiVariables;
      efiSupport = cfg.efiSupport;
      biosSupport = cfg.biosSupport;
      biosDevice = cfg.biosDevice;
      partitionIndex = cfg.partitionIndex;
      forceMbr = cfg.forceMbr;
      enrollConfig = cfg.enrollConfig;
      maxGenerations = if cfg.maxGenerations == null then 0 else cfg.maxGenerations;
      hostArchitecture = pkgs.stdenv.hostPlatform.parsed.cpu;
      timeout = if config.boot.loader.timeout != null then config.boot.loader.timeout else 10;
      enableEditor = cfg.enableEditor;
      extraConfig = cfg.extraConfig;
      additionalFiles = cfg.additionalFiles;
      useStorePaths = cfg.useStorePaths;
      validateChecksums = cfg.validateChecksums;
      panicOnChecksumMismatch = cfg.panicOnChecksumMismatch;
    }
  );
in
{
  meta.maintainers = with lib.maintainers; [
    lzcunt
    phip1611
    programmerlexi
  ];

  options.boot.loader.limine = {
    enable = lib.mkEnableOption "Whether to enable the Limine bootloader.";

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

    useStorePaths = lib.mkEnableOption null // {
      description = ''
        Use direct Nix store paths instead of copying boot files onto the boot partition. This is
        noticeably slower but can greatly reduce the space usage on the boot partition.
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

    package = lib.mkPackageOption pkgs "limine" { };

    efiSupport = lib.mkEnableOption null // {
      default = pkgs.stdenv.hostPlatform.isEfi;
      defaultText = lib.literalExpression "pkgs.stdenv.hostPlatform.isEfi";
      description = ''
        Whether or not to install the limine EFI files.
      '';
    };

    biosSupport = lib.mkEnableOption null // {
      default = !cfg.efiSupport && pkgs.stdenv.hostPlatform.isx86;
      defaultText = lib.literalExpression "!boot.loader.limine.efiSupport && pkgs.stdenv.hostPlatform.isx86";
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
  };

  config = lib.mkIf cfg.enable {
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
    system = {
      boot.loader.id = "limine";
      build.installBootLoader = pkgs.substituteAll {
        src = ./limine-install.py;
        isExecutable = true;

        python3 = pkgs.python3.withPackages (python-packages: [ python-packages.psutil ]);
        configPath = limineInstallConfig;
      };
    };
  };
}
