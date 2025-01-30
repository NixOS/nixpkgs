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
    ;

  inherit (lib.types)
    listOf
    enum
    port
    str
    ;

  inherit (utils) escapeSystemdExecArgs;

  cfg = config.services.netbird.server.signal;
in

{
  options.services.netbird.server.signal = {
    enable = mkEnableOption "Netbird's Signal Service";

    package = mkPackageOption pkgs "netbird" { };

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
    ];

    systemd.services.netbird-signal = {
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

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
          ++ cfg.extraOptions
        );

        Restart = "always";
        RuntimeDirectory = "netbird-mgmt";
        StateDirectory = "netbird-mgmt";
        WorkingDirectory = "/var/lib/netbird-mgmt";

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
        ProtectSystem = true;
        RemoveIPC = true;
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
      };

      stopIfChanged = false;
    };

    services.nginx = mkIf cfg.enableNginx {
      enable = true;

      virtualHosts.${cfg.domain} = {
        locations."/signalexchange.SignalExchange/".extraConfig = ''
          # This is necessary so that grpc connections do not get closed early
          # see https://stackoverflow.com/a/67805465
          client_body_timeout 1d;

          grpc_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

          grpc_pass grpc://localhost:${builtins.toString cfg.port};
          grpc_read_timeout 1d;
          grpc_send_timeout 1d;
          grpc_socket_keepalive on;
        '';
      };
    };
  };
}
