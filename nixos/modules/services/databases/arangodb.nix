{ config, lib, pkgs, ... }:
let
  cfg = config.services.arangodb;
  stateDir = "/var/lib/arango";
in
with lib;
{

  ###### interface

  options = {

    services.arangodb = {

      enable = mkOption {
        default = false;
        description = "Whether to enable ArangoDB database server.";
      };

    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    users.extraUsers.arangodb = {
      name = "arangodb";
      uid = config.ids.uids.arangodb;
      group = "arangodb";
      description = "ArangoDB server user";
    };

    users.extraGroups.arangodb.gid = config.ids.gids.arangodb;

    systemd.services.arangodb = {
      description = "ArangoDB server";

      wantedBy = [ "multi-user.target" ];

      after = [ "network.target" ];

      preStart = ''
        mkdir -p ${stateDir}
        chown arangodb:arangodb ${stateDir}
      '';

      script = ''
        exec ${pkgs.arangodb}/bin/arangod     \
          --database.directory ${stateDir}    \
          --javascript.app-path ${stateDir}   \
          --log.file ${stateDir}/arangodb.log \
          --working-directory ${stateDir}     \
          --cluster.password root             \
          > ${stateDir}/arangodb.stdout 2>&1
      '';

      serviceConfig = {
        User = "arangodb";
        Group = "arangodb";
        PermissionsStartOnly = true;
      };
    };

  };

}
