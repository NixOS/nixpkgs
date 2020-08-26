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
          example = literalExample "pkgs.device-tree_rpi";
          type = types.path;
          description = ''
            The path containing the base device-tree (.dtb) to boot. Contains
            device trees bundled with the Linux kernel by default.
          '';
        };

        name = mkOption {
          default = null;
          example = "some-dtb.dtb";
          type = types.nullOr types.str;
          description = ''
            The name of an explicit dtb to be loaded, relative to the dtb base.
            Useful in extlinux scenarios if the bootloader doesn't pick the
            right .dtb file from FDTDIR.
          '';
        };

        overlays = mkOption {
          default = [];
          example = literalExample
            "[\"\${pkgs.device-tree_rpi.overlays}/w1-gpio.dtbo\"]";
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
