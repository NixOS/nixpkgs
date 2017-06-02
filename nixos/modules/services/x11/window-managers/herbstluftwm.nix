{ config, lib, pkgs, ... }:

with lib;

let
  wmcfg = config.services.xserver.windowManager;
  cfg = config.services.xserver.windowManager.herbstluftwm;
in

{
  options = {
    services.xserver.windowManager.select = mkOption {
      type = with types; listOf (enum [ "herbstluftwm" ]);
    };

    services.xserver.windowManager.herbstluftwm = {
      configFile = mkOption {
        default     = null;
        type        = with types; nullOr path;
        description = ''
          Path to the herbstluftwm configuration file.  If left at the
          default value, $XDG_CONFIG_HOME/herbstluftwm/autostart will
          be used.
        '';
      };
    };
  };

  config = mkIf (elem "herbstluftwm" wmcfg.select) {
    services.xserver.windowManager.session = singleton {
      name = "herbstluftwm";
      start =
        let configFileClause = optionalString
            (cfg.configFile != null)
            ''-c "${cfg.configFile}"''
            ;
        in "${pkgs.herbstluftwm}/bin/herbstluftwm ${configFileClause}";
    };
    environment.systemPackages = [ pkgs.herbstluftwm ];
  };
}
