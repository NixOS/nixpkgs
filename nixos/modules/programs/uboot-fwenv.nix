{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkPackageOption
    mkOption
    types
    mkIf
    optionalString
    maintainers
    ;

  cfg = config.programs.uboot-fwenv;
in
{
  options.programs.uboot-fwenv = {
    enable = mkEnableOption ''
      U-Boot environment access configuration.

      Use this to setup access to the U-Boot's environment variables with
      generic ubootEnvTools package.
    '';
    package = mkPackageOption pkgs "ubootEnvTools" { };
    device = mkOption {
      type = types.str;
      description = "Device with U-Boot environment";
    };
    offset = mkOption {
      type = types.strMatching "0x[a-fA-F0-9]+";
      default = "0x0";
      description = "Offset in the device to the environment";
    };
    size = mkOption {
      type = types.strMatching "0x[a-fA-F0-9]+";
      description = "Environment size";
    };
    secsize = mkOption {
      type = with types; nullOr (strMatching "0x[a-fA-F0-9]+");
      default = null;
      description = "Flash sector size.";
    };
    numsec = mkOption {
      type = with types; nullOr (strMatching "0x[a-fA-F0-9]+");
      default = null;
      description = "Number of sectors";
    };
  };

  config = mkIf cfg.enable {
    environment.etc."fw_env.config".text =
      "${cfg.device} ${cfg.offset} ${cfg.size}"
      + optionalString (cfg.secsize != null) (
        " ${cfg.secsize}" + (optionalString (cfg.numsec != null) " ${cfg.numsec}")
      );

    environment.systemPackages = [ cfg.package ];
  };

  meta.maintainers = [ maintainers.cynerd ];
}
