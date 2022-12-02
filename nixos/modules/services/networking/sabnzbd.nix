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
      enable = mkEnableOption (lib.mdDoc "the sabnzbd server");

      package = mkOption {
        type = types.package;
        default = pkgs.sabnzbd;
        defaultText = "pkgs.sabnzbd";
        description = lib.mdDoc "The sabnzbd executable package run by the service.";
      };

      configFile = mkOption {
        type = types.path;
        default = "/var/lib/sabnzbd/sabnzbd.ini";
        description = lib.mdDoc "Path to config file.";
      };

      user = mkOption {
        default = "sabnzbd";
        type = types.str;
        description = lib.mdDoc "User to run the service as";
      };

      group = mkOption {
        type = types.str;
        default = "sabnzbd";
        description = lib.mdDoc "Group to run the service as";
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
          ExecStart = "${lib.getBin cfg.package}/bin/sabnzbd -d -f ${cfg.configFile}";
        };
    };
  };
}
