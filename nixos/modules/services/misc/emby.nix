{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.emby;
in
{
  options = {
    services.emby = {
      enable = mkEnableOption "Emby Media Server";

      user = mkOption {
        type = types.str;
        default = "emby";
        description = "User account under which Emby runs.";
      };

      group = mkOption {
        type = types.str;
        default = "emby";
        description = "Group under which emby runs.";
      };

      dataDir = mkOption {
        type = types.path;
        default = "/var/lib/emby/ProgramData-Server";
        description = "Location where Emby stores its data.";
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.emby = {
      description = "Emby Media Server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      preStart = ''
        if [ -d ${cfg.dataDir} ]
        then
            for plugin in ${cfg.dataDir}/plugins/*
            do
                echo "Correcting permissions of plugin: $plugin"
                chmod u+w $plugin
            done
        else
            echo "Creating initial Emby data directory in ${cfg.dataDir}"
            mkdir -p ${cfg.dataDir}
            chown -R ${cfg.user}:${cfg.group} ${cfg.dataDir}
        fi
      '';

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        PermissionsStartOnly = "true";
        ExecStart = "${pkgs.emby}/bin/emby -programdata ${cfg.dataDir}";
        Restart = "on-failure";
      };
    };

    users.users = mkIf (cfg.user == "emby") {
      emby = {
        group = cfg.group;
        uid = config.ids.uids.emby;
      };
    };

    users.groups = mkIf (cfg.group == "emby") {
      emby = {
        gid = config.ids.gids.emby;
      };
    };
  };
}
