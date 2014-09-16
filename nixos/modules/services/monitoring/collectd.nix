{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.collectd;

  conf = pkgs.writeText "collectd.conf" ''
    BaseDir "${cfg.dataDir}"
    PIDFile "${cfg.dataDir}/collectd.pid"
    AutoLoadPlugin ${if cfg.autoLoadPlugin then "true" else "false"}
    Hostname ${config.networking.hostName}

    LoadPlugin syslog
    <Plugin "syslog">
      LogLevel "info"
      NotifyLevel "OKAY"
    </Plugin>

    ${concatMapStrings (f: ''
    Include "${f}"
    '') cfg.include}

    ${cfg.extraConfig}
  '';

in {
  options.services.collectd = with types; {
    enable = mkOption {
      default = false;
      description = ''
        Whether to enable collectd agent.
      '';
      type = bool;
    };

    user = mkOption {
      default = "collectd";
      description = ''
        User under which to run collectd.
      '';
      type = nullOr str;
    };

    dataDir = mkOption {
      default = "/var/lib/collectd";
      description = ''
        Data directory for collectd agent.
      '';
      type = path;
    };

    autoLoadPlugin = mkOption {
      default = false;
      description = ''
        Enable plugin autoloading.
      '';
      type = bool;
    };

    include = mkOption {
      default = [];
      description = ''
        Additional paths to load config from.
      '';
      type = listOf str;
    };

    extraConfig = mkOption {
      default = "";
      description = ''
        Extra configuration for collectd.
      '';
      type = lines;
    };

  };

  config = mkIf cfg.enable {
    systemd.services.collectd = {
      description = "Collectd Monitoring Agent";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = "${pkgs.collectd}/sbin/collectd -C ${conf} -P ${cfg.dataDir}/collectd.pid";
        Type = "forking";
        PIDFile = "${cfg.dataDir}/collectd.pid";
        User = optional (cfg.user!="root") cfg.user;
        PermissionsStartOnly = true;
      };

      preStart = ''
        mkdir -m 0700 -p ${cfg.dataDir}
        if [ "$(id -u)" = 0 ]; then chown -R ${cfg.user} ${cfg.dataDir}; fi
      '';
    }; 

    users.extraUsers = optional (cfg.user == "collectd") {
      name = "collectd";
      uid = config.ids.uids.collectd;
    };
  };
}
