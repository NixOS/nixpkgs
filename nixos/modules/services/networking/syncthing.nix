{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.syncthing;
  defaultUser = "syncthing";

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

      user = mkOption {
        type = types.string;
        default = defaultUser;
        description = ''
          Syncthing will be run under this user (user must exist,
          this can be your user name).
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
        { group = defaultUser;
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
          Group = optionalString (cfg.user == defaultUser) defaultUser;
          PermissionsStartOnly = true;
          Restart = "on-failure";
          ExecStart = "${pkgs.syncthing}/bin/syncthing -no-browser -home=${cfg.dataDir}";
          SuccessExitStatus = "2 3 4";
          RestartForceExitStatus="3 4";
        };
      };

    environment.systemPackages = [ cfg.package ];

  };

}
