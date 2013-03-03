{ config, pkgs, ... }:

with pkgs.lib;

let
  cfg = config.boot.loader.gummiboot;

  efi = config.boot.loader.efi;

  gummibootBuilder = pkgs.substituteAll {
    src = ./gummiboot-builder.py;

    isExecutable = true;

    inherit (pkgs) python gummiboot;

    inherit (config.environment) nix;

    inherit (cfg) timeout;

    inherit (efi) efiSysMountPoint canTouchEfiVariables;
  };
in {
  options.boot.loader.gummiboot = {
    enable = mkOption {
      default = false;

      type = types.bool;

      description = "Whether to enable the gummiboot UEFI boot manager";
    };

    timeout = mkOption {
      default = null;

      example = 4;

      type = types.nullOr types.int;

      description = ''
        Timeout (in seconds) for how long to show the menu (null if none).
        Note that even with no timeout the menu can be forced if the space
        key is pressed during bootup
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

    system = {
      build.installBootLoader = gummibootBuilder;

      boot.loader.id = "gummiboot";

      requiredKernelConfig = with config.lib.kernelConfig; [
        (isYes "EFI_STUB")
      ];
    };
  };
}
