{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.uboot-fwenv;
  hexreg = "0x[a-fA-F0-9]+";

in
{
  options.programs.uboot-fwenv = {
    enable = lib.mkEnableOption ''
      U-Boot environment access configuration.

      Use this to setup access to the U-Boot's environment variables with
      generic ubootEnvTools package.
    '';

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.ubootEnvTools;
      defaultText = lib.literalExpression "pkgs.ubootEnvTools";
      description = ''
        Package providing U-Boot's environment tools (`fw_printenv` and
        `fw_setenv`) that is added to `environment.systemPackages`.
      '';
    };

    device = lib.mkOption {
      type = lib.types.str;
      description = "Device with U-Boot environment";
    };

    offset = lib.mkOption {
      type = lib.types.strMatching hexreg;
      default = 0;
      description = "Offset in the device to the environment";
    };

    size = lib.mkOption {
      type = lib.types.strMatching hexreg;
      description = "Environment size";
    };

    secsize = lib.mkOption {
      type = with lib.types; nullOr (strMatching hexreg);
      default = null;
      description = "Flash sector size.";
    };

    numsec = lib.mkOption {
      type = with lib.types; nullOr ints.positive;
      default = null;
      description = "Number of sectors";
    };

  };

  config = lib.mkIf cfg.enable {

    environment.etc."fw_env.config".text = ''
    ${cfg.device} ${cfg.offset} ${cfg.size}${
      lib.optionalString (cfg.secsize != null) " ${cfg.secsize}${
        lib.optionalString (cfg.numsec != null) " ${cfg.numsec}"}"}
    '';

    environment.systemPackages = [ cfg.package ];

  };

  meta.maintainers = [ lib.maintainers.cynerd ];

}
