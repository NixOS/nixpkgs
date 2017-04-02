{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.netdata;

  configFile = pkgs.writeText "netdata.conf" cfg.configText;

  defaultUser = "netdata";

in {
  options = {
    services.netdata = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = "Whether to enable netdata monitoring.";
      };

      user = mkOption {
        type = types.str;
        default = "netdata";
        description = "User account under which netdata runs.";
      };

      group = mkOption {
        type = types.str;
        default = "netdata";
        description = "Group under which netdata runs.";
      };

      configText = mkOption {
        type = types.lines;
        default = "";
        description = "netdata.conf configuration.";
        example = ''
          [global]
          debug log = syslog
          access log = syslog
          error log = syslog
        '';
      };

    };
  };

  config = mkIf cfg.enable {
    systemd.services.netdata = {
      description = "Real time performance monitoring";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      preStart = concatStringsSep "\n" (map (dir: ''
        mkdir -vp ${dir}
        chmod 750 ${dir}
        chown -R ${cfg.user}:${cfg.group} ${dir}
        '') [ "/var/cache/netdata"
              "/var/log/netdata"
              "/var/lib/netdata" ]);
      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        PermissionsStartOnly = true;
        ExecStart = "${pkgs.netdata}/bin/netdata -D -c ${configFile}";
        TimeoutStopSec = 60;
      };
    };

    users.extraUsers = optional (cfg.user == defaultUser) {
      name = defaultUser;
    };

    users.extraGroups = optional (cfg.group == defaultUser) {
      name = defaultUser;
    };

  };
}
