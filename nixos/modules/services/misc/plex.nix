{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.plex;
in

{
  options = {
    services.plex = {
      enable = mkEnableOption "Plex Media Server";

      dataDir = mkOption {
        default = "/var/lib/plex";
        description = "The directory where Plex stores its data files.";
        type = types.str;
      };

      openFirewall = mkOption {
        default = false;
        description = "Open ports in the firewall for the media server.";
        type = types.bool;
      };

      package = mkOption {
        default = pkgs.plex;
        defaultText = "pkgs.plex";
        description = ''
          The Plex package to use. Plex subscribers may wish to use their own
          package here, pointing to subscriber-only server versions.
        '';
        type = types.package;
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.plex = {
      description = "Plex Media Server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        User = config.ids.uids.plex;
        Group = config.ids.gids.plex;
        PermissionsStartOnly = "true";
        ExecStart = "\"${cfg.package}/bin/plexmediaserver\"";
        KillSignal = "SIGQUIT";
        Restart = "on-failure";
      };
      environment = {
        PLEX_MEDIA_SERVER_APPLICATION_SUPPORT_DIR=cfg.dataDir;
        PLEX_MEDIA_SERVER_HOME="${cfg.package}/usr/lib/plexmediaserver";
        PLEX_MEDIA_SERVER_MAX_PLUGIN_PROCS="6";
        PLEX_MEDIA_SERVER_TMPDIR="/tmp";
        LD_LIBRARY_PATH="/run/opengl-driver/lib:${cfg.package}/usr/lib/plexmediaserver";
        LC_ALL="en_US.UTF-8";
        LANG="en_US.UTF-8";
      };
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ 32400 3005 8324 32469 ];
      allowedUDPPorts = [ 1900 5353 32410 32412 32413 32414 ];
    };

    users.users.plex = {
      group = "plex";
      uid = config.ids.uids.plex;
    };

    users.groups.plex = {
      gid = config.ids.gids.plex;
    };
  };
}
