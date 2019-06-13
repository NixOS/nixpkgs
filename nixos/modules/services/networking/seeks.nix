{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.seeks;

  confDir = cfg.confDir;

  seeks = pkgs.seeks.override { seeks_confDir = confDir; };

in

{

  ###### interface

  options = {

    services.seeks = {

      enable = mkOption {
        default = false;
        type = types.bool;
        description = "
          Whether to enable the Seeks server.
        ";
      };

      confDir = mkOption {
        default = "";
        type = types.str;
        description = "
          The Seeks server configuration. If it is not specified,
          a default configuration is used.
        ";
      };

    };

  };


  ###### implementation

  config = mkIf config.services.seeks.enable {

    users.users.seeks =
      { uid = config.ids.uids.seeks;
        description = "Seeks user";
        createHome = true;
        home = "/var/lib/seeks";
      };

    users.groups.seeks =
      { gid = config.ids.gids.seeks;
      };

    systemd.services.seeks =
      {
        description = "Seeks server, the p2p search engine.";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          User = "seeks";
          ExecStart = "${seeks}/bin/seeks";
        };
      };

    environment.systemPackages = [ seeks ];

  };

}
