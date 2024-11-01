{ config, lib, pkgs, ... }:
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

    ${lib.optionalString (cfg.domainSocket != null) ''
      ServerDomainSocketPath "${cfg.domainSocket}"
      ClientHost "${cfg.domainSocket}"
    ''}

    ${cfg.extraConfig}
  '';

in {

  ###### interface

  options = {

    services.dspam = {

      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to enable the dspam spam filter.";
      };

      user = lib.mkOption {
        type = lib.types.str;
        default = "dspam";
        description = "User for the dspam daemon.";
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "dspam";
        description = "Group for the dspam daemon.";
      };

      storageDriver = lib.mkOption {
        type = lib.types.str;
        default = "hash";
        description = "Storage driver backend to use for dspam.";
      };

      domainSocket = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = defaultSock;
        description = "Path to local domain socket which is used for communication with the daemon. Set to null to disable UNIX socket.";
      };

      extraConfig = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = "Additional dspam configuration.";
      };

      maintenanceInterval = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "If set, maintenance script will be run at specified (in systemd.timer format) interval";
      };

    };

  };


  ###### implementation

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      users.users = lib.optionalAttrs (cfg.user == "dspam") {
        dspam = {
          group = cfg.group;
          uid = config.ids.uids.dspam;
        };
      };

      users.groups = lib.optionalAttrs (cfg.group == "dspam") {
        dspam.gid = config.ids.gids.dspam;
      };

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
          RuntimeDirectory = lib.optional (cfg.domainSocket == defaultSock) "dspam";
          RuntimeDirectoryMode = lib.optional (cfg.domainSocket == defaultSock) "0750";
          StateDirectory = "dspam";
          StateDirectoryMode = "0750";
          LogsDirectory = "dspam";
          LogsDirectoryMode = "0750";
          # DSPAM segfaults on just about every error
          Restart = "on-abort";
          RestartSec = "1s";
        };
      };
    }

    (lib.mkIf (cfg.maintenanceInterval != null) {
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
