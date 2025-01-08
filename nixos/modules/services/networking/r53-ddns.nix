{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.r53-ddns;
  pkg = pkgs.r53-ddns;
in
{
  options = {
    services.r53-ddns = {

      enable = lib.mkEnableOption "r53-ddyns";

      interval = lib.mkOption {
        type = lib.types.str;
        default = "15min";
        description = "How often to update the entry";
      };

      zoneID = lib.mkOption {
        type = lib.types.str;
        description = "The ID of your zone in Route53";
      };

      domain = lib.mkOption {
        type = lib.types.str;
        description = "The name of your domain in Route53";
      };

      hostname = lib.mkOption {
        type = lib.types.str;
        description = ''
          Manually specify the hostname. Otherwise the tool will try to use the name
          returned by the OS (Call to gethostname)
        '';
      };

      environmentFile = lib.mkOption {
        type = lib.types.str;
        description = ''
          File containing the AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY
          in the format of an EnvironmentFile as described by systemd.exec(5)
        '';
      };

    };
  };

  config = lib.mkIf cfg.enable {

    systemd.timers.r53-ddns = {
      description = "r53-ddns timer";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = cfg.interval;
        OnUnitActiveSec = cfg.interval;
      };
    };

    systemd.services.r53-ddns = {
      description = "r53-ddns service";
      serviceConfig = {
        ExecStart =
          "${pkg}/bin/r53-ddns -zone-id ${cfg.zoneID} -domain ${cfg.domain}"
          + lib.optionalString (cfg.hostname != null) " -hostname ${cfg.hostname}";
        EnvironmentFile = "${cfg.environmentFile}";
        DynamicUser = true;
      };
    };

  };
}
