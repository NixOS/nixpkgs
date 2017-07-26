{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.deluge;
  cfg_web = config.services.deluge.web;
  openFilesLimit = 4096;

in {
  options = {
    services = {
      deluge = {
        enable = mkOption {
          default = false;
          description = "Start the Deluge daemon";
        };

        openFilesLimit = mkOption {
          default = openFilesLimit;
          example = 8192;
          description = ''
            Number of files to allow deluged to open.
          '';
        };
      };

      deluge.web = {
        enable = mkOption {
          default = false;
          description = ''
            Start Deluge Web daemon.
          '';
        };
      };
    };
  };

  config = mkIf cfg.enable {

    systemd.services.deluged = {
      after = [ "network.target" ];
      description = "Deluge BitTorrent Daemon";
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.pythonPackages.deluge ];
      serviceConfig = {
        ExecStart = "${pkgs.pythonPackages.deluge}/bin/deluged -d";
        # To prevent "Quit & shutdown daemon" from working; we want systemd to manage it!
        Restart = "on-success";
        User = "deluge";
        Group = "deluge";
        LimitNOFILE = cfg.openFilesLimit;
      };
    };

    systemd.services.delugeweb = mkIf cfg_web.enable {
      after = [ "network.target" ];
      description = "Deluge BitTorrent WebUI";
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.pythonPackages.deluge ];
      serviceConfig.ExecStart = "${pkgs.pythonPackages.deluge}/bin/deluge --ui web";
      serviceConfig.User = "deluge";
      serviceConfig.Group = "deluge";
    };

    environment.systemPackages = [ pkgs.pythonPackages.deluge ];

    users.extraUsers.deluge = {
      group = "deluge";
      uid = config.ids.uids.deluge;
      home = "/var/lib/deluge/";
      createHome = true;
      description = "Deluge Daemon user";
    };

    users.extraGroups.deluge.gid = config.ids.gids.deluge;
  };
}
