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

      package = mkOption {
        type = types.package;
        example = literalExample "pkgs.jellyfin";
        description = ''
          Jellyfin package to use.
        '';
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
        ExecStart = "${cfg.package}/bin/jellyfin --datadir '/var/lib/${StateDirectory}' --cachedir '/var/cache/${CacheDirectory}'";
        Restart = "on-failure";
      };
    };

    services.jellyfin.package = mkDefault (
      if versionAtLeast config.system.stateVersion "20.09" then pkgs.jellyfin
        else pkgs.jellyfin_10_5
    );

    users.users = mkIf (cfg.user == "jellyfin") {
      jellyfin = {
        group = cfg.group;
        isSystemUser = true;
      };
    };

    users.groups = mkIf (cfg.group == "jellyfin") {
      jellyfin = {};
    };

  };

  meta.maintainers = with lib.maintainers; [ minijackson ];
}
