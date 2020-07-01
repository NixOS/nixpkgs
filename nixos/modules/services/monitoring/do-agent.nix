{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.do-agent;
in
{
  options.services.do-agent = {
    enable = mkEnableOption "do-agent, the DigitalOcean droplet metrics agent";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.do-agent ];

    systemd.services.do-agent = {
      description = "DigitalOcean Droplet Metrics Agent";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.do-agent}/bin/do-agent --syslog";
        Restart = "always";
        OOMScoreAdjust = -900;
        SyslogIdentifier = "DigitalOceanAgent";
        PrivateTmp = "yes";
        ProtectSystem = "full";
        ProtectHome = "yes";
        NoNewPrivileges = "yes";
        DynamicUser = "yes";
      };
    };
  };
}
