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
        default = pkgs.jellyfin;
        defaultText = literalExpression "pkgs.jellyfin";
        description = ''
          Jellyfin package to use.
        '';
      };

      group = mkOption {
        type = types.str;
        default = "jellyfin";
        description = "Group under which jellyfin runs.";
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Open the default ports in the firewall for the media server. The
          HTTP/HTTPS ports can be changed in the Web UI, so this option should
          only be used if they are unchanged.
        '';
      };
    };
  };

  config = mkIf cfg.enable {

    systemd.packages = [ cfg.package ]; # will this get merged at systemd level?

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
      };
    };

    users.users = mkIf (cfg.user == "jellyfin") {
      jellyfin = {
        group = cfg.group;
        isSystemUser = true;
      };
    };

    users.groups = mkIf (cfg.group == "jellyfin") {
      jellyfin = {};
    };

    networking.firewall = mkIf cfg.openFirewall {
      # from https://jellyfin.org/docs/general/networking/index.html
      allowedTCPPorts = [ 8096 8920 ];
      allowedUDPPorts = [ 1900 7359 ];
    };

  };

  meta.maintainers = with lib.maintainers; [ minijackson ];
}
