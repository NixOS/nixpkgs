{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.hardware.deviceTree;
  overlayType = types.submodule {
    options = {
      overlay = mkOption {
        type = types.either (types.enum [ "-" ]) types.path;
        description = "The overlay file to apply";
        example = literalExample "[\"\${pkgs.deviceTree_rpi.overlays}/w1-gpio.dtbo\"]";
      };
      params = mkOption {
        type = types.listOf types.str;
        default = [];
        example = [ "i2s=on" ];
        description = "The parameters to the overlay file.";
      };
    };
  };
  builders = {
    dtc = pkgs.deviceTree.applyOverlays;
    dtmerge = pkgs.deviceTree.mergeOverlays;
  };
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
          type = types.listOf overlayType;
          description = ''
            A path containing device tree overlays (.dtbo) and parameters to be
            applied to all base device-trees.
          '';
        };

        # see https://github.com/raspberrypi/linux/issues/3198
        builder = mkOption {
          default = "dtc";
          type = types.enum (attrNames builders);
          description = ''
            Whether to use `dtc` or `dtmerge` to build the overlay. Use of
            parameters and some Raspberry Pi overlays require `dtmerge`, but
            this is only available for ARM.
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
      then (getAttr cfg.builder builders) cfg.base cfg.overlays else cfg.base;
      assertions = [{
        assertion = (cfg.builder == "dtc") -> (all (o: length o.params == 0) cfg.overlays);
        message = "The `dtc` builder does not support overlay parameters";
      }];
  };
}
