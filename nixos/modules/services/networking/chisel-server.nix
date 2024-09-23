{ config, lib, pkgs, ... }:
let
  cfg = config.services.chisel-server;

in {
  options = {
    services.chisel-server = {
      enable = lib.mkEnableOption "Chisel Tunnel Server";
      host = lib.mkOption {
        description = "Address to listen on, falls back to 0.0.0.0";
        type = with lib.types; nullOr str;
        default = null;
        example = "[::1]";
      };
      port = lib.mkOption {
        description = "Port to listen on, falls back to 8080";
        type = with lib.types; nullOr port;
        default = null;
      };
      authfile = lib.mkOption {
        description = "Path to auth.json file";
        type = with lib.types; nullOr path;
        default = null;
      };
      keepalive  = lib.mkOption {
        description = "Keepalive interval, falls back to 25s";
        type = with lib.types; nullOr str;
        default = null;
        example = "5s";
      };
      backend = lib.mkOption {
        description = "HTTP server to proxy normal requests to";
        type = with lib.types; nullOr str;
        default = null;
        example = "http://127.0.0.1:8888";
      };
      socks5 = lib.mkOption {
        description = "Allow clients access to internal SOCKS5 proxy";
        type = lib.types.bool;
        default = false;
      };
      reverse = lib.mkOption {
        description = "Allow clients reverse port forwarding";
        type = lib.types.bool;
        default = false;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.chisel-server = {
      description = "Chisel Tunnel Server";
      wantedBy = [ "network-online.target" ];

      serviceConfig = {
        ExecStart = "${pkgs.chisel}/bin/chisel server " + lib.concatStringsSep " " (
          lib.optional (cfg.host != null) "--host ${cfg.host}"
          ++ lib.optional (cfg.port != null) "--port ${builtins.toString cfg.port}"
          ++ lib.optional (cfg.authfile != null) "--authfile ${cfg.authfile}"
          ++ lib.optional (cfg.keepalive != null) "--keepalive ${cfg.keepalive}"
          ++ lib.optional (cfg.backend != null) "--backend ${cfg.backend}"
          ++ lib.optional cfg.socks5 "--socks5"
          ++ lib.optional cfg.reverse "--reverse"
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
        RestrictAddressFamilies = [ "AF_INET" "AF_INET6" "AF_UNIX" ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = "~@clock @cpu-emulation @debug @mount @obsolete @reboot @swap @privileged @resources";
        UMask = "0077";
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ clerie ];
}
