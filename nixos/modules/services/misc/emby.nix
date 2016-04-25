{ config, pkgs, lib, mono, ... }:

with lib;

let
  cfg = config.services.emby;
  emby = pkgs.emby;
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
    };
  };

  config = mkIf cfg.enable {
    systemd.services.emby = {
      description = "Emby Media Server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      preStart = ''
        test -d /var/lib/emby/ProgramData-Server || {
          echo "Creating initial Emby data directory in /var/lib/emby/ProgramData-Server"
          mkdir -p /var/lib/emby/ProgramData-Server
          chown -R ${cfg.user}:${cfg.group} /var/lib/emby/ProgramData-Server
          }
      '';

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        PermissionsStartOnly = "true";
        ExecStart = "${pkgs.mono}/bin/mono ${pkgs.emby}/bin/MediaBrowser.Server.Mono.exe";
        Restart = "on-failure";
      };
    };

    users.extraUsers = mkIf (cfg.user == "emby") {
      emby = {
        group = cfg.group;
        uid = config.ids.uids.emby;
      };
    };

    users.extraGroups = mkIf (cfg.group == "emby") {
      emby = {
        gid = config.ids.gids.emby;
      };
    };
  };
}
