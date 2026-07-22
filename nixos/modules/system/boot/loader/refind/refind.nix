{
  config,
  options,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    mkOption
    literalExpression
    types
    ;

  cfg = config.boot.loader.refind;
  efi = config.boot.loader.efi;
  refindInstallConfig = pkgs.writeText "refind-install.json" (
    builtins.toJSON {
      nixPath = config.nix.package;
      efiBootMgrPath = pkgs.efibootmgr;
      refindPath = cfg.package;
      efiMountPoint = efi.efiSysMountPoint;
      fileSystems = config.fileSystems;
      luksDevices = config.boot.initrd.luks.devices;
      canTouchEfiVariables = efi.canTouchEfiVariables;
      efiRemovable = cfg.efiInstallAsRemovable;
      maxGenerations = if cfg.maxGenerations == null then 0 else cfg.maxGenerations;
      hostArchitecture = pkgs.stdenv.hostPlatform.parsed.cpu;
      timeout = if config.boot.loader.timeout != null then config.boot.loader.timeout else 10;
      extraConfig = cfg.extraConfig;
      additionalFiles = cfg.additionalFiles;
    }
  );
in
{
  meta = {
    inherit (pkgs.refind.meta) maintainers;
  };

  options = {
    boot.loader.refind = {
      enable = mkEnableOption "the rEFInd boot loader";
      extraConfig = lib.mkOption {
        default = "";
        type = types.lines;
        description = ''
          A string which is prepended to refind.conf.
        '';
      };
      package = lib.mkPackageOption pkgs "refind" { };
      maxGenerations = lib.mkOption {
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
      efiInstallAsRemovable = mkEnableOption null // {
        default = !efi.canTouchEfiVariables;
        defaultText = literalExpression "!config.boot.loader.efi.canTouchEfiVariables";
        description = ''
          Whether or not to install the rEFInd EFI files as removable.

          See {option}`boot.loader.grub.efiInstallAsRemovable`
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion =
          pkgs.stdenv.hostPlatform.isx86_64
          || pkgs.stdenv.hostPlatform.isi686
          || pkgs.stdenv.hostPlatform.isAarch64;
        message = "rEFInd can only be installed on aarch64 & x86 platforms";
      }
      {
        assertion = pkgs.stdenv.hostPlatform.isEfi;
        message = "rEFInd can only be installed on UEFI platforms";
      }
    ];

    # Common attribute for boot loaders so only one of them can be
    # set at once.
    system = {
      boot.loader.id = "refind";
      build.installBootLoader = pkgs.replaceVarsWith {
        src = ./refind-install.py;
        isExecutable = true;
        replacements = {
          python3 = pkgs.python3.withPackages (python-packages: [ python-packages.psutil ]);
          configPath = refindInstallConfig;
        };
      };
    };
  };
}
