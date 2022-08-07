{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.xserver.windowManager.herbstluftwm;
in

{
  options = {
    services.xserver.windowManager.herbstluftwm = {
      enable = mkEnableOption "herbstluftwm";

      package = mkOption {
        type = types.package;
        default = pkgs.herbstluftwm;
        defaultText = literalExpression "pkgs.herbstluftwm";
        description = lib.mdDoc ''
          Herbstluftwm package to use.
        '';
      };

      configFile = mkOption {
        default     = null;
        type        = with types; nullOr path;
        description = lib.mdDoc ''
          Path to the herbstluftwm configuration file.  If left at the
          default value, $XDG_CONFIG_HOME/herbstluftwm/autostart will
          be used.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    services.xserver.windowManager.session = singleton {
      name = "herbstluftwm";
      start =
        let configFileClause = optionalString
            (cfg.configFile != null)
            ''-c "${cfg.configFile}"''
            ;
        in "${cfg.package}/bin/herbstluftwm ${configFileClause}";
    };
    environment.systemPackages = [ cfg.package ];
  };
}
