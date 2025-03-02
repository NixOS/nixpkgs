{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
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
    enable = mkOption {
      default = false;
      type = types.bool;
      description = ''
        Whether to enable the Limine bootloader.
      '';
    };

    enableEditor = mkOption {
      default = false;
      type = types.bool;
      description = ''
        Whether to allow editing the boot entries before booting them.
        It is recommended to set this to false, as it allows gaining root
        access by passing `init=/bin/sh` as a kernel parameter.
      '';
    };

    maxGenerations = mkOption {
      default = null;
      example = 50;
      type = types.nullOr types.int;
      description = ''
        Maximum number of latest generations in the boot menu.
        Useful to prevent boot partition of running out of disk space.
        `null` means no limit i.e. all generations that were not
        garbage collected yet.
      '';
    };

    extraConfig = mkOption {
      default = "";
      type = types.lines;
      example = literalExpression ''
        /memtest86
          protocol: chainload
          path: boot():///efi/memtest86/memtest86.efi
      '';
      description = ''
        A string which is appended to the end of limine.conf. The config format can be found [here](https://github.com/limine-bootloader/limine/blob/trunk/CONFIG.md).
      '';
    };

    additionalFiles = mkOption {
      default = { };
      type = types.attrsOf types.path;
      example = literalExpression ''
        { "efi/memtest86/memtest86.efi" = "''${pkgs.memtest86-efi}/BOOTX64.efi"; }
      '';
      description = ''
        A set of files to be copied to {file}`/boot`. Each attribute name denotes the
        destination file name in {file}`/boot`, while the corresponding attribute value
        specifies the source file.
      '';
    };

    useStorePaths = mkOption {
      default = false;
      type = types.bool;
      description = ''
        Use direct Nix store paths instead of copying boot files onto the boot partition. This is
        noticeably slower but can greatly reduce the space usage on the boot partition.
      '';
    };

    validateChecksums = mkOption {
      default = true;
      type = types.bool;
      description = ''
        Whether to validate file checksums before booting.
      '';
    };

    panicOnChecksumMismatch = mkOption {
      default = false;
      type = types.bool;
      description = ''
        Whether or not checksum validation failure should be a fatal
        error at boot time.
      '';
    };

    package = mkOption {
      default = pkgs.limine;
      defaultText = literalExpression "pkgs.limine";
      type = types.package;
      description = ''
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
      {
        assertion = pkgs.stdenv.hostPlatform.isEfi;
        message = "Limine can only be installed on EFI platforms";
      }
    ];

    boot.loader.grub.enable = mkDefault false;
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
