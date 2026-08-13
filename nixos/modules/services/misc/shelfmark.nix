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

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Open the appropriate ports in the firewall for Shelfmark.";
    };

    environment = lib.mkOption {
      type = lib.types.submodule {
        freeformType = lib.types.attrsOf lib.types.str;
        options = {
          FLASK_HOST = lib.mkOption {
            type = lib.types.str;
            default = "127.0.0.1";
            example = "0.0.0.0";
            description = "The IP address to bind the Shelfmark server to.";
          };

          FLASK_PORT = lib.mkOption {
            type = lib.types.port;
            default = 8084;
            apply = toString;
            description = "TCP port for the Shelfmark web interface.";
          };

          ENABLE_LOGGING = lib.mkOption {
            type = lib.types.bool;
            apply = toString;
            default = false;
            description = "Whether to enable file logging. Disabled by default since systemd captures console output via journald.";
          };

          CONFIG_DIR = lib.mkOption {
            type = lib.types.path;
            default = "/var/lib/shelfmark";
            description = "Directory for Shelfmark configuration, database, and artwork cache.";
          };
        };
      };
      default = { };
      example = {
        SEARCH_MODE = "universal";
        LOG_LEVEL = "DEBUG";
      };
      description = ''
        Environment variables to pass to the Shelfmark service.
        See <https://github.com/calibrain/shelfmark/blob/main/docs/environment-variables.md>
        for available options.
      '';
    };
  };

  config = lib.mkIf cfg.enable {

    systemd.services.shelfmark = {
      description = "Shelfmark - book and audiobook search and download interface";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      inherit (cfg) environment;
      serviceConfig = {
        DynamicUser = true;
        ExecStart = "${lib.getExe cfg.package} -b ${cfg.environment.FLASK_HOST}:${cfg.environment.FLASK_PORT}";
        StateDirectory = "shelfmark";

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

        CapabilityBoundingSet = [ "" ];
        NoNewPrivileges = true;

        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectClock = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
          "~@resources"
        ];

        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];

        PrivateUsers = true;

        LockPersonality = true;
        ProtectHostname = true;
        RestrictRealtime = true;
        RestrictNamespaces = true;
        ProtectProc = "invisible";
        ProcSubset = "pid";
        DeviceAllow = [ "" ];
      };
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ (lib.toInt cfg.environment.FLASK_PORT) ];
    };
  };

  meta = {
    maintainers = with lib.maintainers; [ jamiemagee ];
  };
}
