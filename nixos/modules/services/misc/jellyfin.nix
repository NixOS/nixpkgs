{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.jellyfin;
in
{
  options = {
    services.jellyfin = {
      enable = mkEnableOption "Jellyfin Media Server";

      user = mkOption {
        type = types.str;
        default = "jellyfin";
        description = "User account under which Jellyfin runs.";
      };

      group = mkOption {
        type = types.str;
        default = "jellyfin";
        description = "Group under which jellyfin runs.";
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.jellyfin = {
      description = "Jellyfin Media Server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = rec {
        User = cfg.user;
        Group = cfg.group;
        StateDirectory = "jellyfin";
        CacheDirectory = "jellyfin";
        ExecStart = "${pkgs.jellyfin}/bin/jellyfin --datadir '/var/lib/${StateDirectory}' --cachedir '/var/cache/${CacheDirectory}'";
        Restart = "on-failure";
      };
    };

    users.users = mkIf (cfg.user == "jellyfin") {
      jellyfin.group = cfg.group;
    };

    users.groups = mkIf (cfg.group == "jellyfin") {
      jellyfin = {};
    };

    assertions = [
      {
        assertion = !config.services.emby.enable;
        message = "Emby and Jellyfin are incompatible, you cannot enable both";
      }
    ];
  };

  meta.maintainers = with lib.maintainers; [ minijackson ];
}
