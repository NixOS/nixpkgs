{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    getExe'
    types
    ;

  cfg = config.services.netbird.relay;
  cmd = getExe' cfg.package "netbird-relay";
  args = lib.cli.toCommandLineShellGNU { } cfg.settings;

  listenPortMatch = builtins.match ".*:([0-9]+)$" cfg.settings.listen-address;
  listenPort = if listenPortMatch == null then null else lib.toInt (builtins.head listenPortMatch);

  # Checks
  authSecretSet = cfg.authSecretFile != null;
  needsPrivPort = listenPort != null && listenPort < 1024;
in
{
  options.services.netbird.relay = {
    enable = lib.mkEnableOption "Netbird's Relay Service";
    package = lib.mkPackageOption pkgs "netbird-relay" { };

    # as per RFC 0042:
    settings = lib.mkOption {
      type = types.submodule {
        freeformType =
          with lib.types;
          nullOr (oneOf [
            bool
            str
            # For --letsencrypt-domains strings
            (listOf (oneOf [ str ]))
          ]);
        options.listen-address = lib.mkOption {
          type = types.str;
          description = ''
            The host address and port separated by colon where the relay will listen
          '';
          default = ":33080";
        };
        options.exposed-address = lib.mkOption {
          type = types.str;
          description = ''
            Exposed address for peers. Address told to the peers to connect to
          '';
          example = "rels://relay.example.com:443";
        };
        options.enable-stun = lib.mkOption {
          type = types.bool;
          default = false;
          description = "Enable embedded STUN server";
        };
        options.stun-ports = lib.mkOption {
          type = types.listOf types.port;
          default = [ 3478 ];
          description = "STUN server UDP ports";
        };
        options.log-level = lib.mkOption {
          type = types.enum [
            "error"
            "warn"
            "info"
            "debug"
          ];
          default = "info";
          description = "Log level of the netbird relay service";
        };
        options.metrics-port = lib.mkOption {
          type = types.port;
          default = 9092;
          description = "Metrics endpoint http port. Metrics are accessible under host:metrics-port/metrics";
        };
        options.health-listen-address = lib.mkOption {
          type = types.str;
          description = ''
            Listen address of healthcheck server
          '';
          default = ":9000";
        };
      };
      default = { };
      description = ''
        Settings to configure the netbird relay.
        Converted automatically into cli args, check all the options with `netbird-relay --help`
      '';
    };

    environmentFile = lib.mkOption {
      type = types.nullOr types.externalPath;
      default = null;
      description = ''
        Path (as string) to an EnvironmentFile with the netbird relay environment variables.
        You can find all the variables under [Relay runtime env variables](https://docs.netbird.io/selfhosted/environment-variables#runtime-variables-2).

        WARNING: Not used by openFirewall, nor systemd hardening
      '';
      example = "/run/netbird-relay.env";
    };

    openFirewall = lib.mkOption {
      type = types.bool;
      default = false;
      description = ''
        Open STUN ports in the firewall for the netbird relay.

        WARNING: You must manually open listen-address port/tcp and port 80/tcp,
        if you are exposing the relay directly to the internet.
        Review [set-up-external-relays](https://docs.netbird.io/selfhosted/maintenance/scaling/set-up-external-relays)
      '';
    };

    authSecretFile = lib.mkOption {
      type = types.nullOr types.externalPath;
      default = null;
      description = ''
        Path (as string) to a file containing the auth-secret used by netbird to connect to the relay server.
        It will populate `NB_AUTH_SECRET`
      '';
      example = "/run/auth_secret";
    };

  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = authSecretSet || cfg.environmentFile != null;
        message = "services.netbird.relay requires NB_AUTH_SECRET, either set authSecretFile or configure it in environmentFile";
      }
      {
        assertion = !(cfg.settings.auth-secret or null != null);
        message = "settings.auth-secret puts the secret into the nix store and the cli args. Use relay.authSecretFile instead";
      }
      {
        assertion = (cfg.settings ? "exposed-address");
        message = "settings.exposed-address is required";
      }
      {
        assertion = !(cfg.settings.enable-stun && cfg.settings.stun-ports == [ ]);
        message = "Missing stun ports while enable-stun = true";
      }
      # TODO: Do other port assertions?
      # {
      #   assertion = listenPort != cfg.settings.metrics-port
      # }
    ];
    systemd.services.netbird-relay = {
      description = "Relay for Netbird, a wireguard VPN";
      documentation = [ "https://netbird.io/docs/" ];
      after = [
        "network.target"
      ];
      wantedBy = [ "multi-user.target" ];

      script = ''
        ${lib.optionalString authSecretSet ''
          export NB_AUTH_SECRET="$(< "$CREDENTIALS_DIRECTORY/auth_secret")"
        ''}
        exec ${cmd} ${args}
      '';
      unitConfig = {
        # Spread the restart
        StartLimitIntervalSec = 60;
        StartLimitBurst = 10;
      };
      serviceConfig = {
        EnvironmentFile = lib.mkIf (cfg.environmentFile != null) [ cfg.environmentFile ];

        # Let systemd ingest the secret safely
        LoadCredential = lib.mkIf authSecretSet "auth_secret:${cfg.authSecretFile}";

        Restart = "always";
        RestartSec = "5s";

        # Hardening::Start
        # Dynamic user automatically sets:
        #   NoNewPrivileges = true;
        #   RemoveIPC = true;
        #   RestrictSUIDSGID = true;
        #   ProtectSystem = "strict";
        #   ProtectHome = "read-only";
        # see https://www.freedesktop.org/software/systemd/man/latest/systemd.exec.html#DynamicUser=
        DynamicUser = true;

        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        # Relay is mostly stateless, no need to give access to any of this:
        PrivateDevices = true;
        PrivateMounts = true;
        PrivateTmp = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProcSubset = "pid";
        ProtectProc = "invisible";
        RestrictNamespaces = true;
        RestrictRealtime = true;
        SystemCallFilter = [ "@system-service" ];
        SystemCallArchitectures = "native";

        # If a user wants to bind netbird to 443, we must allow binding to
        # a socket to Internet domain privileged ports
        CapabilityBoundingSet = lib.optionals needsPrivPort [ "CAP_NET_BIND_SERVICE" ];
        AmbientCapabilities = lib.optionals needsPrivPort [ "CAP_NET_BIND_SERVICE" ];

        # Use only IP, no socket needed
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_NETLINK"
        ];
        UMask = "0077";
        # Hardening::End
      };
    };
    networking.firewall.allowedUDPPorts = lib.mkIf (
      cfg.openFirewall && cfg.settings.enable-stun
    ) cfg.settings.stun-ports;
  };

  meta = {
    doc = ./netbird-relay.md;
    maintainers = [
      lib.maintainers.woile
    ];
  };
}
