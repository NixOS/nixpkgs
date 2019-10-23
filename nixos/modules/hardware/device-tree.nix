{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.hardware.deviceTree;
in {
  options = {
      hardware.deviceTree = {
        enable = mkOption {
          default = pkgs.stdenv.hostPlatform.platform.kernelDTB or false;
          type = types.bool;
          description = ''
            Build device tree files. These are used to describe the
            non-discoverable hardware of a system.
          '';
        };

        base = mkOption {
          default = "${config.boot.kernelPackages.kernel}/dtbs";
          defaultText = "\${config.boot.kernelPackages.kernel}/dtbs";
          example = literalExample "pkgs.deviceTree_rpi";
          type = types.path;
          description = ''
            The package containing the base device-tree (.dtb) to boot. Contains
            device trees bundled with the Linux kernel by default.
          '';
        };

        overlays = mkOption {
          default = [];
          example = literalExample
            "[\"\${pkgs.deviceTree_rpi.overlays}/w1-gpio.dtbo\"]";
          type = types.listOf types.path;
          description = ''
            A path containing device tree overlays (.dtbo) to be applied to all
            base device-trees.
          '';
        };

        package = mkOption {
          default = null;
          type = types.nullOr types.path;
          internal = true;
          description = ''
            A path containing the result of applying `overlays` to `base`.
          '';
        };
      };
  };

  config = mkIf (cfg.enable) {
    hardware.deviceTree.package = if (cfg.overlays != [])
      then pkgs.deviceTree.applyOverlays cfg.base cfg.overlays else cfg.base;
  };
}
