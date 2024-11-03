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
    systemd.packages = [ pkgs.do-agent ];

    systemd.services.do-agent = {
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = [ "" "${pkgs.do-agent}/bin/do-agent --syslog" ];
        DynamicUser = true;
      };
    };
  };
}
