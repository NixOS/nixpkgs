{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.atuin;
in
{
  options = {
    services.atuin = {
      enable = mkEnableOption (mdDoc "Enable server for shell history sync with atuin");

      openRegistration = mkOption {
        type = types.bool;
        default = false;
        description = mdDoc "Allow new user registrations with the atuin server.";
      };

      path = mkOption {
        type = types.str;
        default = "";
        description = mdDoc "A path to prepend to all the routes of the server.";
      };

      host = mkOption {
        type = types.str;
        default = "127.0.0.1";
        description = mdDoc "The host address the atuin server should listen on.";
      };

      maxHistoryLength = mkOption {
        type = types.int;
        default = 8192;
        description = mdDoc "The max length of each history item the atuin server should store.";
      };

      port = mkOption {
        type = types.port;
        default = 8888;
        description = mdDoc "The port the atuin server should listen on.";
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = mdDoc "Open ports in the firewall for the atuin server.";
      };

    };
  };

  config = mkIf cfg.enable {

    # enable postgres to host atuin db
    services.postgresql = {
      enable = true;
      ensureUsers = [{
        name = "atuin";
        ensurePermissions = {
          "DATABASE atuin" = "ALL PRIVILEGES";
        };
      }];
      ensureDatabases = [ "atuin" ];
    };

    systemd.services.atuin = {
      description = "atuin server";
      after = [ "network.target" "postgresql.service" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = "${pkgs.atuin}/bin/atuin server start";
        RuntimeDirectory = "atuin";
        RuntimeDirectoryMode = "0700";
        DynamicUser = true;
      };

      environment = {
        ATUIN_HOST = cfg.host;
        ATUIN_PORT = toString cfg.port;
        ATUIN_MAX_HISTORY_LENGTH = toString cfg.maxHistoryLength;
        ATUIN_OPEN_REGISTRATION = boolToString cfg.openRegistration;
        ATUIN_DB_URI = "postgresql:///atuin";
        ATUIN_PATH = cfg.path;
        ATUIN_CONFIG_DIR = "/run/atuin"; # required to start, but not used as configuration is via environment variables
      };
    };

    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ cfg.port ];

  };
}
