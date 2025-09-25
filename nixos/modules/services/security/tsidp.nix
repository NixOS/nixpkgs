{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib)
    getExe
    maintainers
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    optional
    optionalString
    ;
  inherit (lib.types)
    path
    str
    submodule
    port
    bool
    enum
    nullOr
    ;

  cfg = config.services.tsidp;
in
{
  options.services.tsidp = {
    enable = mkEnableOption "tsidp server";

    package = mkPackageOption pkgs "tsidp" { };

    environmentFile = mkOption {
      type = nullOr path;
      description = ''
        Path to an environment file loaded for the tsidp service.

        This can be used to securely store tokens and secrets outside of the world-readable Nix store.

        Example contents of the file:
        TS_AUTH_KEY=YOUR_TAILSCALE_AUTHKEY
      '';
      default = null;
      example = "/run/secrets/tsidp";
    };

    settings = mkOption {
      type = submodule {
        options = {
          hostName = mkOption {
            type = str;
            default = "idp";
            description = ''
              The hostname to use for the tsnet node.
            '';
          };

          port = mkOption {
            type = port;
            default = 443;
            description = ''
              Port to listen on (default: 443).
            '';
          };

          localPort = mkOption {
            type = nullOr port;
            default = null;
            description = "Listen on localhost:<port>.";
          };

          useLocalTailscaled = mkOption {
            type = bool;
            description = ''
              Use local tailscaled instead of tsnet.
            '';
            default = false;
          };

          enableFunnel = mkOption {
            type = bool;
            default = false;
            description = ''
              Use Tailscale Funnel to make tsidp available on the public internet so it works with SaaS products.
            '';
          };

          enableSts = mkOption {
            type = bool;
            default = true;
            description = ''
              Enable OAuth token exchange using RFC 8693.
            '';
          };

          logLevel = mkOption {
            type = enum [
              "debug"
              "info"
              "warn"
              "error"
            ];
            description = ''
              Set logging level: debug, info, warn, error.
            '';
            default = "info";
          };

          debugAllRequests = mkOption {
            type = bool;
            description = ''
              For development. Prints all requests and responses.
            '';
            default = false;
          };

          debugTsnet = mkOption {
            type = bool;
            description = ''
              For development. Enables debug level logging with tsnet connection.
            '';
            default = false;
          };
        };
      };

      default = { };

      description = ''
        Environment variables that will be passed to tsidp, see
        [configuration options](https://github.com/tailscale/tsidp#tsidp-configuration-options)
        for supported values.
      '';
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.settings.useLocalTailscaled -> config.services.tailscale.enable == true;
        message = "Tailscale service must be enabled if services.tsidp.settings.useLocalTailscaled is used.";
      }
    ];

    systemd.services.tsidp =
      let
        deps = [
          "network.target"
        ]
        ++ optional (cfg.settings.useLocalTailscaled) "tailscaled.service";
      in
      {
        description = "tsidp";
        after = deps;
        wants = deps;
        wantedBy = [
          "multi-user.target"
          "network-online.target"
        ];
        restartTriggers = [
          cfg.package
          cfg.environmentFile
        ];

        environment = {
          HOME = "/var/lib/tsidp";
          TAILSCALE_USE_WIP_CODE = "1"; # Needed while tsidp is in development (< v1.0.0).
        };

        serviceConfig = {
          Type = "simple";
          ExecStart = ''
            ${getExe cfg.package} \
              ${optionalString (cfg.settings.hostName != "idp") "-hostname=${cfg.hostName}"} \
              ${optionalString (cfg.settings.port != 443) "-port=${toString cfg.port}"} \
              ${optionalString (cfg.settings.localPort != null) "-local-port=${cfg.localPort}"} \
              ${optionalString (cfg.settings.useLocalTailscaled) "-use-local-tailscaled"} \
              ${optionalString (cfg.settings.enableFunnel) "-funnel"} \
              ${optionalString (cfg.settings.enableSts) "-enable-sts"} \
              ${optionalString (cfg.settings.logLevel != "info") "-log=${cfg.logLevel}"} \
              ${optionalString (cfg.settings.debugAllRequests) "-debug-all-requests"} \
              ${optionalString (cfg.settings.debugTsnet) "-debug-tsnet"}
          '';
          Restart = "always";
          RestartSec = "15";

          DynamicUser = true;
          StateDirectory = "tsidp";
          WorkingDirectory = "/var/lib/tsidp";
          ReadWritePaths = mkIf (cfg.settings.useLocalTailscaled) [
            "/var/run/tailscale"
            "/var/lib/tailscale"
          ];
          BindPaths = mkIf (cfg.settings.useLocalTailscaled) [
            "/var/run/tailscale:/var/run/tailscale"
          ];

          EnvironmentFile = mkIf (cfg.environmentFile != null) cfg.environmentFile;

          # Hardening
          AmbientCapabilities = "";
          CapabilityBoundingSet = "";
          DeviceAllow = "";
          DevicePolicy = "closed";
          LockPersonality = true;
          MemoryDenyWriteExecute = true;
          NoNewPrivileges = true;
          PrivateNetwork = false; # provides the service through network
          PrivateTmp = true;
          PrivateUsers = true;
          PrivateDevices = true;
          ProtectHome = true;
          ProtectClock = true;
          ProtectControlGroups = true;
          ProtectKernelModules = true;
          ProtectKernelLogs = true;
          ProtectKernelTunables = true;
          ProtectSystem = "strict";
          ProtectHostname = true;
          ProtectProc = "invisible";
          ProcSubset = "all"; # tsidp needs access to /proc/net/route
          RestrictAddressFamilies = [
            "AF_INET"
            "AF_INET6"
            "AF_UNIX"
            "AF_NETLINK"
          ];
          RestrictRealtime = true;
          RestrictNamespaces = true;
          RestrictSUIDSGID = true;
          SystemCallArchitectures = "native";
          SystemCallFilter = [ "@system-service" ];
        };
      };
  };

  meta.maintainers = with maintainers; [
    akotro
    mikeodr
    yethal
  ];
}
