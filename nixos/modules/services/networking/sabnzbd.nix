{ config, lib, pkgs, ... }:

let

  cfg = config.services.sabnzbd;

in

{

  ###### interface

  options = {
    services.sabnzbd = {
      enable = lib.mkEnableOption "the sabnzbd server";

      package = lib.mkPackageOption pkgs "sabnzbd" { };

      configFile = lib.mkOption {
        type = lib.types.path;
        default = "/var/lib/sabnzbd/sabnzbd.ini";
        description = "Path to config file.";
      };

      user = lib.mkOption {
        default = "sabnzbd";
        type = lib.types.str;
        description = "User to run the service as";
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "sabnzbd";
        description = "Group to run the service as";
      };

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Open ports in the firewall for the sabnzbd web interface
        '';
      };
    };
  };


  ###### implementation

  config = lib.mkIf cfg.enable {
    users.users = lib.mkIf (cfg.user == "sabnzbd") {
      sabnzbd = {
        uid = config.ids.uids.sabnzbd;
        group = cfg.group;
        description = "sabnzbd user";
      };
    };

    users.groups = lib.mkIf (cfg.group == "sabnzbd") {
      sabnzbd.gid = config.ids.gids.sabnzbd;
    };

    systemd.services.sabnzbd = {
        description = "sabnzbd server";
        wantedBy    = [ "multi-user.target" ];
        after = [ "network.target" ];
        serviceConfig = {
          Type = "forking";
          GuessMainPID = "no";
          User = cfg.user;
          Group = cfg.group;
          StateDirectory = "sabnzbd";
          ExecStart = "${lib.getBin cfg.package}/bin/sabnzbd -d -f ${cfg.configFile}";
        };
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ 8080 ];
    };
  };
}
