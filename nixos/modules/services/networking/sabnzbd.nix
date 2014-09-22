{ config, lib, pkgs, ... }:

with lib;

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

    systemd.services.sabnzbd =
      { description = "sabnzbd server";
        wantedBy    = [ "multi-user.target" ];
        after = [ "network.target" ];
        serviceConfig = {
          Type = "forking";
          ExecStart = "${sabnzbd}/bin/sabnzbd -d -f ${cfg.configFile}";
        };
      };

  };
}
