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

      enable = mkEnableOption {
        description = ''
          Whether to enable Syncthing - the self-hosted open-source alternative
          to Dropbox and Bittorrent Sync. Initial interface will be
          available on http://127.0.0.1:8384/.
        '';
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

    systemd.services.syncthing =
      {
        description = "Syncthing service";
        after    = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        environment = {
          STNORESTART = "yes";  # do not self-restart
          STNOUPGRADE = "yes";
          inherit (cfg) all_proxy;
        } // config.networking.proxy.envVars;

        serviceConfig = {
          User  = cfg.user;
          Group = cfg.group;
    };

    environment.systemPackages = [ cfg.package ];

    systemd.services = mkIf cfg.systemService {
      syncthing = header // {
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = service // {
          User = cfg.user;
          Group = cfg.group;
          PermissionsStartOnly = true;
          ExecStart = "${pkgs.syncthing}/bin/syncthing -no-browser -home=${cfg.dataDir}";
        };
      };
    };

    systemd.user.services =  {
      syncthing = header // {
        serviceConfig = service // {
          ExecStart = "${pkgs.syncthing}/bin/syncthing -no-browser";
        };
      };
    };
  };
}
