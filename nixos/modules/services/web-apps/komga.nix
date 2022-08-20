{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.komga;

in {
  options = {
    services.komga = {
      enable = mkEnableOption "Komga, a free and open source comics/mangas media server";

      port = mkOption {
        type = types.port;
        default = 8080;
        description = lib.mdDoc ''
          The port that Komga will listen on.
        '';
      };

      user = mkOption {
        type = types.str;
        default = "komga";
        description = lib.mdDoc ''
          User account under which Komga runs.
        '';
      };

      group = mkOption {
        type = types.str;
        default = "komga";
        description = lib.mdDoc ''
          Group under which Komga runs.
        '';
      };

      stateDir = mkOption {
        type = types.str;
        default = "/var/lib/komga";
        description = lib.mdDoc ''
          State and configuration directory Komga will use.
        '';
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to open the firewall for the port in {option}`services.komga.port`.
        '';
      };
    };
  };

  config = mkIf cfg.enable {

    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ cfg.port ];

    users.groups = mkIf (cfg.group == "komga") {
      komga = {};
    };

    users.users = mkIf (cfg.user == "komga") {
      komga = {
        group = cfg.group;
        home = cfg.stateDir;
        description = "Komga Daemon user";
        isSystemUser = true;
      };
    };

    systemd.services.komga = {
      environment = {
        SERVER_PORT = builtins.toString cfg.port;
        KOMGA_CONFIGDIR = cfg.stateDir;
      };

      description = "Komga is a free and open source comics/mangas media server";

      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;

        Type = "simple";
        Restart = "on-failure";
        ExecStart = "${pkgs.komga}/bin/komga";

        StateDirectory = mkIf (cfg.stateDir == "/var/lib/komga") "komga";
      };

    };
  };

  meta.maintainers = with maintainers; [ govanify ];
}
