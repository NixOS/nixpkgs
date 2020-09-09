{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.boot.loader.systemd-boot;

  efi = config.boot.loader.efi;

  gummibootBuilder = pkgs.substituteAll {
    src = ./systemd-boot-builder.py;

    isExecutable = true;

    inherit (pkgs) python3;

    systemd = config.systemd.package;

    nix = config.nix.package.out;

    timeout = if config.boot.loader.timeout != null then config.boot.loader.timeout else "";

    editor = if cfg.editor then "True" else "False";

    configurationLimit = if cfg.configurationLimit == null then 0 else cfg.configurationLimit;

    inherit (cfg) consoleMode;

    inherit (efi) efiSysMountPoint canTouchEfiVariables;

    memtest86 = if cfg.memtest86.enable then pkgs.memtest86-efi else "";
  };
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
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = (config.boot.kernelPackages.kernel.features or { efiBootStub = true; }) ? efiBootStub;

        message = "This kernel does not support the EFI boot stub";
      }
    ];

    boot.loader.grub.enable = mkDefault false;

    boot.loader.supportsInitrdSecrets = true;

    system = {
      build.installBootLoader = gummibootBuilder;

      boot.loader.id = "systemd-boot";

      requiredKernelConfig = with config.lib.kernelConfig; [
        (isYes "EFI_STUB")
      ];
    };
  };
}
