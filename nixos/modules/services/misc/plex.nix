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
        User = "plex";
        Group = "plex";
        ExecStart = "${cfg.package}/bin/plexmediaserver";
      };

      environment.PLEX_MEDIA_SERVER_APPLICATION_SUPPORT_DIR = cfg.dataDir;
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ 32400 3005 8324 32469 ];
      allowedUDPPorts = [ 1900 5353 32410 32412 32413 32414 ];
    };

    users.users.plex = {
      createHome = true;
      group = "plex";
      home = cfg.dataDir;
      uid = config.ids.uids.plex;
    };

    users.groups.plex.gid = config.ids.gids.plex;
  };
}
