{ config, lib, pkgs, ... }:

with lib;

let
  blCfg = config.boot.loader;
  dtCfg = config.hardware.deviceTree;
  cfg = blCfg.generic-extlinux-compatible;

  timeoutStr = if blCfg.timeout == null then "-1" else toString blCfg.timeout;

  # The builder used to write during system activation
  builder = pkgs.callPackage ./extlinux-conf-builder.nix { };
  # The builder exposed in populateCmd, which runs on the build architecture
  populateBuilder = pkgs.buildPackages.callPackage ./extlinux-conf-builder.nix { };
in
{
  options = {
    boot.loader.generic-extlinux-compatible = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc ''
          Whether to generate an extlinux-compatible configuration file
          under `/boot/extlinux.conf`.  For instance,
          U-Boot's generic distro boot support uses this file format.

          See [U-boot's documentation](http://git.denx.de/?p=u-boot.git;a=blob;f=doc/README.distro;hb=refs/heads/master)
          for more information.
        '';
      };

      useGenerationDeviceTree = mkOption {
        default = true;
        type = types.bool;
        description = lib.mdDoc ''
          Whether to generate Device Tree-related directives in the
          extlinux configuration.

          When enabled, the bootloader will attempt to load the device
          tree binaries from the generation's kernel.

          Note that this affects all generations, regardless of the
          setting value used in their configurations.
        '';
      };

      configurationLimit = mkOption {
        default = 20;
        example = 10;
        type = types.int;
        description = lib.mdDoc ''
          Maximum number of configurations in the boot menu.
        '';
      };

      installCmd = mkOption {
        type = types.str;
        readOnly = true;
        internal = true;
        description = lib.mdDoc ''
          Contains the builder command used to install the bootloader, built for
          the host architecture and honoring all options except the
          `-c <path-to-default-configuration>` argument. Used to build other
          bootloaders on top of this one.
        '';
      };

      populateCmd = mkOption {
        type = types.str;
        readOnly = true;
        description = lib.mdDoc ''
          Contains the builder command used to populate an image,
          honoring all options except the `-c <path-to-default-configuration>`
          argument.
          Useful to have for sdImage.populateRootCommands
        '';
      };

    };
  };

  config = let
    builderArgs = "-g ${toString cfg.configurationLimit} -t ${timeoutStr}"
      + lib.optionalString (dtCfg.name != null) " -n ${dtCfg.name}"
      + lib.optionalString (!cfg.useGenerationDeviceTree) " -r";
  in
    mkIf cfg.enable {
      system.build.installBootLoader = "${cfg.installCmd} -c";
      system.boot.loader.id = "generic-extlinux-compatible";

      boot.loader.generic-extlinux-compatible = {
        installCmd = "${builder} ${builderArgs}";
        populateCmd = "${populateBuilder} ${builderArgs}";
      };
    };
}
