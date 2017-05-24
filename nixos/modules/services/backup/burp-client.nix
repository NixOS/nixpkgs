{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.burpClient;

in

{

  ###### interface

  options = {

    services.burpClient = {

      enable = mkEnableOption "Enable burp client";

      configFile = mkOption {
        type = types.path;
        default = "/etc/burp/burp.conf";
        description = "Path to the burp config file. You need to provide a fully working configuration file yourself.";
      };

      package = mkOption {
        type = types.package;
        default = pkgs.burp;
        example = literalExample "pkgs.burp";
        description = ''burp package to use.'';
      };

    };

  };

  ###### implementation

  config = mkIf config.services.burpClient.enable {

    systemd.timers.burpClient = {
      description = "burp client timer";

      wantedBy = [ "timers.target" ];
      after = [ "network.target" ];

      timerConfig.OnBootSec = "10m";
      timerConfig.OnUnitInactiveSec = "20m";
      timerConfig.Unit = "burpClient.service";

    };
    systemd.services.burpClient = {
      description = "burp client";
      serviceConfig.ExecStart = "${cfg.package}/bin/burp -a t -c ${toString cfg.configFile}";
    };
  
  };

}
