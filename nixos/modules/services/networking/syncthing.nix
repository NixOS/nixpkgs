{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.syncthing;

in

{

  ###### interface

  options = {

    services.syncthing = {

      enable = mkOption {
        default = false;
        description = ''
          Whether to enable the Syncthing, self-hosted open-source alternative
          to Dropbox and BittorrentSync. Initial interface will be
          available on http://127.0.0.1:8080/.
        '';
      };

      user = mkOption {
        default = "syncthing";
        description = ''
          Syncthing will be run under this user (user must exist,
          this can be your user name).
        '';
      };

      dataDir = mkOption {
        default = "/var/lib/syncthing";
        description = ''
          Path where the settings and keys will exist.
        '';
      };

    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    systemd.services.syncthing =
      {
        description = "Syncthing service";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        environment.STNORESTART = "placeholder";  # do not self-restart
        serviceConfig = {
          User = "${cfg.user}";
          PermissionsStartOnly = true;
          Restart = "always";
          ExecStart = "${pkgs.syncthing}/bin/syncthing -no-browser -home=${cfg.dataDir}";
        };
      };

    environment.systemPackages = [ pkgs.syncthing ];

  };

}
