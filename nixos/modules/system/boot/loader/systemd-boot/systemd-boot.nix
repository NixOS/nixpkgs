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
