{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.boot.loader.systemd-boot;

  efi = config.boot.loader.efi;

  systemdBootBuilder = pkgs.substituteAll {
    src = ./systemd-boot-builder.py;

    isExecutable = true;

    inherit (pkgs) python3;

    systemd = config.systemd.package;

    nix = config.nix.package.out;

    timeout = if config.boot.loader.timeout != null then config.boot.loader.timeout else "";

    editor = if cfg.editor then "True" else "False";

    configurationLimit = if cfg.configurationLimit == null then 0 else cfg.configurationLimit;

    inherit (cfg) consoleMode graceful;

    inherit (efi) efiSysMountPoint canTouchEfiVariables;

    memtest86 = if cfg.memtest86.enable then pkgs.memtest86-efi else "";

    netbootxyz = if cfg.netbootxyz.enable then pkgs.netbootxyz-efi else "";

    copyExtraFiles = pkgs.writeShellScript "copy-extra-files" ''
      empty_file=$(mktemp)

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
    nativeBuildInputs = [ pkgs.mypy ];
  } ''
    install -m755 ${systemdBootBuilder} $out
    mypy \
      --no-implicit-optional \
      --disallow-untyped-calls \
      --disallow-untyped-defs \
      $out
  '';
in {

  imports =
    [ (mkRenamedOptionModule [ "boot" "loader" "gummiboot" "enable" ] [ "boot" "loader" "systemd-boot" "enable" ])
    ];

  options.boot.loader.systemd-boot = {
    enable = mkOption {
      default = false;

      type = types.bool;

      description = "Whether to enable the systemd-boot (formerly gummiboot) EFI boot manager";
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

    configurationLimit = mkOption {
      default = null;
      example = 120;
      type = types.nullOr types.int;
      description = ''
        Maximum number of latest generations in the boot menu.
        Useful to prevent boot partition running out of disk space.

        <literal>null</literal> means no limit i.e. all generations
        that were not garbage collected yet.
      '';
    };

    consoleMode = mkOption {
      default = "keep";

      type = types.enum [ "0" "1" "2" "auto" "max" "keep" ];

      description = ''
        The resolution of the console. The following values are valid:

        <itemizedlist>
          <listitem><para>
            <literal>"0"</literal>: Standard UEFI 80x25 mode
          </para></listitem>
          <listitem><para>
            <literal>"1"</literal>: 80x50 mode, not supported by all devices
          </para></listitem>
          <listitem><para>
            <literal>"2"</literal>: The first non-standard mode provided by the device firmware, if any
          </para></listitem>
          <listitem><para>
            <literal>"auto"</literal>: Pick a suitable mode automatically using heuristics
          </para></listitem>
          <listitem><para>
            <literal>"max"</literal>: Pick the highest-numbered available mode
          </para></listitem>
          <listitem><para>
            <literal>"keep"</literal>: Keep the mode selected by firmware (the default)
          </para></listitem>
        </itemizedlist>
      '';
    };

    memtest86 = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Make MemTest86 available from the systemd-boot menu. MemTest86 is a
          program for testing memory.  MemTest86 is an unfree program, so
          this requires <literal>allowUnfree</literal> to be set to
          <literal>true</literal>.
        '';
      };

      entryFilename = mkOption {
        default = "memtest86.conf";
        type = types.str;
        description = ''
          <literal>systemd-boot</literal> orders the menu entries by the config file names,
          so if you want something to appear after all the NixOS entries,
          it should start with <filename>o</filename> or onwards.
        '';
      };
    };

    netbootxyz = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Make <literal>netboot.xyz</literal> available from the
          <literal>systemd-boot</literal> menu. <literal>netboot.xyz</literal>
          is a menu system that allows you to boot OS installers and
          utilities over the network.
        '';
      };

      entryFilename = mkOption {
        default = "o_netbootxyz.conf";
        type = types.str;
        description = ''
          <literal>systemd-boot</literal> orders the menu entries by the config file names,
          so if you want something to appear after all the NixOS entries,
          it should start with <filename>o</filename> or onwards.
        '';
      };
    };

    extraEntries = mkOption {
      type = types.attrsOf types.lines;
      default = {};
      example = literalExpression ''
        { "memtest86.conf" = '''
          title MemTest86
          efi /efi/memtest86/memtest86.efi
        '''; }
      '';
      description = ''
        Any additional entries you want added to the <literal>systemd-boot</literal> menu.
        These entries will be copied to <filename>/boot/loader/entries</filename>.
        Each attribute name denotes the destination file name,
        and the corresponding attribute value is the contents of the entry.

        <literal>systemd-boot</literal> orders the menu entries by the config file names,
        so if you want something to appear after all the NixOS entries,
        it should start with <filename>o</filename> or onwards.
      '';
    };

    extraFiles = mkOption {
      type = types.attrsOf types.path;
      default = {};
      example = literalExpression ''
        { "efi/memtest86/memtest86.efi" = "''${pkgs.memtest86-efi}/BOOTX64.efi"; }
      '';
      description = ''
        A set of files to be copied to <filename>/boot</filename>.
        Each attribute name denotes the destination file name in
        <filename>/boot</filename>, while the corresponding
        attribute value specifies the source file.
      '';
    };

    graceful = mkOption {
      default = false;

      type = types.bool;

      description = ''
        Invoke <literal>bootctl install</literal> with the <literal>--graceful</literal> option,
        which ignores errors when EFI variables cannot be written or when the EFI System Partition
        cannot be found. Currently only applies to random seed operations.

        Only enable this option if <literal>systemd-boot</literal> otherwise fails to install, as the
        scope or implication of the <literal>--graceful</literal> option may change in the future.
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
      # TODO: This is hard-coded to use the 64-bit EFI app, but it could probably
      # be updated to use the 32-bit EFI app on 32-bit systems.  The 32-bit EFI
      # app filename is BOOTIA32.efi.
      (mkIf cfg.memtest86.enable {
        "efi/memtest86/BOOTX64.efi" = "${pkgs.memtest86-efi}/BOOTX64.efi";
      })
      (mkIf cfg.netbootxyz.enable {
        "efi/netbootxyz/netboot.xyz.efi" = "${pkgs.netbootxyz-efi}";
      })
    ];

    boot.loader.systemd-boot.extraEntries = mkMerge [
      (mkIf cfg.memtest86.enable {
        "${cfg.memtest86.entryFilename}" = ''
          title  MemTest86
          efi    /efi/memtest86/BOOTX64.efi
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
      build.installBootLoader = checkedSystemdBootBuilder;

      boot.loader.id = "systemd-boot";

      requiredKernelConfig = with config.lib.kernelConfig; [
        (isYes "EFI_STUB")
      ];
    };
  };
}
