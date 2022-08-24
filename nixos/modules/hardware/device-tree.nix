{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.hardware.deviceTree;

  overlayType = types.submodule {
    options = {
      name = mkOption {
        type = types.str;
        description = lib.mdDoc ''
          Name of this overlay
        '';
      };

      filter = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "*rpi*.dtb";
        description = lib.mdDoc ''
          Only apply to .dtb files matching glob expression.
        '';
      };

      dtsFile = mkOption {
        type = types.nullOr types.path;
        description = lib.mdDoc ''
          Path to .dts overlay file, overlay is applied to
          each .dtb file matching "compatible" of the overlay.
        '';
        default = null;
        example = literalExpression "./dts/overlays.dts";
      };

      dtsText = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = lib.mdDoc ''
          Literal DTS contents, overlay is applied to
          each .dtb file matching "compatible" of the overlay.
        '';
        example = ''
          /dts-v1/;
          /plugin/;
          / {
                  compatible = "raspberrypi";
          };
          &{/soc} {
                  pps {
                          compatible = "pps-gpio";
                          status = "okay";
                  };
          };
        '';
      };

      dtboFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = lib.mdDoc ''
          Path to .dtbo compiled overlay file.
        '';
      };
    };
  };

  filterDTBs = src: if isNull cfg.filter
    then "${src}/dtbs"
    else
      pkgs.runCommand "dtbs-filtered" {} ''
        mkdir -p $out
        cd ${src}/dtbs
        find . -type f -name '${cfg.filter}' -print0 \
          | xargs -0 cp -v --no-preserve=mode --target-directory $out --parents
      '';

  filteredDTBs = filterDTBs cfg.kernelPackage;

  # Compile single Device Tree overlay source
  # file (.dts) into its compiled variant (.dtbo)
  compileDTS = name: f: pkgs.callPackage({ stdenv, dtc }: stdenv.mkDerivation {
    name = "${name}-dtbo";

    nativeBuildInputs = [ dtc ];

    buildCommand = ''
      $CC -E -nostdinc -I${getDev cfg.kernelPackage}/lib/modules/${cfg.kernelPackage.modDirVersion}/source/scripts/dtc/include-prefixes -undef -D__DTS__ -x assembler-with-cpp ${f} | \
        dtc -I dts -O dtb -@ -o $out
    '';
  }) {};

  # Fill in `dtboFile` for each overlay if not set already.
  # Existence of one of these is guarded by assertion below
  withDTBOs = xs: flip map xs (o: o // { dtboFile =
    if isNull o.dtboFile then
      if !isNull o.dtsFile then compileDTS o.name o.dtsFile
      else compileDTS o.name (pkgs.writeText "dts" o.dtsText)
    else o.dtboFile; } );

in
{
  imports = [
    (mkRemovedOptionModule [ "hardware" "deviceTree" "base" ] "Use hardware.deviceTree.kernelPackage instead")
  ];

  options = {
      hardware.deviceTree = {
        enable = mkOption {
          default = pkgs.stdenv.hostPlatform.linux-kernel.DTB or false;
          type = types.bool;
          description = lib.mdDoc ''
            Build device tree files. These are used to describe the
            non-discoverable hardware of a system.
          '';
        };

        kernelPackage = mkOption {
          default = config.boot.kernelPackages.kernel;
          defaultText = literalExpression "config.boot.kernelPackages.kernel";
          example = literalExpression "pkgs.linux_latest";
          type = types.path;
          description = lib.mdDoc ''
            Kernel package containing the base device-tree (.dtb) to boot. Uses
            device trees bundled with the Linux kernel by default.
          '';
        };

        name = mkOption {
          default = null;
          example = "some-dtb.dtb";
          type = types.nullOr types.str;
          description = lib.mdDoc ''
            The name of an explicit dtb to be loaded, relative to the dtb base.
            Useful in extlinux scenarios if the bootloader doesn't pick the
            right .dtb file from FDTDIR.
          '';
        };

        filter = mkOption {
          type = types.nullOr types.str;
          default = null;
          example = "*rpi*.dtb";
          description = lib.mdDoc ''
            Only include .dtb files matching glob expression.
          '';
        };

        overlays = mkOption {
          default = [];
          example = literalExpression ''
            [
              { name = "pps"; dtsFile = ./dts/pps.dts; }
              { name = "spi";
                dtsText = "...";
              }
              { name = "precompiled"; dtboFile = ./dtbos/example.dtbo; }
            ]
          '';
          type = types.listOf (types.coercedTo types.path (path: {
            name = baseNameOf path;
            filter = null;
            dtboFile = path;
          }) overlayType);
          description = lib.mdDoc ''
            List of overlays to apply to base device-tree (.dtb) files.
          '';
        };

        package = mkOption {
          default = null;
          type = types.nullOr types.path;
          internal = true;
          description = ''
            A path containing the result of applying `overlays` to `kernelPackage`.
          '';
        };
      };
  };

  config = mkIf (cfg.enable) {

    assertions = let
      invalidOverlay = o: isNull o.dtsFile && isNull o.dtsText && isNull o.dtboFile;
    in lib.singleton {
      assertion = lib.all (o: !invalidOverlay o) cfg.overlays;
      message = ''
        deviceTree overlay needs one of dtsFile, dtsText or dtboFile set.
        Offending overlay(s):
        ${toString (map (o: o.name) (builtins.filter invalidOverlay cfg.overlays))}
      '';
    };

    hardware.deviceTree.package = if (cfg.overlays != [])
      then pkgs.deviceTree.applyOverlays filteredDTBs (withDTBOs cfg.overlays)
      else filteredDTBs;
  };
}
