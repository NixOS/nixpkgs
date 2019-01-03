{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.boot.loader.systemd-boot;

  efi = config.boot.loader.efi;

  gummibootBuilder = pkgs.substituteAll {
    src = ./systemd-boot-builder.py;

    isExecutable = true;

    inherit (pkgs.buildPackages) python3;

    systemd = config.systemd.package;

    nix = config.nix.package.out;

    timeout = if config.boot.loader.timeout != null then config.boot.loader.timeout else "";

    editor = if cfg.editor then "True" else "False";

    inherit (cfg) consoleMode;

    inherit (efi) efiSysMountPoint canTouchEfiVariables;
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

    consoleMode = mkOption {
      default = "keep";

      type = types.enum [ "0" "1" "2" "auto" "max" "keep" ];

      description = ''
        The resolution of the console. The following values are valid:
        </para>
        <para>
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
