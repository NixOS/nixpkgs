{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.arangodb;

in {

  ###### interface

  options = {
    services.arangodb = {
      enable = mkEnableOption "ArangoDB server";

      dataDir = mkOption {
        type = types.path;
        default = "/var/db/arangodb";
        description = "ArangoDB data dir";
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
        mkdir -p ${cfg.dataDir}
        chown -R arangodb:arangodb ${cfg.dataDir}
        '';

      script = ''
        exec ${pkgs.arangodb}/bin/arangod \
            --database.directory ${cfg.dataDir} \
            --javascript.app-path ${cfg.dataDir} \
            --log.file ${cfg.dataDir}/arangodb.log \
            --working-directory ${cfg.dataDir}
        '';

      serviceConfig = {
        User = "arangodb";
        Group = "arangodb";
        PermissionsStartOnly = true;
      };
    };
  };
}
