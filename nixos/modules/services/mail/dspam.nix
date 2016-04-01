{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.dspam;

  dspam = pkgs.dspam;

  defaultSock = "/run/dspam/dspam.sock";

  cfgfile = pkgs.writeText "dspam.conf" ''
    Home /var/lib/dspam
    StorageDriver ${dspam}/lib/dspam/lib${cfg.storageDriver}_drv.so

    Trust root
    Trust ${cfg.user}
    SystemLog on
    UserLog on

    ${optionalString (cfg.domainSocket != null) ''
      ServerDomainSocketPath "${cfg.domainSocket}"
      ClientHost "${cfg.domainSocket}"
    ''}

    ${cfg.extraConfig}
  '';

in {

  ###### interface

  options = {

    services.dspam = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable the dspam spam filter.";
      };

      user = mkOption {
        type = types.str;
        default = "dspam";
        description = "User for the dspam daemon.";
      };

      group = mkOption {
        type = types.str;
        default = "dspam";
        description = "Group for the dspam daemon.";
      };

      storageDriver = mkOption {
        type = types.str;
        default = "hash";
        description =  "Storage driver backend to use for dspam.";
      };

      domainSocket = mkOption {
        type = types.nullOr types.path;
        default = defaultSock;
        description = "Path to local domain socket which is used for communication with the daemon. Set to null to disable UNIX socket.";
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = "Additional dspam configuration.";
      };

      maintenanceInterval = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "If set, maintenance script will be run at specified (in systemd.timer format) interval";
      };

    };

  };


  ###### implementation

  config = mkIf cfg.enable (mkMerge [
    {
      users.extraUsers = optionalAttrs (cfg.user == "dspam") (singleton
        { name = "dspam";
          group = cfg.group;
          uid = config.ids.uids.dspam;
        });

      users.extraGroups = optionalAttrs (cfg.group == "dspam") (singleton
        { name = "dspam";
          gid = config.ids.gids.dspam;
        });

      environment.systemPackages = [ dspam ];

      environment.etc."dspam/dspam.conf".source = cfgfile;

      systemd.services.dspam = {
        description = "dspam spam filtering daemon";
        wantedBy = [ "multi-user.target" ];
        after = [ "postgresql.service" ];
        restartTriggers = [ cfgfile ];

        serviceConfig = {
          ExecStart = "${dspam}/bin/dspam --daemon --nofork";
          User = cfg.user;
          Group = cfg.group;
          RuntimeDirectory = optional (cfg.domainSocket == defaultSock) "dspam";
          RuntimeDirectoryMode = optional (cfg.domainSocket == defaultSock) "0750";
          PermissionsStartOnly = true;
          # DSPAM segfaults on just about every error
          Restart = "on-abort";
          RestartSec = "1s";
        };

        preStart = ''
          mkdir -m750 -p /var/lib/dspam
          chown -R "${cfg.user}:${cfg.group}" /var/lib/dspam

          mkdir -m750 -p /var/log/dspam
          chown -R "${cfg.user}:${cfg.group}" /var/log/dspam
        '';
      };
    }

    (mkIf (cfg.maintenanceInterval != null) {
      systemd.timers.dspam-maintenance = {
        description = "Timer for dspam maintenance script";
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnCalendar = cfg.maintenanceInterval;
          Unit = "dspam-maintenance.service";
        };
      };

      systemd.services.dspam-maintenance = {
        description = "dspam maintenance script";
        restartTriggers = [ cfgfile ];

        serviceConfig = {
          ExecStart = "${dspam}/bin/dspam_maintenance --verbose";
          Type = "oneshot";
          User = cfg.user;
          Group = cfg.group;
        };
      };
    })
  ]);
}
