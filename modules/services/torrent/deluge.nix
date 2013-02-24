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
        example = "true";
        description = ''
          Start Deluge daemon.
        ''; 
      };  
    };

    services.deluge.web = {
      enable = mkOption {
        default = false;
        example = "true";
        description = ''
          Start Deluge Web daemon.
        ''; 
      };  
    };
  };

  config = mkIf cfg.enable {

    systemd.services.deluged = {
      after = [ "network.target" ];
      description = "Deluge Daemon";
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.pythonPackages.deluge ];
      script = "deluged -d";
    };

    systemd.services.delugeweb = mkIf cfg_web.enable {
      after = [ "network.target" "deluged.service" ];
      description = "Deluge Web";
      wantedBy = [ "multi-user.target" ];
      wants = [ "deluged.service" ];
      path = [ pkgs.pythonPackages.deluge ];
      script = "deluge --ui web";
    };

    environment.systemPackages = [ pkgs.pythonPackages.deluge ];

    users.extraUsers.deluge = {
      inherit uid;
      group = "deluge";
      description = "Deluge Daemon user";
    };

    users.extraGroups.deluge.gid = gid;
  };
}
