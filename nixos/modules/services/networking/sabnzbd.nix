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
      enable = mkEnableOption "the sabnzbd server";

      configFile = mkOption {
        type = types.path;
        default = "/var/lib/sabnzbd/sabnzbd.ini";
        description = "Path to config file.";
      };

      user = mkOption {
        default = "sabnzbd";
        type = types.str;
        description = "User to run the service as";
      };

      group = mkOption {
        type = types.str;
        default = "sabnzbd";
        description = "Group to run the service as";
      };
    };
  };


  ###### implementation

  config = mkIf cfg.enable {

    users.users.sabnzbd = {
          uid = config.ids.uids.sabnzbd;
          group = "sabnzbd";
          description = "sabnzbd user";
          home = "/var/lib/sabnzbd/";
          createHome = true;
    };

    users.groups.sabnzbd = {
      gid = config.ids.gids.sabnzbd;
    };

    systemd.services.sabnzbd = {
        description = "sabnzbd server";
        wantedBy    = [ "multi-user.target" ];
        after = [ "network.target" ];
        serviceConfig = {
          Type = "forking";
          GuessMainPID = "no";
          User = "${cfg.user}";
          Group = "${cfg.group}";
          ExecStart = "${sabnzbd}/bin/sabnzbd -d -f ${cfg.configFile}";
        };
    };
  };
}
