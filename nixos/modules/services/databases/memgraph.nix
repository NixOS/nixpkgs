{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.memgraph;

in
{
  options.services.memgraph = {
    enable = lib.mkEnableOption "High-performance open-source in-memory graph database";
    package = lib.mkPackageOption pkgs "memgraph" { };

    settings = lib.mkOption {
      description = ''
        See <https://memgraph.com/docs/database-management/configuration#list-of-configuration-flags>
      '';
      type = lib.types.submodule {
        freeformType = lib.types.attrsOf (
          lib.types.oneOf [
            lib.types.str
            lib.types.int
            lib.types.path
            lib.types.bool
          ]
        );
        options = {
          bolt-address = lib.mkOption {
            description = "IP address on which the Bolt server should listen";
            type = lib.types.str;
            default = "0.0.0.0";
          };
          bolt-port = lib.mkOption {
            description = "Port on which the Bolt server should listen";
            type = lib.types.port;
            default = 7687;
          };

          metrics-address = lib.mkOption {
            description = "Host for HTTP server for exposing metrics";
            type = lib.types.str;
            default = "0.0.0.0";
          };
          metrics-port = lib.mkOption {
            description = "Port for HTTP server for exposing metrics";
            type = lib.types.port;
            default = 9091;
          };

          monitoring-address = lib.mkOption {
            description = "IP address where the Memgraph's monitoring WebSocket server should listen";
            type = lib.types.str;
            default = "0.0.0.0";
          };
          monitoring-port = lib.mkOption {
            description = "Port on which the Memgraph's monitoring WebSocket server should listen";
            type = lib.types.port;
            default = 7444;
          };

          data-directory = lib.mkOption {
            description = "Path to directory in which to save all permanent data";
            type = lib.types.path;
            default = "/var/lib/memgraph";
            readOnly = true;
          };
        };
      };
      default = { };
      example = lib.literalExpression ''
        {
          telemetry-enabled = false;
          init-file = ./create_users.cypherl;
        }
      '';
    };

    environmentFile = lib.mkOption {
      description = ''
        Path to environment file containing secrets like MEMGRAPH_USER or MEMGRAPH_PASSWORD.
        {option}`services.memgraph.settings` take precedence over these

        See <https://memgraph.com/docs/database-management/configuration#environment-variables>
      '';
      type = lib.types.nullOr lib.types.path;
    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [
      cfg.settings.bolt-port
      cfg.settings.metrics-port
      cfg.settings.monitoring-port
    ];
    environment.systemPackages = [ cfg.package ];
    systemd.services.memgraph = {
      description = "Memgraph: High performance, in-memory, transactional graph database";
      documentation = [ "https://memgraph.com/docs" ];

      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];

      serviceConfig = {
        Type = "simple";
        ExecStart = "${lib.getExe cfg.package} ${
          lib.escapeShellArgs (
            builtins.map (
              { name, value }:
              "--${name}=${if builtins.isBool value then lib.boolToString value else toString value}"
            ) (lib.attrsToList cfg.settings)
          )
        }";
        EnvironmentFile = lib.mkIf (cfg.environmentFile != null) cfg.environmentFile;
        DynamicUser = true;
        StateDirectory = "memgraph";
        WorkingDirectory = "/var/lib/memgraph";
        StateDirectoryMode = "1700";

        CapabilityBoundingSet = [ "" ];
        DeviceAllow = [ "" ];
        KeyringMode = "private";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateMounts = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProcSubset = "all"; # Required to check on vm.max_map_count
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        ReadWritePaths = [ "/var/lib/memgraph" ];
        RemoveIPC = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
          "~@resources"
        ];
        SystemCallErrorNumber = "EPERM";
      };
    };

    services.logrotate.settings.memgraph = lib.mkIf (cfg.settings.audit-enabled or false) {
      files = "/var/lib/memgraph/audit/audit.log";
      frequency = "daily";
      rotate = 365;
      postrotate = "${lib.getExe pkgs.killall} -s SIGUSR2 memgraph";
    };
  };

  meta.maintainers = with lib.maintainers; [ kip93 ];
}
