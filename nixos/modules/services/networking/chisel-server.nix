{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.chisel-server;

in
{
  options = {
    services.chisel-server = {
      enable = mkEnableOption "Chisel Tunnel Server";
      host = mkOption {
        description = "Address to listen on, falls back to 0.0.0.0";
        type = with types; nullOr str;
        default = null;
        example = "[::1]";
      };
      port = mkOption {
        description = "Port to listen on, falls back to 8080";
        type = with types; nullOr port;
        default = null;
      };
      authfile = mkOption {
        description = "Path to auth.json file";
        type = with types; nullOr path;
        default = null;
      };
      keepalive = mkOption {
        description = "Keepalive interval, falls back to 25s";
        type = with types; nullOr str;
        default = null;
        example = "5s";
      };
      backend = mkOption {
        description = "HTTP server to proxy normal requests to";
        type = with types; nullOr str;
        default = null;
        example = "http://127.0.0.1:8888";
      };
      socks5 = mkOption {
        description = "Allow clients access to internal SOCKS5 proxy";
        type = types.bool;
        default = false;
      };
      reverse = mkOption {
        description = "Allow clients reverse port forwarding";
        type = types.bool;
        default = false;
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.chisel-server = {
      description = "Chisel Tunnel Server";
      wantedBy = [ "network-online.target" ];

      serviceConfig = {
        ExecStart =
          "${pkgs.chisel}/bin/chisel server "
          + concatStringsSep " " (
            optional (cfg.host != null) "--host ${cfg.host}"
            ++ optional (cfg.port != null) "--port ${builtins.toString cfg.port}"
            ++ optional (cfg.authfile != null) "--authfile ${cfg.authfile}"
            ++ optional (cfg.keepalive != null) "--keepalive ${cfg.keepalive}"
            ++ optional (cfg.backend != null) "--backend ${cfg.backend}"
            ++ optional cfg.socks5 "--socks5"
            ++ optional cfg.reverse "--reverse"
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
        SystemCallFilter = "~@clock @cpu-emulation @debug @mount @obsolete @reboot @swap @privileged @resources";
        UMask = "0077";
      };
    };
  };

  meta.maintainers = with maintainers; [ clerie ];
}
