{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.iggy;
  format = pkgs.formats.toml { };
  configFile = format.generate "iggy-server.toml" cfg.settings;
in
{
  meta.maintainers = with lib.maintainers; [ jpds ];

  options.services.iggy = {
    enable = lib.mkEnableOption "Apache Iggy message streaming server";

    package = lib.mkPackageOption pkgs "iggy" { };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to open firewall ports for iggy's enabled transports.
        Opens the ports derived from {option}`settings.http.address`,
        {option}`settings.tcp.address`, and {option}`settings.quic.address`.
      '';
    };

    secretsFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = "/run/secrets/iggy.env";
      description = ''
        Path to a file containing secret environment variables for iggy-server,
        as described in {manpage}`systemd.exec(5)`. Use this to supply sensitive
        values such as `IGGY_ROOT_PASSWORD`, `IGGY_HTTP_JWT_ENCODING_SECRET`,
        and `IGGY_HTTP_JWT_DECODING_SECRET` without storing them in the Nix store.

        Any iggy configuration key can be set via an environment variable with
        the `IGGY_` prefix (e.g. `IGGY_TCP_ADDRESS=0.0.0.0:8090`).
      '';
    };

    settings = lib.mkOption {
      default = { };
      description = ''
        iggy-server configuration. Refer to the
        [iggy documentation](https://iggy.apache.org/docs/server/configuration)
        for available options. Sensitive values should be passed via
        {option}`secretsFile` rather than set here.
      '';
      type = lib.types.submodule {
        freeformType = format.type;
        options = {
          system.path = lib.mkOption {
            type = lib.types.str;
            default = "/var/lib/iggy";
            readOnly = true;
            description = ''
              Path to the root directory where iggy stores its data.
              Fixed to the systemd `StateDirectory` and cannot be changed.
            '';
          };
          http.enabled = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Whether to enable the HTTP API transport.";
          };
          http.address = lib.mkOption {
            type = lib.types.str;
            default = "127.0.0.1:3000";
            description = "Address and port for the HTTP API server.";
          };
          tcp.enabled = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Whether to enable the TCP transport.";
          };
          tcp.address = lib.mkOption {
            type = lib.types.str;
            default = "127.0.0.1:8090";
            description = "Address and port for the TCP server.";
          };
          quic.enabled = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Whether to enable the QUIC transport.";
          };
          quic.address = lib.mkOption {
            type = lib.types.str;
            default = "127.0.0.1:8080";
            description = "Address and port for the QUIC server.";
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.iggy-server = {
      description = "Apache Iggy message streaming server";
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      environment.IGGY_CONFIG_PATH = configFile;
      serviceConfig = {
        DynamicUser = true;
        ExecStart = lib.getExe' cfg.package "iggy-server";
        StateDirectory = "iggy";
        StateDirectoryMode = "0750";
        Restart = "on-failure";

        CapabilityBoundingSet = "";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateTmp = true;
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
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
        ];
        UMask = "0077";
      }
      // lib.optionalAttrs (cfg.secretsFile != null) {
        EnvironmentFile = cfg.secretsFile;
      };
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts =
        lib.optional cfg.settings.http.enabled (
          lib.toInt (lib.last (lib.splitString ":" cfg.settings.http.address))
        )
        ++ lib.optional cfg.settings.tcp.enabled (
          lib.toInt (lib.last (lib.splitString ":" cfg.settings.tcp.address))
        );
      allowedUDPPorts = lib.optional cfg.settings.quic.enabled (
        lib.toInt (lib.last (lib.splitString ":" cfg.settings.quic.address))
      );
    };
  };
}
