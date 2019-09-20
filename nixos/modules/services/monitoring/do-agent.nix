{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.do-agent;
in
{
  options.services.do-agent = {
    enable = mkEnableOption "do-agent, the DigitalOcean droplet metrics agent";

    user = mkOption {
      type = types.str;
      default = "do-agent";
      description = "User account under which do-agent runs.";
    };

    group = mkOption {
      type = types.str;
      default = "do-agent";
      description = "Group account under which do-agent runs.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.do-agent ];

    systemd.services.do-agent = {
      description = "DigitalOcean Droplet Metrics Agent";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.do-agent}/bin/do-agent --syslog";
        Restart = "always";
        OOMScoreAdjust = -900;
        SyslogIdentifier = "DigitalOceanAgent";
        PrivateTmp = "yes";
        ProtectSystem = "full";
        ProtectHome = "yes";
        NoNewPrivileges = "yes";
      };
    };

    users.users = optionalAttrs (cfg.user == "do-agent") (singleton
      { name = "do-agent";
        group = cfg.group;
      });

    users.groups = optionalAttrs (cfg.group == "do-agent") (singleton
      { name = "do-agent";
      });
  };
}
