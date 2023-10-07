{ pkgs, config, lib, ...}:
with lib;
let
  cfg = config.programs.mepo;
in
{
  options.programs.mepo = {
    enable = mkEnableOption (mdDoc "Mepo");

    locationBackends = {
      gpsd = mkOption {
        type = types.bool;
        default = false;
        description = mdDoc ''
          Whether to enable location detection via gpsd.
          This may require additional configuration of gpsd, see [here](#opt-services.gpsd.enable)
        '';
      };

      geoclue = mkOption {
        type = types.bool;
        default = true;
        description = mdDoc "Whether to enable location detection via geoclue";
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      mepo
    ] ++ lib.optional cfg.locationBackends.geoclue geoclue2-with-demo-agent
    ++ lib.optional cfg.locationBackends.gpsd gpsd;

    services.geoclue2 = mkIf cfg.locationBackends.geoclue {
      enable = true;
      appConfig.where-am-i = {
        isAllowed = true;
        isSystem = false;
      };
    };

    services.gpsd.enable = cfg.locationBackends.gpsd;
  };

  meta.maintainers = with maintainers; [ laalsaas ];
}
