{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.programs.mepo;
in
{
  options.programs.mepo = {
    enable = lib.mkEnableOption "Mepo, a fast, simple and hackable OSM map viewer";

    locationBackends = {
      gpsd = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to enable location detection via gpsd.
          This may require additional configuration of gpsd, see [here](#opt-services.gpsd.enable)
        '';
      };

      geoclue = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to enable location detection via geoclue";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages =
      with pkgs;
      [
        mepo
      ]
      ++ lib.optional cfg.locationBackends.geoclue geoclue2-with-demo-agent
      ++ lib.optional cfg.locationBackends.gpsd gpsd;

    services.geoclue2 = lib.mkIf cfg.locationBackends.geoclue {
      enable = true;
      appConfig.where-am-i = {
        isAllowed = true;
        isSystem = false;
      };
    };

    services.gpsd.enable = cfg.locationBackends.gpsd;
  };

  meta.maintainers = with lib.maintainers; [ laalsaas ];
}
