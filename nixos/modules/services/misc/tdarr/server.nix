{
  config,
  lib,
  ...
}:

let
  cfg = config.services.tdarr;
  serverDataDir = "${cfg.dataDir}/server";
  serverEnabled = cfg.enable || cfg.server.enable;
in
{
  options.services.tdarr.server = {
    enable = lib.mkEnableOption "Tdarr server";

    package = lib.mkOption {
      type = lib.types.package;
      default = cfg.package.server;
      defaultText = lib.literalExpression "config.services.tdarr.package.server";
      description = "Package to use for the Tdarr server.";
    };

    serverPort = lib.mkOption {
      type = lib.types.port;
      default = 8266;
      description = "Port for server API communication.";
    };

    webUIPort = lib.mkOption {
      type = lib.types.port;
      default = 8265;
      description = "Port for the Tdarr web UI.";
    };

    serverIP = lib.mkOption {
      type = lib.types.str;
      default = "0.0.0.0";
      description = "IP address the server binds to.";
    };

    serverBindIP = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to bind to the specific IP in {option}`services.tdarr.server.serverIP`.";
    };

    serverDualStack = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Enable dual-stack (IPv4/IPv6) networking.

        When enabled, the server binds to `::` if IPv6 is available, accepting both
        IPv4 and IPv6 connections. Useful in Kubernetes and other modern networking setups.
      '';
    };

    maxLogSizeMB = lib.mkOption {
      type = lib.types.ints.unsigned;
      default = 10;
      description = "Maximum log file size in megabytes.";
    };

    cronPluginUpdate = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Cron expression for automatic plugin updates. Empty string disables.";
      example = "0 2 * * *";
    };

    auth.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to enable authentication for the Tdarr web UI and API.";
    };

    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        File containing environment variable overrides for the server,
        in the format accepted by systemd's `EnvironmentFile`.

        Useful for setting secrets such as `authSecretKey` or `seededApiKey`
        without exposing them in the Nix store.

        Example file contents:
        ```
        authSecretKey=your-secret-key
        seededApiKey=tapi_your_api_key_here
        ```
      '';
      example = "/run/secrets/tdarr-server-env";
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to open the firewall for the Tdarr server web UI and API ports.";
    };
  };

  config = lib.mkIf serverEnabled {
    systemd.tmpfiles.rules = [
      "d ${serverDataDir} 0750 ${cfg.user} ${cfg.group} -"
      "d ${serverDataDir}/configs 0750 ${cfg.user} ${cfg.group} -"
    ];

    systemd.services.tdarr-server = {
      description = "Tdarr Server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      environment = {
        serverPort = toString cfg.server.serverPort;
        webUIPort = toString cfg.server.webUIPort;
        serverIP = cfg.server.serverIP;
        serverBindIP = lib.boolToString cfg.server.serverBindIP;
        serverDualStack = lib.boolToString cfg.server.serverDualStack;
        openBrowser = "false";
        auth = lib.boolToString cfg.server.auth.enable;
        maxLogSizeMB = toString cfg.server.maxLogSizeMB;
        cronPluginUpdate = cfg.server.cronPluginUpdate;
        rootDataPath = serverDataDir;
      };
      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        ExecStart = lib.getExe cfg.server.package;
        Restart = "on-failure";
        RestartSec = 5;
        WorkingDirectory = serverDataDir;

        # Hardening
        NoNewPrivileges = true;
        PrivateTmp = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        ReadWritePaths = [ cfg.dataDir ];
      }
      // lib.optionalAttrs (cfg.server.environmentFile != null) {
        EnvironmentFile = cfg.server.environmentFile;
      };
    };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.server.openFirewall [
      cfg.server.serverPort
      cfg.server.webUIPort
    ];
  };
}
