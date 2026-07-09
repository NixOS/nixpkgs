{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.loreserver;

  tomlFormat = pkgs.formats.toml { };

  stateDir = "/var/lib/${cfg.stateDirectoryName}";
  certDir = "${stateDir}/certs";
  storeDir = "${stateDir}/store";

  userCert = (cfg.settings.server.quic.certificate or null) != null;

  managedDefaults = {
    immutable_store.local.path = storeDir;
    mutable_store.local.path = storeDir;
  }
  // lib.optionalAttrs (cfg.generateSelfSignedCert && !userCert) {
    server.quic.certificate = {
      cert_file = "${certDir}/cert.pem";
      pkey_file = "${certDir}/key.pem";
    };
  };

  mergedSettings = lib.recursiveUpdate managedDefaults cfg.settings;

  configDir = pkgs.runCommand "loreserver-config" { } ''
    mkdir -p "$out"
    cp ${tomlFormat.generate "local.toml" mergedSettings} "$out/local.toml"
  '';

  quicPort = mergedSettings.server.quic.port or 41337;
  grpcPort = mergedSettings.server.grpc.port or 41337;
  httpPort = mergedSettings.server.http.port or 41339;

  quicInternalEnabled = mergedSettings.server.quic_internal.enabled or false;
  quicInternalPort = mergedSettings.server.quic_internal.port or 41340;
  replicationEnabled = mergedSettings.server.replication.enabled or false;
  replicationPort = mergedSettings.server.replication.port or 41340;
in
{
  options.services.loreserver = {
    enable = lib.mkEnableOption "the Lore version control server";

    package = lib.mkPackageOption pkgs "lore" { };

    environment = lib.mkOption {
      type = lib.types.str;
      default = "local";
      description = ''
        Environment name passed as `--env`. Selects which `<environment>.toml`
        overlay the server layers over its built-in defaults. The module always
        writes its configuration to `local.toml`, which is applied last
        regardless of this value.
      '';
    };

    settings = lib.mkOption {
      type = tomlFormat.type;
      default = { };
      example = lib.literalExpression ''
        {
          server.http.port = 41339;
          server.quic.idle_timeout = 60000;
          telemetry.logger.format = "text";
        }
      '';
      description = ''
        Free-form configuration rendered to the server's `local.toml`. See the
        [Lore Server configuration reference](https://epicgames.github.io/lore/reference/lore-server-config/).
      '';
    };

    generateSelfSignedCert = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Generate and maintain a stable self-signed certificate for the public
        QUIC endpoint, if a certificate is not supplied under settings. This
        will be stored in the state directory.
      '';
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "loreserver";
      description = "User account under which loreserver runs.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "loreserver";
      description = "Group under which loreserver runs.";
    };

    stateDirectoryName = lib.mkOption {
      type = lib.types.str;
      default = "loreserver";
      description = ''
        Name of the systemd `StateDirectory` (under `/var/lib`) that holds the
        stores and the module-managed certificate.
      '';
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Open the firewall for the server's listening ports: TCP for gRPC and
        HTTP, UDP for QUIC.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.user == "loreserver" || config.users.users ? ${cfg.user};
        message = ''
          services.loreserver.user is set to "${cfg.user}", which does not
          exist. Define it in users.users (or unset this option).
        '';
      }
      {
        assertion = cfg.group == "loreserver" || config.users.groups ? ${cfg.group};
        message = ''
          services.loreserver.group is set to "${cfg.group}", which does not
          exist. Define it in users.groups (or unset this option).
        '';
      }
    ];

    users.users = lib.mkIf (cfg.user == "loreserver") {
      loreserver = {
        isSystemUser = true;
        group = cfg.group;
        home = stateDir;
        description = "Lore version control server";
      };
    };

    users.groups = lib.mkIf (cfg.group == "loreserver") {
      loreserver = { };
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = lib.unique (
        [
          grpcPort
          httpPort
        ]
        ++ lib.optional replicationEnabled replicationPort
      );
      allowedUDPPorts = lib.unique ([ quicPort ] ++ lib.optional quicInternalEnabled quicInternalPort);
    };

    systemd.services.loreserver = {
      description = "Lore version control server";
      documentation = [ "https://epicgames.github.io/lore/" ];
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      # openssl is needed only for the optional self-signed certificate.
      path = lib.optional (cfg.generateSelfSignedCert && !userCert) pkgs.openssl;

      preStart = ''
        # Ensure the store directory exists.
        mkdir -p "${storeDir}"
      ''
      + lib.optionalString (cfg.generateSelfSignedCert && !userCert) ''
        if [ ! -s "${certDir}/cert.pem" ] || [ ! -s "${certDir}/key.pem" ]; then
          mkdir -p "${certDir}"
          openssl req -x509 -newkey rsa:2048 -nodes \
            -keyout "${certDir}/key.pem" \
            -out "${certDir}/cert.pem" \
            -days 3650 -subj "/CN=localhost" \
            -addext "subjectAltName=IP:127.0.0.1,IP:::1,DNS:localhost"
          chmod 600 "${certDir}/key.pem"
        fi
      '';

      serviceConfig = {
        ExecStart = lib.escapeShellArgs [
          (lib.getExe' cfg.package "loreserver")
          "--config"
          "${configDir}"
          "--env"
          cfg.environment
        ];

        User = cfg.user;
        Group = cfg.group;

        StateDirectory = cfg.stateDirectoryName;
        StateDirectoryMode = "0750";
        WorkingDirectory = stateDir;

        Restart = "on-failure";
        RestartSec = 5;
        TimeoutStopSec = 45;

        DynamicUser = false;
        NoNewPrivileges = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = true;
        ProtectClock = true;
        ProtectHostname = true;
        ProtectProc = "invisible";
        ProcSubset = "pid";
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        RemoveIPC = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged @resources"
        ];
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        CapabilityBoundingSet = [ "" ];
        AmbientCapabilities = [ "" ];
        UMask = "0077";
      };
    };
  };

  meta.maintainers = [ lib.maintainers.jchw ];
}
