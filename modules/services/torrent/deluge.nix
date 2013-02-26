{ config, pkgs, ... }:

with pkgs.lib;

let
  uid = config.ids.uids.deluge;
  gid = config.ids.gids.deluge;
  cfg = config.services.deluge;
  cfg_web = config.services.deluge.web;
in {
  options = {
    services.deluge = {
      enable = mkOption {
        default = false;
        example = true;
        description = ''
          Start Deluge daemon.
        ''; 
      };  
    };

    services.deluge.web = {
      enable = mkOption {
        default = false;
        example = true;
        description = ''
          Start Deluge Web daemon.
        ''; 
      };  
    };
  };

  config = mkIf cfg.enable {

    systemd.services.deluged = {
      after = [ "network.target" ];
      description = "Deluge BitTorrent Daemon";
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.pythonPackages.deluge ];
      script = "deluged -d";
      serviceConfig.User = "deluge";
      serviceConfig.Group = "deluge";
    };

    systemd.services.delugeweb = mkIf cfg_web.enable {
      after = [ "network.target" "deluged.service" ];
      description = "Deluge BitTorrent WebUI";
      wantedBy = [ "multi-user.target" ];
      wants = [ "deluged.service" ];
      path = [ pkgs.pythonPackages.deluge ];
      script = "deluge --ui web";
      serviceConfig.User = "deluge";
      serviceConfig.Group = "deluge";
    };

    environment.systemPackages = [ pkgs.pythonPackages.deluge ];

    users.extraUsers.deluge = {
      inherit uid;
      group = "deluge";
      home = "/var/lib/deluge/";
      createHome = true;
      description = "Deluge Daemon user";
    };

    users.extraGroups.deluge.gid = gid;
  };
}
