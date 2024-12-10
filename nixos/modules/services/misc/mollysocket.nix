{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    getExe
    mkIf
    mkOption
    mkEnableOption
    optionals
    types
    ;

  cfg = config.services.mollysocket;
  configuration = format.generate "mollysocket.conf" cfg.settings;
  format = pkgs.formats.toml { };
  package = pkgs.writeShellScriptBin "mollysocket" ''
    MOLLY_CONF=${configuration} exec ${getExe pkgs.mollysocket} "$@"
  '';
in
{
  options.services.mollysocket = {
    enable = mkEnableOption ''
      [MollySocket](https://github.com/mollyim/mollysocket) for getting Signal
      notifications via UnifiedPush
    '';

    settings = mkOption {
      default = { };
      description = ''
        Configuration for MollySocket. Available options are listed
        [here](https://github.com/mollyim/mollysocket#configuration).
      '';
      type = types.submodule {
        freeformType = format.type;
        options = {
          host = mkOption {
            default = "127.0.0.1";
            description = "Listening address of the web server";
            type = types.str;
          };

          port = mkOption {
            default = 8020;
            description = "Listening port of the web server";
            type = types.port;
          };

          allowed_endpoints = mkOption {
            default = [ "*" ];
            description = "List of UnifiedPush servers";
            example = [ "https://ntfy.sh" ];
            type = with types; listOf str;
          };

          allowed_uuids = mkOption {
            default = [ "*" ];
            description = "UUIDs of Signal accounts that may use this server";
            example = [ "abcdef-12345-tuxyz-67890" ];
            type = with types; listOf str;
          };
        };
      };
    };

    environmentFile = mkOption {
      default = null;
      description = ''
        Environment file (see {manpage}`systemd.exec(5)` "EnvironmentFile="
        section for the syntax) passed to the service. This option can be
        used to safely include secrets in the configuration.
      '';
      example = "/run/secrets/mollysocket";
      type = with types; nullOr path;
    };

    logLevel = mkOption {
      default = "info";
      description = "Set the {env}`RUST_LOG` environment variable";
      example = "debug";
      type = types.str;
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      package
    ];

    # see https://github.com/mollyim/mollysocket/blob/main/mollysocket.service
    systemd.services.mollysocket = {
      description = "MollySocket";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      environment.RUST_LOG = cfg.logLevel;
      serviceConfig =
        let
          capabilities = [ "" ] ++ optionals (cfg.settings.port < 1024) [ "CAP_NET_BIND_SERVICE" ];
        in
        {
          EnvironmentFile = cfg.environmentFile;
          ExecStart = "${getExe package} server";
          KillSignal = "SIGINT";
          Restart = "on-failure";
          StateDirectory = "mollysocket";
          TimeoutStopSec = 5;
          WorkingDirectory = "/var/lib/mollysocket";

          # hardening
          AmbientCapabilities = capabilities;
          CapabilityBoundingSet = capabilities;
          DevicePolicy = "closed";
          DynamicUser = true;
          LockPersonality = true;
          MemoryDenyWriteExecute = true;
          NoNewPrivileges = true;
          PrivateDevices = true;
          PrivateTmp = true;
          PrivateUsers = true;
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
          ];
          RestrictNamespaces = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          SystemCallArchitectures = "native";
          SystemCallFilter = [
            "@system-service"
            "~@resources"
            "~@privileged"
          ];
          UMask = "0077";
        };
    };
  };

  meta.maintainers = with lib.maintainers; [ dotlambda ];
}
