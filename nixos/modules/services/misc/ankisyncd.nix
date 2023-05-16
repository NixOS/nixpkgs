{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.ankisyncd;

  name = "ankisyncd";

  stateDir = "/var/lib/${name}";

<<<<<<< HEAD
  toml = pkgs.formats.toml {};

  configFile = toml.generate "ankisyncd.conf" {
    listen = {
      host = cfg.host;
      port = cfg.port;
    };
    paths.root_dir = stateDir;
    # encryption.ssl_enable / cert_file / key_file
  };
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
in
  {
    options.services.ankisyncd = {
      enable = mkEnableOption (lib.mdDoc "ankisyncd");

      package = mkOption {
        type = types.package;
        default = pkgs.ankisyncd;
        defaultText = literalExpression "pkgs.ankisyncd";
        description = lib.mdDoc "The package to use for the ankisyncd command.";
      };

      host = mkOption {
        type = types.str;
        default = "localhost";
        description = lib.mdDoc "ankisyncd host";
      };

      port = mkOption {
        type = types.port;
        default = 27701;
        description = lib.mdDoc "ankisyncd port";
      };

      openFirewall = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc "Whether to open the firewall for the specified port.";
      };
    };

    config = mkIf cfg.enable {
      networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ cfg.port ];

<<<<<<< HEAD
=======
      environment.etc."ankisyncd/ankisyncd.conf".source = configFile;

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      systemd.services.ankisyncd = {
        description = "ankisyncd - Anki sync server";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        path = [ cfg.package ];

        serviceConfig = {
          Type = "simple";
          DynamicUser = true;
          StateDirectory = name;
<<<<<<< HEAD
          ExecStart = "${cfg.package}/bin/ankisyncd --config ${configFile}";
=======
          ExecStart = "${cfg.package}/bin/ankisyncd";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
          Restart = "always";
        };
      };
    };
  }
