{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.services.beszel.hub;
in
{
  meta.maintainers = with lib.maintainers; [
    BonusPlay
    arunoruto
  ];

  options.services.beszel.hub = {
    enable = lib.mkEnableOption "beszel hub";

    package = lib.mkPackageOption pkgs "beszel" { };

    host = lib.mkOption {
      default = "127.0.0.1";
      type = lib.types.str;
      example = "0.0.0.0";
      description = "Host or address this beszel hub listens on.";
    };
    port = lib.mkOption {
      default = 8090;
      type = lib.types.port;
      example = 3002;
      description = "Port for this beszel hub to listen on.";
    };

    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/beszel-hub";
      description = "Data directory of beszel-hub.";
    };

    environment = lib.mkOption {
      type = with lib.types; attrsOf str;
      default = { };
      example = {
        DISABLE_PASSWORD_AUTH = "true";
      };
      description = ''
        Environment variables passed to the systemd service.
        See <https://www.beszel.dev/guide/environment-variables#hub> for available options.
      '';
    };
    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        Environment file to be passed to the systemd service.
        Useful for passing secrets to the service to prevent them from being
        world-readable in the Nix store. See {manpage}`systemd.exec(5)`.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.beszel-hub = {
      description = "Beszel Server Monitoring Web App";

      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      environment = cfg.environment;

      serviceConfig = {
        ExecStartPre = [
          "${cfg.package}/bin/beszel-hub migrate up"
          "${cfg.package}/bin/beszel-hub history-sync"
        ];
        ExecStart = ''
          ${cfg.package}/bin/beszel-hub serve --http='${cfg.host}:${toString cfg.port}'
        '';

        EnvironmentFile = lib.mkIf (cfg.environmentFile != null) cfg.environmentFile;
        WorkingDirectory = cfg.dataDir;
        StateDirectory = baseNameOf cfg.dataDir;
        RuntimeDirectory = baseNameOf cfg.dataDir;
        ReadWritePaths = cfg.dataDir;

        DynamicUser = true;
        User = "beszel-hub";
        LockPersonality = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProtectClock = true;
        ProtectControlGroups = "strict";
        ProtectHome = "read-only";
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectSystem = "strict";
        DevicePolicy = "closed";
        Restart = "on-failure";
        RestartSec = "30s";
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        RestrictNamespaces = true;
        SystemCallArchitectures = "native";
        SystemCallErrorNumber = "EPERM";
        SystemCallFilter = [ "@system-service" ];
        UMask = 27;
      };
    };
  };
}
