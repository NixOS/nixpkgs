{ config, lib, pkgs, ... }:

with lib;

let
  name = "roon-server";
  uid = config.ids.uids.roon-server;
  gid = config.ids.gids.roon-server;
  cfg = config.services.roon-server;
in {
  options = {
    services.roon-server = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable the Roon Server.";
      };

      dataDir = mkOption {
        type = types.path;
        default = "/var/lib/${name}";
        description = "The directory where the Roon Server stores its state.";
      };

      user = mkOption {
        type = types.str;
        default = name;
        description = "User account under which the Roon Server runs.";
      };

      group = mkOption {
        type = types.str;
        default = name;
        description = "Group account under which the Roon Server runs.";
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.roon-server = {
      after = [ "network.target" ];
      description = "Roon Server";
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Environment = "\"ROON_DATAROOT=${cfg.dataDir}\"";
        ExecStart = "${pkgs.bash}/bin/bash ${pkgs.roon-server}/opt/start.sh";
        ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p ${cfg.dataDir} && chown ${cfg.user}:${cfg.group} ${cfg.dataDir}";
        LimitNOFILE = 8192;
        PermissionsStartOnly = true;
        User = "${cfg.user}";
      };
    };

    users.users = optionalAttrs (cfg.user == name) (singleton {
      inherit uid;
      inherit name;
      group = cfg.group;
      extraGroups = [ "audio" ];
      description = "roon-server user";
    });

    users.groups = optionalAttrs (cfg.group == name) (singleton {
      inherit name;
      gid = gid;
    });
  };
}
