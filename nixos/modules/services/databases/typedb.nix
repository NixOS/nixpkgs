{
  config,
  lib,
  pkgs,
  utils,
  ...
}:
let
  cfg = config.services.typedb;
in
{
  options = {
    services.typedb = {
      enable = lib.mkEnableOption "TypeDB, a strongly-typed database with a rich and logical type system";

      package = lib.mkPackageOption pkgs "typedb" { };

      listenHost = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1";
        example = "127.0.0.1";
        description = ''
          Host the TypeDB driver protocol listens on. Loopback by default;
          set a LAN address together with {option}`openFirewall` only on
          trusted networks (TypeDB has no read-only role; any credential
          holder can write).
        '';
      };

      listenPort = lib.mkOption {
        type = lib.types.port;
        default = 1729;
        example = 1729;
        description = ''
          Port the TypeDB driver protocol listens on. Opened in the firewall
          when {option}`openFirewall` is enabled.
        '';
      };

      httpListenHost = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1";
        example = "127.0.0.1";
        description = ''
          Host the TypeDB HTTP endpoint listens on.
        '';
      };

      httpListenPort = lib.mkOption {
        type = lib.types.port;
        default = 8000;
        example = 8000;
        description = ''
          Port the TypeDB HTTP endpoint listens on. Opened in the firewall
          when {option}`openFirewall` is enabled.
        '';
      };

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Open the firewall for the configured driver and HTTP ports. Off by
          default; the service binds loopback unless the host options above
          say otherwise.
        '';
      };

      diagnosticsReporting = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Send metrics and error reports to the vendor. Off by default;
          enable explicitly if you want to share telemetry with TypeDB.
        '';
      };

      diagnosticsMonitoring = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Expose the diagnostics monitoring HTTP endpoint (default port 4104).
          Off by default.
        '';
      };

      extraFlags = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        example = [
          "--server.advertise-address"
          "db.internal:1729"
        ];
        description = ''
          Additional command line flags for typedb-server. Every server
          config.yml key is also a --dotted.path flag.
        '';
      };
    };
  };

  config =
    let
      listenAddress = "${cfg.listenHost}:${toString cfg.listenPort}";
      httpListenAddress = "${cfg.httpListenHost}:${toString cfg.httpListenPort}";
      # The server mandates a config file (it resolves a bare `config.yml`
      # against the executable directory, never CWD defaults), so the
      # module renders one. This mirrors upstream `server/config.yml`
      # section-complete (the loader validates presence); only the values
      # below are managed, the rest stay at upstream defaults. CLI flags
      # remain available via extraFlags and override file values.
      configFile = pkgs.writeText "typedb-config.yml" ''
        server:
          listen-address: "${listenAddress}"
          advertise-address:
          http:
            enabled: true
            listen-address: "${httpListenAddress}"
            advertise-address:
          admin:
            enabled: false
            socket-path:

          authentication:
            token-expiration-seconds: 5000

          encryption:
            enabled: false
            certificate:
            certificate-key:
            ca-certificate:

        storage:
          data-directory: "/var/lib/typedb/data"
          rocksdb:
            cache-size: 1gb
            write-buffers-limit: 512mb
          mvcc:
            cleanup:
              enabled: false
              strategy: eager

        logging:
          directory: "/var/log/typedb"

        diagnostics:
          monitoring:
            enabled: ${lib.boolToString cfg.diagnosticsMonitoring}
            port: 4104
          reporting:
            metrics: ${lib.boolToString cfg.diagnosticsReporting}
            errors: ${lib.boolToString cfg.diagnosticsReporting}
      '';
    in
    lib.mkIf cfg.enable {
      environment.systemPackages = [ cfg.package ];

      networking.firewall = lib.mkIf cfg.openFirewall {
        allowedTCPPorts = lib.unique [
          cfg.listenPort
          cfg.httpListenPort
        ];
      };

      systemd.services.typedb = {
        description = "TypeDB server";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];

        serviceConfig = {
          ExecStart = utils.escapeSystemdExecArgs (
            [
              "${cfg.package}/bin/typedb-server"
              "--config=${configFile}"
            ]
            ++ cfg.extraFlags
          );
          DynamicUser = true;
          StateDirectory = "typedb";
          LogsDirectory = "typedb";
          Restart = "on-failure";
          CapabilityBoundingSet = "";
          NoNewPrivileges = true;
          PrivateTmp = true;
          ProtectHome = true;
          ProtectClock = true;
          ProtectKernelLogs = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          ProtectControlGroups = true;
          ProtectHostname = true;
          RestrictAddressFamilies = [
            "AF_UNIX"
            "AF_INET"
            "AF_INET6"
          ];
        };
      };
    };

  meta.maintainers = with lib.maintainers; [ caniko ];
}
