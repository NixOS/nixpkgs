{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.ankisyncd;

  name = "ankisyncd";

  stateDir = "/var/lib/${name}";

  authDbPath = "${stateDir}/auth.db";

  sessionDbPath = "${stateDir}/session.db";

  configFile = pkgs.writeText "ankisyncd.conf" (lib.generators.toINI {} {
    sync_app = {
      host = cfg.host;
      port = cfg.port;
      data_root = stateDir;
      auth_db_path = authDbPath;
      session_db_path = sessionDbPath;

      base_url = "/sync/";
      base_media_url = "/msync/";
    };
  });
in
  {
    options.services.ankisyncd = {
      enable = mkEnableOption "ankisyncd";

      package = mkOption {
        type = types.package;
        default = pkgs.ankisyncd;
        defaultText = literalExample "pkgs.ankisyncd";
        description = "The package to use for the ankisyncd command.";
      };

      host = mkOption {
        type = types.str;
        default = "localhost";
        description = "ankisyncd host";
      };

      port = mkOption {
        type = types.int;
        default = 27701;
        description = "ankisyncd port";
      };

      openFirewall = mkOption {
        default = false;
        type = types.bool;
        description = "Whether to open the firewall for the specified port.";
      };
    };

    config = mkIf cfg.enable {
      networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ cfg.port ];

      environment.etc."ankisyncd/ankisyncd.conf".source = configFile;

      systemd.services.ankisyncd = {
        description = "ankisyncd - Anki sync server";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        path = [ cfg.package ];

        serviceConfig = {
          Type = "simple";
          DynamicUser = true;
          StateDirectory = name;
          ExecStart = "${cfg.package}/bin/ankisyncd";
          Restart = "always";
        };
      };
    };
  }
