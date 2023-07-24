{ pkgs
, lib
, config
, ...
}:

with lib; let
  cfg = config.services.audiobookshelf;
in

{
  options.services.audiobookshelf = {
    enable = mkEnableOption (lib.mdDoc  "Audiobookshelf, self-hosted audiobook and podcast server");

    host = mkOption {
      type = types.str;
      default = "127.0.0.1";
      description = lib.mdDoc ''
        The host address that Audiobookshelf will listen on.
      '';
    };

    port = mkOption {
      type = types.port;
      default = 8000;
      description = lib.mdDoc ''
        The port that Audiobookshelf will listen on.
      '';
    };

    user = mkOption {
      type = types.str;
      default = "audiobookshelf";
      description = lib.mdDoc ''
        User account under which Audiobookshelf runs.
      '';
    };

    group = mkOption {
      type = types.str;
      default = "audiobookshelf";
      description = lib.mdDoc ''
        Group under which Audiobookshelf runs.
      '';
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Whether to open the firewall for the port in {option}`services.audiobookshelf.port`.
      '';
    };

    configDir = mkOption {
      type = types.str;
      default = "/etc/audiobookshelf";
      description = lib.mdDoc ''
        Configuration directory Audiobookshelf will use.
      '';
    };

    metadataDir = mkOption {
      type = types.str;
      default = "/var/lib/audiobookshelf";
      description = lib.mdDoc ''
        Metadata directory Audiobookshelf will use.
      '';
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ cfg.port ];

    users.groups = mkIf (cfg.group == "audiobookshelf") {
      audiobookshelf = { };
    };

    users.users = mkIf (cfg.user == "audiobookshelf") {
      audiobookshelf = {
        group = cfg.group;
        description = "Audiobookshelf Daemon user";
        isSystemUser = true;
      };
    };

    systemd.services.audiobookshelf = {
      description = "Audiobookshelf is a self-hosted audiobook and podcast server";

      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        Type = "simple";
        Restart = "on-failure";
        StateDirectory = mkIf (cfg.metadataDir == "/var/lib/audiobookshelf") "audiobookshelf";
        ConfigurationDirectory = mkIf (cfg.configDir == "/etc/audiobookshelf") "audiobookshelf";
        ExecStart = ''
          ${pkgs.audiobookshelf}/bin/audiobookshelf \
            --host ${cfg.host} \
            --port ${toString cfg.port} \
            --metadata ${cfg.metadataDir} \
            --config ${cfg.configDir}
        '';
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ dit7ya ];
}
