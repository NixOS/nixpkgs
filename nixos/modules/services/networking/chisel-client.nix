{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.chisel-client;
in {
  options.services.chisel-client = {
    enable = lib.mkEnableOption "Chisel tunnel client";

    server = lib.mkOption {
      type = lib.types.str;
      example = "https://chisel.example.com:443";
      description = "Chisel server URL.";
    };

    remotes = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      example = [
        "3000"
        "R:2222:localhost:22"
        "127.0.0.1:1080:socks"
      ];
      description = ''
        Chisel remote definitions.

        Examples:
          3000
          example.com:3000
          3000:google.com:80
          R:2222:localhost:22
          socks
          R:socks
          1.1.1.1:53/udp
      '';
    };

    fingerprint = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "abcDEF123...=";
      description = "Server public key fingerprint (strongly recommended). See official Documentation";
    };

    authfile = lib.mkOption {
      description = "Path to auth.json file";
      type = with lib.types; nullOr path;
      default = null;
    };

    keepalive = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "25s";
      description = "Keepalive interval (e.g. 5s, 2m, 0s).";
    };

    proxy = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "http://user:pass@proxy:8080";
      description = "HTTP CONNECT or SOCKS5 proxy URL.";
    };

    headers = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      example = ["Foo: Bar" "Hello: World"];
      description = "Custom HTTP headers.";
    };

    tlsSkipVerify = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Skip TLS certificate verification.";
    };

    extraArgs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Additional raw command-line arguments.";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.chisel-client = {
      description = "Chisel Tunnel Client";
      wantedBy = ["network-online.target"];
      after = ["network-online.target"];

      serviceConfig = {
        ExecStart =
          "${pkgs.chisel}/bin/chisel client "
          + lib.concatStringsSep " " (
            lib.optional cfg.tlsSkipVerify "--tls-skip-verify"
            ++ lib.optional (cfg.fingerprint != null) "--fingerprint ${cfg.fingerprint}"
            ++ lib.optional (cfg.authfile != null) "--authfile ${cfg.authfile}"
            ++ lib.optional (cfg.keepalive != null) "--keepalive ${cfg.keepalive}"
            ++ lib.optional (cfg.proxy != null) "--proxy ${cfg.proxy}"
            ++ lib.concatMap (h: ["--header ${h}"]) cfg.headers
            ++ cfg.extraArgs
            ++ [cfg.server]
            ++ cfg.remotes
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

  meta.maintainers = with lib.maintainers; [peritia];
}
