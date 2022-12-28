{ config, lib, pkgs, ... }:

let
  inherit (lib)
    maintainers types mkEnableOption mkOption mkIf
    literalExpression escapeShellArg escapeShellArgs;
  cfg = config.services.mtr-exporter;
in {
  options = {
    services = {
      mtr-exporter = {
        enable = mkEnableOption (lib.mdDoc "a Prometheus exporter for MTR");

        target = mkOption {
          type = types.str;
          example = "example.org";
          description = lib.mdDoc "Target to check using MTR.";
        };

        interval = mkOption {
          type = types.int;
          default = 60;
          description = lib.mdDoc "Interval between MTR checks in seconds.";
        };

        port = mkOption {
          type = types.port;
          default = 8080;
          description = lib.mdDoc "Listen port for MTR exporter.";
        };

        address = mkOption {
          type = types.str;
          default = "127.0.0.1";
          description = lib.mdDoc "Listen address for MTR exporter.";
        };

        mtrFlags = mkOption {
          type = with types; listOf str;
          default = [];
          example = ["-G1"];
          description = lib.mdDoc "Additional flags to pass to MTR.";
        };
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.mtr-exporter = {
      script = ''
        exec ${pkgs.mtr-exporter}/bin/mtr-exporter \
          -mtr ${pkgs.mtr}/bin/mtr \
          -schedule '@every ${toString cfg.interval}s' \
          -bind ${escapeShellArg cfg.address}:${toString cfg.port} \
          -- \
          ${escapeShellArgs (cfg.mtrFlags ++ [ cfg.target ])}
      '';
      wantedBy = [ "multi-user.target" ];
      requires = [ "network.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        Restart = "on-failure";
        # Hardening
        CapabilityBoundingSet = [ "" ];
        DynamicUser = true;
        LockPersonality = true;
        ProcSubset = "pid";
        PrivateDevices = true;
        PrivateUsers = true;
        PrivateTmp = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        RestrictNamespaces = true;
        RestrictRealtime = true;
      };
    };
  };

  meta.maintainers = with maintainers; [ jakubgs ];
}
