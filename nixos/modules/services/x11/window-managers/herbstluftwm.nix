{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.xserver.windowManager.herbstluftwm;
in

{
  options = {
    services.xserver.windowManager.herbstluftwm = {
      enable = lib.mkEnableOption "herbstluftwm";

      package = lib.mkPackageOption pkgs "herbstluftwm" { };

      configFile = lib.mkOption {
        default = null;
        type = with lib.types; nullOr path;
        description = ''
          Path to the herbstluftwm configuration file.  If left at the
          default value, $XDG_CONFIG_HOME/herbstluftwm/autostart will
          be used.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.xserver.windowManager.session = lib.singleton {
      name = "herbstluftwm";
      start =
        let
          configFileClause = lib.optionalString (cfg.configFile != null) ''-c "${cfg.configFile}"'';
        in
        ''
          ${cfg.package}/bin/herbstluftwm ${configFileClause} &
          waitPID=$!
        '';
    };
    environment.systemPackages = [ cfg.package ];
  };
}
