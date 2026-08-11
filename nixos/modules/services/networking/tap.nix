{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.tap;
in
{
  options.services.tap = {
    enable = lib.mkEnableOption "Tap, ATProtocol firehose sync utility";

    package = lib.mkPackageOption pkgs "tap" { };

    environmentFiles = lib.mkOption {
      type = lib.types.listOf lib.types.path;
      default = [ ];
      description = ''
        Files to load environment variables from. Use for secrets such as
        {env}`TAP_ADMIN_PASSWORD` that should not be readable in the Nix store.
      '';
    };

    settings = lib.mkOption {
      default = { };
      description = ''
        Configuration for Tap as environment variables. See the
        [README](https://github.com/bluesky-social/indigo/blob/main/cmd/tap/README.md)
        for all available options.

        Secrets such as {option}`settings.TAP_ADMIN_PASSWORD` should be set via
        {option}`environmentFiles` rather than here, as values set here will
        be readable in the Nix store.
      '';
      type = lib.types.submodule {
        freeformType = lib.types.attrsOf (
          lib.types.nullOr (
            lib.types.oneOf [
              lib.types.bool
              lib.types.int
              lib.types.float
              lib.types.str
            ]
          )
        );

        options = {
          TAP_BIND = lib.mkOption {
            type = lib.types.str;
            default = "127.0.0.1:2480";
            description = "Address and port the HTTP server will listen on.";
          };

          TAP_DATABASE_URL = lib.mkOption {
            type = lib.types.str;
            default = "sqlite:///var/lib/tap/tap.db";
            description = ''
              Database connection string. Accepts SQLite (`sqlite://path`) or
              PostgreSQL (`postgres://...`) connection strings.
            '';
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.tap = {
      description = "Tap - ATProtocol firehose sync utility";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        User = "tap";
        DynamicUser = true;

        ExecStart = "${lib.getExe cfg.package} run";
        Environment = lib.mapAttrsToList (
          k: v: "${k}=${if lib.isBool v then lib.boolToString v else toString v}"
        ) (lib.filterAttrs (_: v: v != null) cfg.settings);
        EnvironmentFile = cfg.environmentFiles;

        Restart = "on-failure";
        RestartSec = 5;
        StateDirectory = "tap";
        StateDirectoryMode = "0750";

        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProcSubset = "pid";
        ProtectSystem = "strict";

        PrivateDevices = true;
        PrivateTmp = true;
        PrivateUsers = true;

        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];

        LockPersonality = true;
        NoNewPrivileges = true;
        AmbientCapabilities = "";
        CapabilityBoundingSet = "";
        RemoveIPC = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
        ];
        UMask = "0077";
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ blooym ];
}
