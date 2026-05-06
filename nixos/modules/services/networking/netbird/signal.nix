{
  config,
  lib,
  pkgs,
  utils,
  ...
}:

let
  inherit (lib)
    getExe'
    mkEnableOption
    mkIf
    mkPackageOption
    mkOption
    optionals
    ;

  inherit (lib.types)
    bool
    listOf
    enum
    nullOr
    path
    port
    str
    ;

  inherit (utils) escapeSystemdExecArgs;

  cfg = config.services.netbird.server.signal;
  stateDir = "/var/lib/netbird-signal";
in

{
  options.services.netbird.server.signal = {
    enable = mkEnableOption "Netbird's Signal Service";

    package = mkPackageOption pkgs "netbird-signal" { };

    enableNginx = mkEnableOption "Nginx reverse-proxy for the netbird signal service";

    domain = mkOption {
      type = str;
      description = "The domain name for the signal service.";
    };

    port = mkOption {
      type = port;
      default = 8012;
      description = "Internal port of the signal server.";
    };

    metricsPort = mkOption {
      type = port;
      default = 9091;
      description = "Internal port of the metrics server.";
    };

    tls = {
      enable = mkEnableOption "TLS for the signal server";

      letsencrypt = {
        domain = mkOption {
          type = nullOr str;
          default = null;
          description = ''
            Domain for automatic Let's Encrypt certificate.
            When set, the signal server will automatically obtain and renew certificates.
          '';
        };
      };

      certFile = mkOption {
        type = nullOr path;
        default = null;
        description = "Path to the TLS certificate file.";
      };

      certKey = mkOption {
        type = nullOr path;
        default = null;
        description = "Path to the TLS certificate key file.";
      };
    };

    openFirewall = mkOption {
      type = bool;
      default = false;
      description = ''
        Whether to open the signal server port in the firewall.
      '';
    };

    extraOptions = mkOption {
      type = listOf str;
      default = [ ];
      description = ''
        Additional options given to netbird-signal as commandline arguments.
      '';
    };

    logLevel = mkOption {
      type = enum [
        "ERROR"
        "WARN"
        "INFO"
        "DEBUG"
      ];
      default = "INFO";
      description = "Log level of the netbird signal service.";
    };
  };

  config = mkIf cfg.enable {

    assertions = [
      {
        assertion = cfg.port != cfg.metricsPort;
        message = "The primary listen port cannot be the same as the listen port for the metrics endpoint";
      }
      {
        assertion =
          cfg.tls.enable
          -> (cfg.tls.letsencrypt.domain != null || (cfg.tls.certFile != null && cfg.tls.certKey != null));
        message = "When TLS is enabled, either letsencrypt.domain or both certFile and certKey must be set";
      }
      {
        assertion = cfg.tls.certFile != null -> cfg.tls.certKey != null;
        message = "certKey must be set when certFile is set";
      }
      {
        assertion = cfg.tls.certKey != null -> cfg.tls.certFile != null;
        message = "certFile must be set when certKey is set";
      }
    ];

    systemd.services.netbird-signal = {
      description = "The signal server for Netbird, a wireguard VPN";
      documentation = [ "https://netbird.io/docs/" ];

      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      restartTriggers = [
        cfg.port
        cfg.logLevel
      ];

      serviceConfig = {
        ExecStart = escapeSystemdExecArgs (
          [
            (getExe' cfg.package "netbird-signal")
            "run"
            # Port to listen on
            "--port"
            cfg.port
            # Port the internal prometheus server listens on
            "--metrics-port"
            cfg.metricsPort
            # Log to stdout
            "--log-file"
            "console"
            # Log level
            "--log-level"
            cfg.logLevel
          ]
          # TLS options
          ++ optionals (cfg.tls.letsencrypt.domain != null) [
            "--letsencrypt-domain"
            cfg.tls.letsencrypt.domain
          ]
          ++ optionals (cfg.tls.certFile != null) [
            "--cert-file"
            cfg.tls.certFile
          ]
          ++ optionals (cfg.tls.certKey != null) [
            "--cert-key"
            cfg.tls.certKey
          ]
          ++ cfg.extraOptions
        );

        Restart = "always";
        RuntimeDirectory = "netbird-signal";
        RuntimeDirectoryMode = "0750";
        StateDirectory = "netbird-signal";
        StateDirectoryMode = "0750";
        WorkingDirectory = stateDir;

        # hardening
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateMounts = true;
        PrivateTmp = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectSystem = "strict";
        RemoveIPC = true;
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
      };

      stopIfChanged = false;
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };

    services.nginx = mkIf cfg.enableNginx {
      enable = true;

      virtualHosts.${cfg.domain} = {
        locations."/signalexchange.SignalExchange/".extraConfig = ''
          # This is necessary so that grpc connections do not get closed early
          # see https://stackoverflow.com/a/67805465
          client_body_timeout 1d;

          grpc_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

          grpc_pass grpc://localhost:${toString cfg.port};
          grpc_read_timeout 1d;
          grpc_send_timeout 1d;
          grpc_socket_keepalive on;
        '';
      };
    };
  };
}
