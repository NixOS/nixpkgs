{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.boot.loader.gummiboot;

  efi = config.boot.loader.efi;

  gummibootBuilder = pkgs.substituteAll {
    src = ./gummiboot-builder.py;

    isExecutable = true;

    inherit (pkgs) python gummiboot;

    nix = config.nix.package.out;

    timeout = if config.boot.loader.timeout != null then config.boot.loader.timeout else "";

    inherit (efi) efiSysMountPoint canTouchEfiVariables;
  };
in {
  options.boot.loader.gummiboot = {
    enable = mkOption {
      default = false;

      type = types.bool;

      description = "Whether to enable the gummiboot UEFI boot manager";
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

    system = {
      build.installBootLoader = gummibootBuilder;

      boot.loader.id = "gummiboot";

      requiredKernelConfig = with config.lib.kernelConfig; [
        (isYes "EFI_STUB")
      ];
    };
  };
}
