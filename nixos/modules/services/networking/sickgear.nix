{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.sickgear;

in

{

  ###### interface

  options = {
    services.sickgear = {
      enable = mkOption {
        default = false;
        description = "Whether to enable the sickgear server.";
      };
      dataDir = mkOption {
        default = "/var/lib/sickgear";
        description = "Path where to store data files.";
      };
      configFile = mkOption {
        default = "/var/lib/sickgear/config.ini";
        description = "Path to config file.";
      };
      port = mkOption {
        default = 8081;
        description = "Port to bind to.";
      };
      user = mkOption {
        default = "sickgear";
        description = "User to run the service as";
      };
      group = mkOption {
        default = "sickgear";
        description = "Group to run the service as";
      };
    };
  };


  ###### implementation

  config = mkIf cfg.enable {

    users.users.sickgear = {
          uid = config.ids.uids.sickgear;
          group = "sickgear";
          description = "sickgear user";
          home = "/var/lib/sickgear/";
          createHome = true;
    };

    users.groups.sickgear = {
      gid = config.ids.gids.sickgear;
    };

    systemd.services.sickgear = {
        description = "sickgear server";
        wantedBy    = [ "multi-user.target" ];
        after = [ "network.target" ];
        serviceConfig = {
          User = "${cfg.user}";
          Group = "${cfg.group}";
          ExecStart = "${pkgs.sickgear}/bin/sickgear --datadir ${cfg.dataDir} --config ${cfg.configFile} --port ${toString cfg.port}";
        };
    };
  };
}
