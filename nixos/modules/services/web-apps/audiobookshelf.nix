{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.audiobookshelf;
in
{
  options = {
    services.audiobookshelf = {
      enable = lib.mkEnableOption "Audiobookshelf, self-hosted audiobook and podcast server";

      package = lib.mkPackageOption pkgs "audiobookshelf" { };

      dataDir = lib.mkOption {
        description = "Path to Audiobookshelf config and metadata inside of /var/lib.";
        default = "audiobookshelf";
        type = lib.types.str;
      };

      host = lib.mkOption {
        description = "The host Audiobookshelf binds to.";
        default = "127.0.0.1";
        example = "0.0.0.0";
        type = lib.types.str;
      };

      port = lib.mkOption {
        description = "The TCP port Audiobookshelf will listen on.";
        default = 8000;
        type = lib.types.port;
      };

      user = lib.mkOption {
        description = "User account under which Audiobookshelf runs.";
        default = "audiobookshelf";
        type = lib.types.str;
      };

      group = lib.mkOption {
        description = "Group under which Audiobookshelf runs.";
        default = "audiobookshelf";
        type = lib.types.str;
      };

      openFirewall = lib.mkOption {
        description = "Open ports in the firewall for the Audiobookshelf web interface.";
        default = false;
        type = lib.types.bool;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.audiobookshelf = {
      description = "Audiobookshelf is a self-hosted audiobook and podcast server";

      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        StateDirectory = cfg.dataDir;
        WorkingDirectory = "/var/lib/${cfg.dataDir}";
        ExecStart = "${cfg.package}/bin/audiobookshelf --host ${cfg.host} --port ${toString cfg.port}";
        Restart = "on-failure";
      };
    };

    users.users = lib.mkIf (cfg.user == "audiobookshelf") {
      audiobookshelf = {
        isSystemUser = true;
        group = cfg.group;
        home = "/var/lib/${cfg.dataDir}";
      };
    };

    users.groups = lib.mkIf (cfg.group == "audiobookshelf") {
      audiobookshelf = { };
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };
  };

  meta.maintainers = with lib.maintainers; [ wietsedv ];
}
