{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.seeks;

  confDir = cfg.confDir;

  seeks = pkgs.seeks.override { seeks_confdir = confDir; };

in

{

  ###### interface

  options = {

    services.seeks = {

      enable = mkOption {
        default = false;
        description = "
          Whether to enable the Seeks server.
        ";
      };

      confDir = mkOption {
        default = "";
        description = "
          The Seeks server configuration directory. If it is not
          is specified, a default directory is used (${pkgs.seeks}/etc). Make
          sure that this directory is writable by nixbld group, because path is
          set at compile time.
        ";
      };

    };

  };


  ###### implementation

  config = mkIf config.services.seeks.enable {

    users.extraUsers.seeks =
      { uid = config.ids.uids.seeks;
        description = "Seeks user";
        createHome = true;
        home = "/var/lib/seeks";
      };

    users.extraGroups.seeks =
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
