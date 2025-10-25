{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.audiobookshelf;
in
{
  options = {
    services.audiobookshelf = {
      enable = mkEnableOption "Audiobookshelf, self-hosted audiobook and podcast server";

      package = mkPackageOption pkgs "audiobookshelf" { };

      dataDir = mkOption {
        description = "Path to Audiobookshelf config and metadata.";
        default = "/var/lib/audiobookshelf";
        type = types.str;
      };

      host = mkOption {
        description = "The host Audiobookshelf binds to.";
        default = "127.0.0.1";
        example = "0.0.0.0";
        type = types.str;
      };

      port = mkOption {
        description = "The TCP port Audiobookshelf will listen on.";
        default = 8000;
        type = types.port;
      };

      user = mkOption {
        description = "User account under which Audiobookshelf runs.";
        default = "audiobookshelf";
        type = types.str;
      };

      group = mkOption {
        description = "Group under which Audiobookshelf runs.";
        default = "audiobookshelf";
        type = types.str;
      };

      openFirewall = mkOption {
        description = "Open ports in the firewall for the Audiobookshelf web interface.";
        default = false;
        type = types.bool;
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.audiobookshelf = {
      description = "Audiobookshelf is a self-hosted audiobook and podcast server";

      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        StateDirectory = cfg.dataDir;
        WorkingDirectory = cfg.dataDir;
        ExecStart = "${cfg.package}/bin/audiobookshelf --host ${cfg.host} --port ${toString cfg.port}";
        Restart = "on-failure";
      };
    };

    users.users = mkIf (cfg.user == "audiobookshelf") {
      audiobookshelf = {
        isSystemUser = true;
        group = cfg.group;
        home = "/var/lib/${cfg.dataDir}";
      };
    };

    users.groups = mkIf (cfg.group == "audiobookshelf") {
      audiobookshelf = { };
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };
  };

  meta.maintainers = with maintainers; [ wietsedv ];
}
