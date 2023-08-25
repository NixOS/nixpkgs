{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.boot.loader.systemd-boot;

  efi = config.boot.loader.efi;

  python3 = pkgs.python3.withPackages (ps: [ ps.packaging ]);

  systemdBootBuilder = pkgs.substituteAll {
    src = ./systemd-boot-builder.py;

    isExecutable = true;

    inherit python3;

    systemd = config.systemd.package;

    nix = config.nix.package.out;

    timeout = optionalString (config.boot.loader.timeout != null) config.boot.loader.timeout;

    editor = if cfg.editor then "True" else "False";

    configurationLimit = if cfg.configurationLimit == null then 0 else cfg.configurationLimit;

    inherit (cfg) consoleMode graceful;

    inherit (efi) efiSysMountPoint canTouchEfiVariables;

    inherit (config.system.nixos) distroName;

    memtest86 = optionalString cfg.memtest86.enable pkgs.memtest86plus;

    netbootxyz = optionalString cfg.netbootxyz.enable pkgs.netbootxyz-efi;

    copyExtraFiles = pkgs.writeShellScript "copy-extra-files" ''
      empty_file=$(${pkgs.coreutils}/bin/mktemp)

      ${concatStrings (mapAttrsToList (n: v: ''
        ${pkgs.coreutils}/bin/install -Dp "${v}" "${efi.efiSysMountPoint}/"${escapeShellArg n}
        ${pkgs.coreutils}/bin/install -D $empty_file "${efi.efiSysMountPoint}/efi/nixos/.extra-files/"${escapeShellArg n}
      '') cfg.extraFiles)}

      ${concatStrings (mapAttrsToList (n: v: ''
        ${pkgs.coreutils}/bin/install -Dp "${pkgs.writeText n v}" "${efi.efiSysMountPoint}/loader/entries/"${escapeShellArg n}
        ${pkgs.coreutils}/bin/install -D $empty_file "${efi.efiSysMountPoint}/efi/nixos/.extra-files/loader/entries/"${escapeShellArg n}
      '') cfg.extraEntries)}
    '';
  };

  checkedSystemdBootBuilder = pkgs.runCommand "systemd-boot" {
    nativeBuildInputs = [ pkgs.mypy python3 ];
  } ''
    install -m755 ${systemdBootBuilder} $out
    mypy \
      --no-implicit-optional \
      --disallow-untyped-calls \
      --disallow-untyped-defs \
      $out
  '';

  finalSystemdBootBuilder = pkgs.writeScript "install-systemd-boot.sh" ''
    #!${pkgs.runtimeShell}
    ${checkedSystemdBootBuilder} "$@"
    ${cfg.extraInstallCommands}
  '';
in {

  imports =
    [ (mkRenamedOptionModule [ "boot" "loader" "gummiboot" "enable" ] [ "boot" "loader" "systemd-boot" "enable" ])
    ];

  options.boot.loader.systemd-boot = {
    enable = mkOption {
      default = false;

      type = types.bool;

      description = lib.mdDoc "Whether to enable the systemd-boot (formerly gummiboot) EFI boot manager";
    };

    editor = mkOption {
      default = true;

      type = types.bool;

      description = lib.mdDoc ''
        Whether to allow editing the kernel command-line before
        boot. It is recommended to set this to false, as it allows
        gaining root access by passing init=/bin/sh as a kernel
        parameter. However, it is enabled by default for backwards
        compatibility.
      '';
    };

    configurationLimit = mkOption {
      default = null;
      example = 120;
      type = types.nullOr types.int;
      description = lib.mdDoc ''
        Maximum number of latest generations in the boot menu.
        Useful to prevent boot partition running out of disk space.

        `null` means no limit i.e. all generations
        that were not garbage collected yet.
      '';
    };

    extraInstallCommands = mkOption {
      default = "";
      example = ''
        default_cfg=$(cat /boot/loader/loader.conf | grep default | awk '{print $2}')
        init_value=$(cat /boot/loader/entries/$default_cfg | grep init= | awk '{print $2}')
        sed -i "s|@INIT@|$init_value|g" /boot/custom/config_with_placeholder.conf
      '';
      type = types.lines;
      description = lib.mdDoc ''
        Additional shell commands inserted in the bootloader installer
        script after generating menu entries. It can be used to expand
        on extra boot entries that cannot incorporate certain pieces of
        information (such as the resulting `init=` kernel parameter).
      '';
    };

    consoleMode = mkOption {
      default = "keep";

      type = types.enum [ "0" "1" "2" "auto" "max" "keep" ];

      description = lib.mdDoc ''
        The resolution of the console. The following values are valid:

        - `"0"`: Standard UEFI 80x25 mode
        - `"1"`: 80x50 mode, not supported by all devices
        - `"2"`: The first non-standard mode provided by the device firmware, if any
        - `"auto"`: Pick a suitable mode automatically using heuristics
        - `"max"`: Pick the highest-numbered available mode
        - `"keep"`: Keep the mode selected by firmware (the default)
      '';
    };

    memtest86 = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc ''
          Make MemTest86+ available from the systemd-boot menu. MemTest86+ is a
          program for testing memory.
        '';
      };

      entryFilename = mkOption {
        default = "memtest86.conf";
        type = types.str;
        description = lib.mdDoc ''
          `systemd-boot` orders the menu entries by the config file names,
          so if you want something to appear after all the NixOS entries,
          it should start with {file}`o` or onwards.
        '';
      };
    };

    netbootxyz = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc ''
          Make `netboot.xyz` available from the
          `systemd-boot` menu. `netboot.xyz`
          is a menu system that allows you to boot OS installers and
          utilities over the network.
        '';
      };

      entryFilename = mkOption {
        default = "o_netbootxyz.conf";
        type = types.str;
        description = lib.mdDoc ''
          `systemd-boot` orders the menu entries by the config file names,
          so if you want something to appear after all the NixOS entries,
          it should start with {file}`o` or onwards.
        '';
      };
    };

    extraEntries = mkOption {
      type = types.attrsOf types.lines;
      default = {};
      example = literalExpression ''
        { "memtest86.conf" = '''
          title MemTest86+
          efi /efi/memtest86/memtest.efi
        '''; }
      '';
      description = lib.mdDoc ''
        Any additional entries you want added to the `systemd-boot` menu.
        These entries will be copied to {file}`/boot/loader/entries`.
        Each attribute name denotes the destination file name,
        and the corresponding attribute value is the contents of the entry.

        `systemd-boot` orders the menu entries by the config file names,
        so if you want something to appear after all the NixOS entries,
        it should start with {file}`o` or onwards.
      '';
    };

    extraFiles = mkOption {
      type = types.attrsOf types.path;
      default = {};
      example = literalExpression ''
        { "efi/memtest86/memtest.efi" = "''${pkgs.memtest86plus}/memtest.efi"; }
      '';
      description = lib.mdDoc ''
        A set of files to be copied to {file}`/boot`.
        Each attribute name denotes the destination file name in
        {file}`/boot`, while the corresponding
        attribute value specifies the source file.
      '';
    };

    graceful = mkOption {
      default = false;

      type = types.bool;

      description = lib.mdDoc ''
        Invoke `bootctl install` with the `--graceful` option,
        which ignores errors when EFI variables cannot be written or when the EFI System Partition
        cannot be found. Currently only applies to random seed operations.

        Only enable this option if `systemd-boot` otherwise fails to install, as the
        scope or implication of the `--graceful` option may change in the future.
      '';
    };

  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = (config.boot.kernelPackages.kernel.features or { efiBootStub = true; }) ? efiBootStub;
        message = "This kernel does not support the EFI boot stub";
      }
    ] ++ concatMap (filename: [
      {
        assertion = !(hasInfix "/" filename);
        message = "boot.loader.systemd-boot.extraEntries.${lib.strings.escapeNixIdentifier filename} is invalid: entries within folders are not supported";
      }
      {
        assertion = hasSuffix ".conf" filename;
        message = "boot.loader.systemd-boot.extraEntries.${lib.strings.escapeNixIdentifier filename} is invalid: entries must have a .conf file extension";
      }
    ]) (builtins.attrNames cfg.extraEntries)
      ++ concatMap (filename: [
        {
          assertion = !(hasPrefix "/" filename);
          message = "boot.loader.systemd-boot.extraFiles.${lib.strings.escapeNixIdentifier filename} is invalid: paths must not begin with a slash";
        }
        {
          assertion = !(hasInfix ".." filename);
          message = "boot.loader.systemd-boot.extraFiles.${lib.strings.escapeNixIdentifier filename} is invalid: paths must not reference the parent directory";
        }
        {
          assertion = !(hasInfix "nixos/.extra-files" (toLower filename));
          message = "boot.loader.systemd-boot.extraFiles.${lib.strings.escapeNixIdentifier filename} is invalid: files cannot be placed in the nixos/.extra-files directory";
        }
      ]) (builtins.attrNames cfg.extraFiles);

    boot.loader.grub.enable = mkDefault false;

    boot.loader.supportsInitrdSecrets = true;

    boot.loader.systemd-boot.extraFiles = mkMerge [
      (mkIf cfg.memtest86.enable {
        "efi/memtest86/memtest.efi" = "${pkgs.memtest86plus.efi}";
      })
      (mkIf cfg.netbootxyz.enable {
        "efi/netbootxyz/netboot.xyz.efi" = "${pkgs.netbootxyz-efi}";
      })
    ];

    boot.loader.systemd-boot.extraEntries = mkMerge [
      (mkIf cfg.memtest86.enable {
        "${cfg.memtest86.entryFilename}" = ''
          title  MemTest86
          efi    /efi/memtest86/memtest.efi
        '';
      })
      (mkIf cfg.netbootxyz.enable {
        "${cfg.netbootxyz.entryFilename}" = ''
          title  netboot.xyz
          efi    /efi/netbootxyz/netboot.xyz.efi
        '';
      })
    ];

    system = {
      build.installBootLoader = finalSystemdBootBuilder;

      boot.loader.id = "systemd-boot";

      requiredKernelConfig = with config.lib.kernelConfig; [
        (isYes "EFI_STUB")
      ];
    };
  };
}
