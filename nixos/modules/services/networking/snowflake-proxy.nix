{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.snowflake-proxy;
in
{
  options = {
    services.snowflake-proxy = {
      enable = mkEnableOption "snowflake-proxy, a system to defeat internet censorship";

      broker = mkOption {
        description = "Broker URL (default \"https://snowflake-broker.torproject.net/\")";
        type = with types; nullOr str;
        default = null;
      };

      capacity = mkOption {
        description = "Limits the amount of maximum concurrent clients allowed.";
        type = with types; nullOr int;
        default = null;
      };

      relay = mkOption {
        description = "websocket relay URL (default \"wss://snowflake.bamsoftware.com/\")";
        type = with types; nullOr str;
        default = null;
      };

      stun = mkOption {
        description = "STUN broker URL (default \"stun:stun.stunprotocol.org:3478\")";
        type = with types; nullOr str;
        default = null;
      };

      extraFlags = mkOption {
        description = "Extra flags to pass to snowflake-proxy";
        type = with types; listOf str;
        default = [ ];
        example = [ "-metrics" ];
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.snowflake-proxy = {
      wantedBy = [ "network-online.target" ];
      serviceConfig = {
        ExecStart =
          "${pkgs.snowflake}/bin/proxy "
          + concatStringsSep " " (
            optional (cfg.broker != null) "-broker ${cfg.broker}"
            ++ optional (cfg.capacity != null) "-capacity ${builtins.toString cfg.capacity}"
            ++ optional (cfg.relay != null) "-relay ${cfg.relay}"
            ++ optional (cfg.stun != null) "-stun ${cfg.stun}"
            ++ cfg.extraFlags
          );

        # Security Hardening
        # Refer to systemd.exec(5) for option descriptions.
        CapabilityBoundingSet = "";

        # implies RemoveIPC=, PrivateTmp=, NoNewPrivileges=, RestrictSUIDSGID=,
        # ProtectSystem=strict, ProtectHome=read-only
        DynamicUser = true;
        LockPersonality = true;
        PrivateDevices = true;
        PrivateUsers = true;
        ProcSubset = "pid";
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectProc = "invisible";
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
        ];
        UMask = "0077";
      };
    };
  };

  meta.maintainers = with maintainers; [ yayayayaka ];
}
