{config, pkgs, ...}:

with pkgs.lib;

let
  cfg = config.services.prey;
  myPrey = pkgs."prey-bash-client".override {
    apiKey = cfg.apiKey;
    deviceKey = cfg.deviceKey;
  };
in {
  options = {

    services.prey = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Enables http://preyproject.com/ bash client. Be sure to specify api and device keys.
          Once setup, cronjob will run evert 15 minutes and report status.
        '';
      };

      deviceKey = mkOption {
        type = types.string;
        description = "Device Key obtained from https://panel.preyproject.com/devices (and clicking on the device)";
      };

      apiKey = mkOption {
        type = types.string;
        description = "API key obtained from https://panel.preyproject.com/profile";
      };
    };

  };

  config = mkIf cfg.enable {
      environment.systemPackages = [ myPrey ];
      services.cron.systemCronJobs = [ "*/15 * * * * root ${myPrey}/prey.sh" ];
  };

}
