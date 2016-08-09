{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.syncthing;
  defaultUser = "syncthing";

  header = {
    description = "Syncthing service";
    after = [ "network.target" ];
    environment = {
      STNORESTART = "yes";
      STNOUPGRADE = "yes";
      inherit (cfg) all_proxy;
    } // config.networking.proxy.envVars;
  };

  service = {
    Restart = "on-failure";
    SuccessExitStatus = "2 3 4";
    RestartForceExitStatus="3 4";
  };

  iNotifyHeader = {
    description = "Syncthing Inotify File Watcher service";
    after = [ "network.target" "syncthing.service" ];
    requires = [ "syncthing.service" ];
  };

  iNotifyService = {
    SuccessExitStatus = "2";
    RestartForceExitStatus = "3";
    Restart = "on-failure";
  };

in

{

  ###### interface

  options = {

    services.syncthing = {

      enable = mkEnableOption ''
        Syncthing - the self-hosted open-source alternative
        to Dropbox and Bittorrent Sync. Initial interface will be
        available on http://127.0.0.1:8384/.
      '';

      useInotify = mkOption {
        type = types.bool;
        default = false;
        description = "Provide syncthing-inotify as a service.";
      };

      systemService = mkOption {
        type = types.bool;
        default = true;
        description = "Auto launch Syncthing as a system service.";
      };

      user = mkOption {
        type = types.string;
        default = defaultUser;
        description = ''
          Syncthing will be run under this user (user will be created if it doesn't exist.
          This can be your user name).
        '';
      };

      group = mkOption {
        type = types.string;
        default = "nogroup";
        description = ''
          Syncthing will be run under this group (group will not be created if it doesn't exist.
          This can be your user name).
        '';
      };

      all_proxy = mkOption {
        type = types.nullOr types.string;
        default = null;
        example = "socks5://address.com:1234";
        description = ''
          Overwrites all_proxy environment variable for the syncthing process to
          the given value. This is normaly used to let relay client connect
          through SOCKS5 proxy server.
        '';
      };

      dataDir = mkOption {
        type = types.path;
        default = "/var/lib/syncthing";
        description = ''
          Path where the settings and keys will exist.
        '';
      };

      package = mkOption {
        type = types.package;
        default = pkgs.syncthing;
        defaultText = "pkgs.syncthing";
        example = literalExample "pkgs.syncthing";
        description = ''
          Syncthing package to use.
        '';
      };
    };
  };


  ###### implementation

  config = mkIf cfg.enable {

    users = mkIf (cfg.user == defaultUser) {
      extraUsers."${defaultUser}" =
        { group = cfg.group;
          home  = cfg.dataDir;
          createHome = true;
          uid = config.ids.uids.syncthing;
          description = "Syncthing daemon user";
        };

      extraGroups."${defaultUser}".gid =
        config.ids.gids.syncthing;
    };

    systemd.services = {
      syncthing = mkIf cfg.systemService (header // {
          wants = mkIf cfg.useInotify [ "syncthing-inotify.service" ];
          wantedBy = [ "multi-user.target" ];
          serviceConfig = service // {
            User = cfg.user;
            Group = cfg.group;
            PermissionsStartOnly = true;
            ExecStart = "${cfg.package}/bin/syncthing -no-browser -home=${cfg.dataDir}";
          };
      });

      syncthing-inotify = mkIf (cfg.systemService && cfg.useInotify) (iNotifyHeader // {
        wantedBy = [ "multi-user.target" ];
        serviceConfig = iNotifyService // {
          User = cfg.user;
          ExecStart = "${pkgs.syncthing-inotify.bin}/bin/syncthing-inotify -home=${cfg.dataDir} -logflags=0";
        };
      });
    };

    systemd.user.services = {
      syncthing = header // {
        serviceConfig = service // {
          ExecStart = "${cfg.package}/bin/syncthing -no-browser";
        };
      };

      syncthing-inotify = mkIf cfg.useInotify (iNotifyHeader // {
        serviceConfig = iNotifyService // {
          ExecStart = "${pkgs.syncthing-inotify.bin}/bin/syncthing-inotify -logflags=0";
        };
      });
    };

  };
}
