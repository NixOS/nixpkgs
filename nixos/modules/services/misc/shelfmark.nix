{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.services.shelfmark;
in
{
  options.services.shelfmark = {

    enable = lib.mkEnableOption "Shelfmark, a self-hosted book and audiobook search and download interface";

    package = lib.mkPackageOption pkgs "shelfmark" { };

    host = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      example = "0.0.0.0";
      description = "The IP address to bind the Shelfmark server to.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8084;
      description = "TCP port for the Shelfmark web interface.";
    };

    dataDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/shelfmark";
      description = "Directory for Shelfmark configuration, database, and artwork cache.";
    };

    ingestDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/shelfmark/books";
      description = "Directory where downloaded books are stored.";
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Open the appropriate ports in the firewall for Shelfmark.";
    };

    environment = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      example = {
        SEARCH_MODE = "universal";
        LOG_LEVEL = "DEBUG";
      };
      description = ''
        Extra environment variables to pass to the Shelfmark service.
        See <https://github.com/calibrain/shelfmark/blob/main/docs/environment-variables.md>
        for available options.
      '';
    };
  };

  config = lib.mkIf cfg.enable {

    systemd.services.shelfmark = {
      description = "Shelfmark - book and audiobook search and download interface";
      wantedBy = [ "multi-user.target" ];
      environment = {
        CONFIG_DIR = cfg.dataDir;
        INGEST_DIR = cfg.ingestDir;
        FLASK_HOST = cfg.host;
        FLASK_PORT = toString cfg.port;
        # Disable file logging; systemd captures stdout/stderr via journal
        ENABLE_LOGGING = "false";
      }
      // cfg.environment;
      serviceConfig =
        let
          ingestIsUnderState = lib.hasPrefix "/var/lib/shelfmark" cfg.ingestDir;
        in
        {
          DynamicUser = true;
          ExecStartPre = "+${pkgs.coreutils}/bin/mkdir -p ${cfg.ingestDir}";
          ExecStart = "${lib.getExe cfg.package} -b ${cfg.host}:${toString cfg.port}";
          StateDirectory = "shelfmark";
          ReadWritePaths = lib.optionals (!ingestIsUnderState) [ cfg.ingestDir ];

          # Filesystem
          ProtectSystem = "strict";
          ProtectHome = true;
          PrivateTmp = true;
          PrivateDevices = true;
          PrivateMounts = true;
          ProtectControlGroups = true;
          ProtectKernelTunables = true;
          RestrictSUIDSGID = true;
          RemoveIPC = true;
          UMask = "0077";

          # Capabilities
          CapabilityBoundingSet = "";
          NoNewPrivileges = true;

          # Kernel
          ProtectKernelModules = true;
          ProtectKernelLogs = true;
          ProtectClock = true;
          SystemCallArchitectures = "native";
          SystemCallFilter = [
            "@system-service"
            "~@privileged"
            "~@resources"
          ];

          # Networking — cannot use PrivateNetwork, service needs outbound HTTP
          RestrictAddressFamilies = [
            "AF_INET"
            "AF_INET6"
            "AF_UNIX"
          ];

          # User
          PrivateUsers = true;

          # Misc
          LockPersonality = true;
          ProtectHostname = true;
          RestrictRealtime = true;
          RestrictNamespaces = true;
          ProtectProc = "invisible";
          ProcSubset = "pid";
          DeviceAllow = "";
        };
    };

    systemd.tmpfiles.rules = lib.optionals (cfg.ingestDir != "/var/lib/shelfmark/books") [
      "d '${cfg.ingestDir}' 0750 - - - -"
    ];

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };
  };

  meta = {
    maintainers = with lib.maintainers; [ jamiemagee ];
  };
}
