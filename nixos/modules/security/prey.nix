{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.prey;
  myPrey = pkgs.prey-bash-client.override {
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
          Enables the <link xlink:href="http://preyproject.com/" />
          shell client. Be sure to specify both API and device keys.
          Once enabled, a <command>cron</command> job will run every 15
          minutes to report status information.
        '';
      };

      deviceKey = mkOption {
        type = types.str;
        description = ''
          <literal>Device key</literal> obtained by visiting
          <link xlink:href="https://panel.preyproject.com/devices" />
          and clicking on your device.
        '';
      };

      apiKey = mkOption {
        type = types.str;
        description = ''
          <literal>API key</literal> obtained from
          <link xlink:href="https://panel.preyproject.com/profile" />.
        '';
      };
    };

  };

  config = mkIf cfg.enable {
      environment.systemPackages = [ myPrey ];
      services.cron.systemCronJobs = [ "*/15 * * * * root ${myPrey}/prey.sh" ];
  };

}
