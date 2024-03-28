{ config, lib, pkgs, ... }:

let
  cfg = config.hardware.fwenv;
in

{
  options.hardware.fwenv = {
    enable = lib.mkEnableOption (lib.mdDoc ''
      U-Boot environment access configuration.

      Use this to setup access to the U-Boot's environment variables with
      generic ubootEnvTools package.
    '');
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.ubootEnvTools;
      defaultText = lib.literalExpression "pkgs.ubootEnvTools";
      description = lib.mdDoc ''
        Package providing U-Boot's environment tools (`fw_printenv` and
        `fw_setenv`) that is added to `environment.systemPackages`.
      '';
    };
    device = lib.mkOption {
      type = lib.types.str;
      description = lib.mdDoc "Device with U-Boot environment";
    };
    offset = lib.mkOption {
      type = lib.types.ints.unsigned;
      default = 0;
      description = lib.mdDoc "Offset in the device to the environment";
    };
    size = lib.mkOption {
      type = lib.types.ints.positive;
      description = lib.mdDoc "Environment size";
    };
    secsize = lib.mkOption {
      type = with lib.types; nullOr ints.positive;
      default = null;
      description = lib.mdDoc "Flash sector size.";
    };
    numsec = lib.mkOption {
      type = with lib.types; nullOr ints.positive;
      default = null;
      description = lib.mdDoc "Number of sectors";
    };
  };

  config = lib.mkIf cfg.enable {

    environment.etc."fw_env.config".text = ''
      ${cfg.device} 0x${lib.toHexString cfg.offset} 0x${lib.toHexString cfg.size}${
        lib.optionalString (cfg.secsize != null) " 0x${lib.toHexString cfg.secsize}${
          lib.optionalString (cfg.numsec != null) " ${cfg.numsec}"
        }"
      }
    '';

    environment.systemPackages = [ cfg.package ];

  };

  meta.maintainers = [ lib.maintainers.cynerd ];

}
