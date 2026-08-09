{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.traggo;
  port = lib.toInt (toString (cfg.environment.TRAGGO_PORT or 3030));
in
{
  meta.doc = ./traggo.md;
  meta.maintainers = with lib.maintainers; [ elnudev ];

  options.services.traggo = {
    enable = lib.mkEnableOption "traggo, a self-hosted, tag-based time tracking server";

    package = lib.mkPackageOption pkgs "traggo" { };

    environment = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.oneOf [
          lib.types.str
          lib.types.int
        ]
      );
      default = { };
      example = {
        TRAGGO_PORT = 3030;
        TRAGGO_LOG_LEVEL = "info";
        TRAGGO_DEFAULT_USER_NAME = "admin";
        TRAGGO_DATABASE_DIALECT = "sqlite3";
        TRAGGO_DATABASE_CONNECTION = "data/traggo.db";
      };
      description = ''
        Config environment variables for traggo, using the names from
        <https://traggo.net/config/>. The example lists the upstream defaults.
      '';
    };

    environmentFiles = lib.mkOption {
      type = lib.types.listOf lib.types.path;
      default = [ ];
      example = [ "/run/secrets/traggo" ];
      description = ''
        Files containing additional config environment variables for
        traggo. Secrets such as `TRAGGO_DEFAULT_USER_PASS` should be set
        here instead of in {option}`services.traggo.environment`.
      '';
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to open the traggo port in the firewall. The port is read
        from `TRAGGO_PORT` in {option}`services.traggo.environment`.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ port ];

    systemd.services.traggo = {
      description = "traggo server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      environment = lib.mapAttrs (_: toString) cfg.environment;

      serviceConfig = {
        ExecStart = lib.getExe cfg.package;
        Restart = "on-failure";
        RestartSec = 5;

        DynamicUser = true;
        StateDirectory = "traggo";
        # TRAGGO_DATABASE_CONNECTION defaults to the relative path `data/traggo.db`.
        WorkingDirectory = "%S/traggo";

        EnvironmentFile = cfg.environmentFiles;

        AmbientCapabilities = lib.optional (port < 1024) "CAP_NET_BIND_SERVICE";
        # `[ "" ]` clears the bounding set; `[ ]` would leave it unrestricted.
        CapabilityBoundingSet = if port < 1024 then [ "CAP_NET_BIND_SERVICE" ] else [ "" ];
        DevicePolicy = "closed";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateTmp = true;
        # AmbientCapabilities is ineffective under PrivateUsers.
        PrivateUsers = port >= 1024;
        ProcSubset = "pid";
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        RemoveIPC = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
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
        UMask = "0077";
      };
    };
  };
}
