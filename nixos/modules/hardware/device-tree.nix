{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.hardware.deviceTree;

  overlayType = types.submodule {
    options = {
      name = mkOption {
        type = types.str;
        description = ''
          Name of this overlay
        '';
      };

      dtsFile = mkOption {
        type = types.nullOr types.path;
        description = ''
          Path to .dts overlay file, overlay is applied to
          each .dtb file matching "compatible" of the overlay.
        '';
        default = null;
        example = literalExample "./dts/overlays.dts";
      };

      dtsText = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          Literal DTS contents, overlay is applied to
          each .dtb file matching "compatible" of the overlay.
        '';
        example = literalExample ''
          /dts-v1/;
          /plugin/;
          / {
                  compatible = "raspberrypi";
                  fragment@0 {
                          target-path = "/soc";
                          __overlay__ {
                                  pps {
                                          compatible = "pps-gpio";
                                          status = "okay";
                                  };
                          };
                  };
          };
        '';
      };

      dtboFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = ''
          Path to .dtbo compiled overlay file.
        '';
      };
    };
  };

  # this requires kernel package
  dtbsWithSymbols = pkgs.stdenv.mkDerivation {
    name = "dtbs-with-symbols";
    inherit (cfg.kernelPackage) src nativeBuildInputs depsBuildBuild;
    patches = map (patch: patch.patch) cfg.kernelPackage.kernelPatches;
    buildPhase = ''
      patchShebangs scripts/*
      substituteInPlace scripts/Makefile.lib \
        --replace 'DTC_FLAGS += $(DTC_FLAGS_$(basetarget))' 'DTC_FLAGS += $(DTC_FLAGS_$(basetarget)) -@'
      make ${pkgs.stdenv.hostPlatform.platform.kernelBaseConfig} ARCH="${pkgs.stdenv.hostPlatform.platform.kernelArch}"
      make dtbs ARCH="${pkgs.stdenv.hostPlatform.platform.kernelArch}"
    '';
    installPhase = ''
      make dtbs_install INSTALL_DTBS_PATH=$out/dtbs  ARCH="${pkgs.stdenv.hostPlatform.platform.kernelArch}"
    '';
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

  # Compile single Device Tree overlay source
  # file (.dts) into its compiled variant (.dtbo)
  compileDTS = name: f: pkgs.callPackage({ dtc }: pkgs.stdenv.mkDerivation {
    name = "${name}-dtbo";

    nativeBuildInputs = [ dtc ];

    buildCommand = ''
      dtc -I dts ${f} -O dtb -@ -o $out
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
          default = pkgs.stdenv.hostPlatform.platform.kernelDTB or false;
          type = types.bool;
          description = ''
            Build device tree files. These are used to describe the
            non-discoverable hardware of a system.
          '';
        };

        kernelPackage = mkOption {
          default = config.boot.kernelPackages.kernel;
          defaultText = "config.boot.kernelPackages.kernel";
          example = literalExample "pkgs.linux_latest";
          type = types.path;
          description = ''
            Kernel package containing the base device-tree (.dtb) to boot. Uses
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

        filter = mkOption {
          type = types.nullOr types.str;
          default = null;
          example = "*rpi*.dtb";
          description = ''
            Only include .dtb files matching glob expression.
          '';
        };

        overlays = mkOption {
          default = [];
          example = literalExample ''
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
            dtboFile = path;
          }) overlayType);
          description = ''
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
      then pkgs.deviceTree.applyOverlays (filterDTBs dtbsWithSymbols) (withDTBOs cfg.overlays)
      else (filterDTBs cfg.kernelPackage);
  };
}
