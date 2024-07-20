{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.xserver.windowManager.herbstluftwm;
in

{
  options = {
    services.xserver.windowManager.herbstluftwm = {
      enable = mkEnableOption "herbstluftwm";

      package = mkPackageOption pkgs "herbstluftwm" { };

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

  config = mkIf cfg.enable {
    services.xserver.windowManager.session = singleton {
      name = "herbstluftwm";
      start =
        let configFileClause = optionalString
            (cfg.configFile != null)
            ''-c "${cfg.configFile}"''
            ;
        in ''
          ${cfg.package}/bin/herbstluftwm ${configFileClause} &
          waitPID=$!
        '';
    };
    environment.systemPackages = [ cfg.package ];
  };
}
