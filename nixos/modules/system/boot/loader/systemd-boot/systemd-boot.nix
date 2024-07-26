{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.boot.loader.systemd-boot;

  efi = config.boot.loader.efi;

  # We check the source code in a derivation that does not depend on the
  # system configuration so that most users don't have to redo the check and require
  # the necessary dependencies.
  checkedSource = pkgs.runCommand "systemd-boot" {
    preferLocalBuild = true;
  } ''
    install -m755 -D ${./systemd-boot-builder.py} $out
    ${lib.getExe pkgs.buildPackages.mypy} \
      --no-implicit-optional \
      --disallow-untyped-calls \
      --disallow-untyped-defs \
      $out
  '';

  systemdBootBuilder = pkgs.substituteAll rec {
    name = "systemd-boot";

    src = checkedSource;

    isExecutable = true;

    inherit (pkgs) python3;

    systemd = config.systemd.package;

    bootspecTools = pkgs.bootspec;

    nix = config.nix.package.out;

    timeout = optionalString (config.boot.loader.timeout != null) config.boot.loader.timeout;

    configurationLimit = if cfg.configurationLimit == null then 0 else cfg.configurationLimit;

    inherit (cfg) consoleMode graceful editor;

    inherit (efi) efiSysMountPoint canTouchEfiVariables;

    bootMountPoint = if cfg.xbootldrMountPoint != null
      then cfg.xbootldrMountPoint
      else efi.efiSysMountPoint;

    nixosDir = "/EFI/nixos";

    inherit (config.system.nixos) distroName;

    memtest86 = optionalString cfg.memtest86.enable pkgs.memtest86plus;

    netbootxyz = optionalString cfg.netbootxyz.enable pkgs.netbootxyz-efi;

    checkMountpoints = pkgs.writeShellScript "check-mountpoints" ''
      fail() {
        echo "$1 = '$2' is not a mounted partition. Is the path configured correctly?" >&2
        exit 1
      }
      ${pkgs.util-linuxMinimal}/bin/findmnt ${efiSysMountPoint} > /dev/null || fail efiSysMountPoint ${efiSysMountPoint}
      ${lib.optionalString
        (cfg.xbootldrMountPoint != null)
        "${pkgs.util-linuxMinimal}/bin/findmnt ${cfg.xbootldrMountPoint} > /dev/null || fail xbootldrMountPoint ${cfg.xbootldrMountPoint}"}
    '';

    copyExtraFiles = pkgs.writeShellScript "copy-extra-files" ''
      empty_file=$(${pkgs.coreutils}/bin/mktemp)

      ${concatStrings (mapAttrsToList (n: v: ''
        ${pkgs.coreutils}/bin/install -Dp "${v}" "${bootMountPoint}/"${escapeShellArg n}
        ${pkgs.coreutils}/bin/install -D $empty_file "${bootMountPoint}/${nixosDir}/.extra-files/"${escapeShellArg n}
      '') cfg.extraFiles)}

      ${concatStrings (mapAttrsToList (n: v: ''
        ${pkgs.coreutils}/bin/install -Dp "${pkgs.writeText n v}" "${bootMountPoint}/loader/entries/"${escapeShellArg n}
        ${pkgs.coreutils}/bin/install -D $empty_file "${bootMountPoint}/${nixosDir}/.extra-files/loader/entries/"${escapeShellArg n}
      '') cfg.extraEntries)}
    '';
  };

  finalSystemdBootBuilder = pkgs.writeScript "install-systemd-boot.sh" ''
    #!${pkgs.runtimeShell}
    ${systemdBootBuilder} "$@"
    ${cfg.extraInstallCommands}
  '';
in {

  meta.maintainers = with lib.maintainers; [ julienmalka ];

  imports =
    [ (mkRenamedOptionModule [ "boot" "loader" "gummiboot" "enable" ] [ "boot" "loader" "systemd-boot" "enable" ])
      (lib.mkChangedOptionModule
        [ "boot" "loader" "systemd-boot" "memtest86" "entryFilename" ]
        [ "boot" "loader" "systemd-boot" "memtest86" "sortKey" ]
        (config: lib.strings.removeSuffix ".conf" config.boot.loader.systemd-boot.memtest86.entryFilename)
      )
      (lib.mkChangedOptionModule
        [ "boot" "loader" "systemd-boot" "netbootxyz" "entryFilename" ]
        [ "boot" "loader" "systemd-boot" "netbootxyz" "sortKey" ]
        (config: lib.strings.removeSuffix ".conf" config.boot.loader.systemd-boot.netbootxyz.entryFilename)
      )
    ];

  options.boot.loader.systemd-boot = {
    enable = mkOption {
      default = false;

      type = types.bool;

      description = ''
        Whether to enable the systemd-boot (formerly gummiboot) EFI boot manager.
        For more information about systemd-boot:
        https://www.freedesktop.org/wiki/Software/systemd/systemd-boot/
      '';
    };

    sortKey = mkOption {
      default = "nixos";
      type = lib.types.str;
      description = ''
        The sort key used for the NixOS bootloader entries.
        This key determines sorting relative to non-NixOS entries.
        See also https://uapi-group.org/specifications/specs/boot_loader_specification/#sorting

        This option can also be used to control the sorting of NixOS specialisations.

        By default, specialisations inherit the sort key of their parent generation
        and will have the same value for both the sort-key and the version (i.e. the generation number),
        systemd-boot will therefore sort them based on their file name, meaning that
        in your boot menu you will have each main generation directly followed by
        its specialisations sorted alphabetically by their names.

        If you want a different ordering for a specialisation, you can override
        its sort-key which will cause the specialisation to be uncoupled from its
        parent generation. It will then be sorted by its new sort-key just like
        any other boot entry.

        The sort-key is stored in the generation's bootspec, which means that
        generations keep their sort-keys even if the original definition of the
        generation was removed from the NixOS configuration.
        It also means that updating the sort-key will only affect new generations,
        while old ones will keep the sort-key that they were originally built with.
      '';
    };

    editor = mkOption {
      default = true;

      type = types.bool;

      description = ''
        Whether to allow editing the kernel command-line before
        boot. It is recommended to set this to false, as it allows
        gaining root access by passing init=/bin/sh as a kernel
        parameter. However, it is enabled by default for backwards
        compatibility.
      '';
    };

    xbootldrMountPoint = mkOption {
      default = null;
      type = types.nullOr types.str;
      description = ''
        Where the XBOOTLDR partition is mounted.

        If set, this partition will be used as $BOOT to store boot loader entries and extra files
        instead of the EFI partition. As per the bootloader specification, it is recommended that
        the EFI and XBOOTLDR partitions be mounted at `/efi` and `/boot`, respectively.
      '';
    };

    configurationLimit = mkOption {
      default = null;
      example = 120;
      type = types.nullOr types.int;
      description = ''
        Maximum number of latest generations in the boot menu.
        Useful to prevent boot partition running out of disk space.

        `null` means no limit i.e. all generations
        that have not been garbage collected yet.
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
      description = ''
        Additional shell commands inserted in the bootloader installer
        script after generating menu entries. It can be used to expand
        on extra boot entries that cannot incorporate certain pieces of
        information (such as the resulting `init=` kernel parameter).
      '';
    };

    consoleMode = mkOption {
      default = "keep";

      type = types.enum [ "0" "1" "2" "auto" "max" "keep" ];

      description = ''
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
        description = ''
          Make Memtest86+ available from the systemd-boot menu. Memtest86+ is a
          program for testing memory.
        '';
      };

      sortKey = mkOption {
        default = "o_memtest86";
        type = types.str;
        description = ''
          `systemd-boot` orders the menu entries by their sort keys,
          so if you want something to appear after all the NixOS entries,
          it should start with {file}`o` or onwards.

          See also {option}`boot.loader.systemd-boot.sortKey`.
        '';
      };
    };

    netbootxyz = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Make `netboot.xyz` available from the
          `systemd-boot` menu. `netboot.xyz`
          is a menu system that allows you to boot OS installers and
          utilities over the network.
        '';
      };

      sortKey = mkOption {
        default = "o_netbootxyz";
        type = types.str;
        description = ''
          `systemd-boot` orders the menu entries by their sort keys,
          so if you want something to appear after all the NixOS entries,
          it should start with {file}`o` or onwards.

          See also {option}`boot.loader.systemd-boot.sortKey`.
        '';
      };
    };

    extraEntries = mkOption {
      type = types.attrsOf types.lines;
      default = {};
      example = literalExpression ''
        { "memtest86.conf" = '''
          title Memtest86+
          efi /efi/memtest86/memtest.efi
          sort-key z_memtest
        '''; }
      '';
      description = ''
        Any additional entries you want added to the `systemd-boot` menu.
        These entries will be copied to {file}`$BOOT/loader/entries`.
        Each attribute name denotes the destination file name,
        and the corresponding attribute value is the contents of the entry.

        To control the ordering of the entry in the boot menu, use the sort-key
        field, see
        https://uapi-group.org/specifications/specs/boot_loader_specification/#sorting
        and {option}`boot.loader.systemd-boot.sortKey`.
      '';
    };

    extraFiles = mkOption {
      type = types.attrsOf types.path;
      default = {};
      example = literalExpression ''
        { "efi/memtest86/memtest.efi" = "''${pkgs.memtest86plus}/memtest.efi"; }
      '';
      description = ''
        A set of files to be copied to {file}`$BOOT`.
        Each attribute name denotes the destination file name in
        {file}`$BOOT`, while the corresponding
        attribute value specifies the source file.
      '';
    };

    graceful = mkOption {
      default = false;

      type = types.bool;

      description = ''
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
        assertion = (hasPrefix "/" efi.efiSysMountPoint);
        message = "The ESP mount point '${toString efi.efiSysMountPoint}' must be an absolute path";
      }
      {
        assertion = cfg.xbootldrMountPoint == null || (hasPrefix "/" cfg.xbootldrMountPoint);
        message = "The XBOOTLDR mount point '${toString cfg.xbootldrMountPoint}' must be an absolute path";
      }
      {
        assertion = cfg.xbootldrMountPoint != efi.efiSysMountPoint;
        message = "The XBOOTLDR mount point '${toString cfg.xbootldrMountPoint}' cannot be the same as the ESP mount point '${toString efi.efiSysMountPoint}'";
      }
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
        "memtest86.conf" = ''
          title  Memtest86+
          efi    /efi/memtest86/memtest.efi
          sort-key ${cfg.memtest86.sortKey}
        '';
      })
      (mkIf cfg.netbootxyz.enable {
        "netbootxyz.conf" = ''
          title  netboot.xyz
          efi    /efi/netbootxyz/netboot.xyz.efi
          sort-key ${cfg.netbootxyz.sortKey}
        '';
      })
    ];

    boot.bootspec.extensions."org.nixos.systemd-boot" = {
      inherit (config.boot.loader.systemd-boot) sortKey;
    };

    system = {
      build.installBootLoader = finalSystemdBootBuilder;

      boot.loader.id = "systemd-boot";

      requiredKernelConfig = with config.lib.kernelConfig; [
        (isYes "EFI_STUB")
      ];
    };
  };
}
