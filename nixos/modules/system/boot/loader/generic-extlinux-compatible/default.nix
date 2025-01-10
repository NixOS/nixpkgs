{ config, lib, pkgs, ... }:

with lib;

let
  blCfg = config.boot.loader;
  dtCfg = config.hardware.deviceTree;
  cfg = blCfg.generic-extlinux-compatible;

  timeoutStr = if blCfg.timeout == null then "-1" else toString blCfg.timeout;

  # The builder used to write during system activation
  builder = import ./extlinux-conf-builder.nix { inherit pkgs; };
  # The builder exposed in populateCmd, which runs on the build architecture
  populateBuilder = import ./extlinux-conf-builder.nix { pkgs = pkgs.buildPackages; };
in
{
  options = {
    boot.loader.generic-extlinux-compatible = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Whether to generate an extlinux-compatible configuration file
          under `/boot/extlinux.conf`.  For instance,
          U-Boot's generic distro boot support uses this file format.

          See [U-boot's documentation](https://u-boot.readthedocs.io/en/latest/develop/distro.html)
          for more information.
        '';
      };

      useGenerationDeviceTree = mkOption {
        default = true;
        type = types.bool;
        description = ''
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
        description = ''
          Maximum number of configurations in the boot menu.
        '';
      };

      mirroredBoots = mkOption {
        default = [ { path = "/boot"; } ];
        example = [
          { path = "/boot1"; }
          { path = "/boot2"; }
        ];
        description = ''
          Mirror the boot configuration to multiple paths.
        '';

        type = with types; listOf (submodule {
          options = {
            path = mkOption {
              example = "/boot1";
              type = types.str;
              description = ''
                The path to the boot directory where the extlinux-compatible
                configuration files will be written.
              '';
            };
          };
        });
      };

      populateCmd = mkOption {
        type = types.str;
        readOnly = true;
        description = ''
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
    installBootLoader = pkgs.writeScript "install-extlinux-conf.sh" (''
      #!${pkgs.runtimeShell}
      set -e
    '' + flip concatMapStrings cfg.mirroredBoots (args: ''
      ${builder} ${builderArgs} -d '${args.path}' -c "$@"
    ''));
  in
    mkIf cfg.enable {
      system.build.installBootLoader = installBootLoader;
      system.boot.loader.id = "generic-extlinux-compatible";

      boot.loader.generic-extlinux-compatible.populateCmd = "${populateBuilder} ${builderArgs}";

      assertions = [
        {
          assertion = cfg.mirroredBoots != [ ];
          message = ''
            You must not remove all elements from option 'boot.loader.generic-extlinux-compatible.mirroredBoots',
            otherwise the system will not be bootable.
          '';
        }
      ];
    };
}
