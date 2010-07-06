{ config, pkgs, ... }:

with pkgs.lib;

let 

  cfg = config.services.sabnzbd;
  inherit (pkgs) sabnzbd;

in

{

  ###### interface

  options = {
    services.sabnzbd = {
      enable = mkOption {
        default = false;
        description = "Whether to enable the sabnzbd FTP server.";
      };
      configFile = mkOption {
        default = "/var/sabnzbd/sabnzbd.ini";
        description = "Path to config file. (You need to create this file yourself!)";
      };
    };
  };
  

  ###### implementation

  config = mkIf cfg.enable {

    users.extraUsers =
      [ { name = "sabnzbd";
          uid = config.ids.uids.sabnzbd;
          description = "sabnzbd user";
          home = "/homeless-shelter";
        }
      ];

    jobs.sabnzbd =
      { description = "sabnzbd server";

        startOn = "network-interfaces/started";
        stopOn = "network-interfaces/stop";

        exec = "${sabnzbd}/bin/sabnzbd -d -f ${cfg.configFile}";
      };

  };
}
