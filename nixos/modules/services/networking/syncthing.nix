{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.syncthing;
  defaultUser = "syncthing";

  header = {
    description = "Syncthing service";
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

in

{

  ###### interface

  options = {

    services.syncthing = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable the Syncthing, self-hosted open-source alternative
          to Dropbox and BittorrentSync. Initial interface will be
          available on http://127.0.0.1:8384/.
        '';
      };

      systemService = mkOption {
        default = true;
        description = "Auto launch syncthing as a system service.";
      };

      useInotify = mkOption {
        default = false;
        description = "Watch files using inotify.";
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
        default = defaultUser;
        description = ''
          Syncthing will be run under this group (group will be created if it doesn't exist.
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
        { group = defaultUser;
          home  = cfg.dataDir;
          createHome = true;
          uid = config.ids.uids.syncthing;
          description = "Syncthing daemon user";
        };

      extraGroups."${defaultUser}".gid =
        config.ids.gids.syncthing;
    };

    environment.systemPackages = [ cfg.package ] ++ lib.optional cfg.useInotify pkgs.syncthing-inotify;

    systemd.services = mkIf cfg.systemService {
      syncthing = header // {
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = service // {
          User = cfg.user;
          Group = optionalString (cfg.user == defaultUser) defaultUser;
          PermissionsStartOnly = true;
          ExecStart = "${pkgs.syncthing}/bin/syncthing -no-browser -home=${cfg.dataDir}";
        };
      };

      syncthing-inotify = mkIf cfg.useInotify header // {
        description = "Monitor Syncthing using inotify";
        after = [ "syncthing.service" ];
        requires = [ "syncthing.service" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          User = cfg.user;
          Group = optionalString (cfg.user == defaultUser) defaultUser;
          PermissionsStartOnly = true;
          ExecStart = "${pkgs.syncthing-inotify}/bin/syncthing-inotify -logflags=0";
          Restart = "on-failure";
        };
      };
    };

    systemd.user.services =  {
      syncthing = header // {
        serviceConfig = service // {
          ExecStart = "${pkgs.syncthing}/bin/syncthing -no-browser";
        };
      };

      syncthing-inotify = {
        description = "Monitor Syncthing using inotify";
        after = [ "syncthing.service" ];
        requires = [ "syncthing.service" ];
        serviceConfig = {
          ExecStart = "${pkgs.syncthing-inotify}/bin/syncthing-inotify -logflags=0";
          Restart = "on-failure";
          ProtectSystem = "full";
          ProtectHome = "read-only";
        };
      };
    };
  };
}
