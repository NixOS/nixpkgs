{
  config,
  lib,
  pkgs,
  utils,
  ...
}:

let
  inherit (lib)
    concatStringsSep
    getExe'
    mkEnableOption
    mkIf
    mkMerge
    mkOption
    mkPackageOption
    optionals
    ;

  inherit (lib.types)
    bool
    listOf
    nullOr
    enum
    path
    port
    str
    ;

  inherit (utils) escapeSystemdExecArgs;

  cfg = config.services.netbird.server.relay;
  stateDir = "/var/lib/netbird-relay";
in

{
  options.services.netbird.server.relay = {
    enable = mkEnableOption "NetBird Relay Server";

    package = mkPackageOption pkgs "netbird" { };

    port = mkOption {
      type = port;
      default = 33080;
      description = ''
        Port the relay server listens on.
        When behind nginx (enableNginx), this is the internal port that nginx proxies to.
      '';
    };

    exposedAddress = mkOption {
      type = str;
      description = ''
        The public URL where clients can reach this relay server.
        This is advertised to clients via the management server.
      '';
      example = "rels://relay.example.com:443";
    };

    authSecretFile = mkOption {
      type = path;
      description = ''
        Path to a file containing the relay authentication secret.
        The file should contain only the raw secret value.
        This must match the relaySecretFile configured in the management server.
      '';
    };

    logLevel = mkOption {
      type = enum [
        "panic"
        "fatal"
        "error"
        "warn"
        "info"
        "debug"
        "trace"
      ];
      default = "info";
      description = "Log level for the relay server.";
    };

    stun = {
      enable = mkOption {
        type = bool;
        default = true;
        description = ''
          Enable the embedded STUN server.
          This provides STUN functionality alongside the relay server.
        '';
      };

      ports = mkOption {
        type = listOf port;
        default = [ 3478 ];
        description = "UDP ports for the embedded STUN server.";
      };
    };

    openFirewall = mkOption {
      type = bool;
      default = false;
      description = ''
        Whether to open the relay and STUN ports in the firewall.
      '';
    };

    enableNginx = mkEnableOption "Nginx reverse-proxy for the relay server";

    domain = mkOption {
      type = nullOr str;
      default = null;
      description = "Domain name for nginx virtual host configuration.";
    };

    extraOptions = mkOption {
      type = listOf str;
      default = [ ];
      description = ''
        Additional command-line options passed to the relay server.
        Use this for advanced settings like TLS configuration
        (e.g. `["--tls-cert-file" "/path/to/cert" "--tls-key-file" "/path/to/key"]`).
      '';
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      assertions = [
        {
          assertion = cfg.enableNginx -> cfg.domain != null;
          message = "domain must be set when enableNginx is true";
        }
      ];

      systemd.services.netbird-relay = {
        description = "NetBird Relay Server";
        documentation = [ "https://docs.netbird.io/" ];

        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        restartTriggers = [
          cfg.port
          cfg.logLevel
          cfg.exposedAddress
          cfg.stun.enable
        ];

        serviceConfig = {
          # Secret handling: write EnvironmentFile in preStart from LoadCredential,
          # then ExecStart reads it. This avoids exposing the secret in /proc
          # and gives systemd proper process tracking (unlike a script wrapper).
          LoadCredential = [ "auth-secret:${cfg.authSecretFile}" ];

          ExecStart = escapeSystemdExecArgs (
            [
              (getExe' cfg.package "netbird-relay")
              "--listen-address"
              ":${toString cfg.port}"
              "--exposed-address"
              cfg.exposedAddress
              "--log-level"
              cfg.logLevel
              "--log-file"
              "console"
            ]
            ++ optionals cfg.stun.enable [
              "--enable-stun"
              "--stun-ports"
              (concatStringsSep "," (map toString cfg.stun.ports))
            ]
            ++ cfg.extraOptions
          );

          Restart = "always";
          RuntimeDirectory = "netbird-relay";
          RuntimeDirectoryMode = "0750";
          StateDirectory = "netbird-relay";
          StateDirectoryMode = "0750";
          WorkingDirectory = stateDir;
          DynamicUser = true;

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

          # Relay may need to bind to privileged ports when not behind nginx
          AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
          CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ];
        };

        # Inject the auth secret via EnvironmentFile.
        # LoadCredential makes the file available at $CREDENTIALS_DIRECTORY/auth-secret,
        # then preStart writes an EnvironmentFile that ExecStart picks up.
        # The relay binary reads NB_AUTH_SECRET from the environment via setFlagsFromEnvVars().
        preStart = ''
          umask 077
          echo "NB_AUTH_SECRET=$(< "$CREDENTIALS_DIRECTORY/auth-secret")" > "$RUNTIME_DIRECTORY/env"
        '';

        stopIfChanged = false;
      };

      systemd.services.netbird-relay.serviceConfig.EnvironmentFile = "/run/netbird-relay/env";
    }

    (mkIf cfg.openFirewall {
      networking.firewall = {
        allowedTCPPorts = [ cfg.port ];
        allowedUDPPorts = mkIf cfg.stun.enable cfg.stun.ports;
      };
    })

    (mkIf cfg.enableNginx {
      services.nginx = {
        enable = true;

        virtualHosts.${cfg.domain} = {
          locations."/relay".extraConfig = ''
            proxy_pass http://127.0.0.1:${toString cfg.port};
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "upgrade";
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_read_timeout 86400;
          '';
        };
      };
    })
  ]);
}
