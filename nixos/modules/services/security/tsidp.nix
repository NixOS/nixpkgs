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
    ;
  inherit (lib.types)
    path
    str
    submodule
    int
    port
    bool
    enum
    ;

  cfg = config.services.tsidp;

  format = pkgs.formats.keyValue { };
  settingsFile = format.generate "tsidp-env-vars" cfg.settings;
in
{
  options.services.tsidp = {
    enable = mkEnableOption "tsidp server";

    package = mkPackageOption pkgs "tsidp" { };

    environmentFile = mkOption {
      type = path;
      description = ''
        Path to an environment file loaded for the tsidp service.

        This can be used to securely store tokens and secrets outside of the world-readable Nix store.

        Example contents of the file:
        TS_AUTH_KEY=YOUR_TAILSCALE_AUTHKEY
      '';
      default = "/dev/null";
      example = "/run/secrets/tsidp";
    };

    settings = mkOption {
      type = submodule {
        freeformType = format.type;

        options = {
          TAILSCALE_USE_WIP_CODE = mkOption {
            type = bool;
            description = ''
              Enable work-in-progress code (default: "true", required).

              These are needed while tsidp is in development (< v1.0.0).
            '';
            default = true;
          };

          TSIDP_PORT = mkOption {
            type = port;
            description = ''
              Port to listen on (default: 443).
            '';
            default = 443;
          };

          TSIDP_LOCAL_PORT = mkOption {
            type = int;
            description = ''
              Allow requests from localhost (default -1).
            '';
            default = -1;
          };

          TS_HOSTNAME = mkOption {
            type = str;
            description = ''
              The tsnet hostname.
            '';
            default = "idp";
          };

          TSIDP_USE_LOCAL_TAILSCALED = mkOption {
            type = bool;
            description = ''
              Use local tailscaled instead of tsnet.
            '';
            default = false;
          };

          TSIDP_USE_FUNNEL = mkOption {
            type = bool;
            description = ''
              Use Tailscale Funnel to make tsidp available on the public internet so it works with SaaS products.
            '';
            default = false;
          };

          TSIDP_ENABLE_STS = mkOption {
            type = bool;
            description = ''
              Enable OAuth token exchange using RFC 8693.
            '';
            default = true;
          };

          TSIDP_LOG = mkOption {
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

          TSIDP_DEBUG_ALL_REQUESTS = mkOption {
            type = bool;
            description = ''
              For development. Prints all requests and responses.
            '';
            default = false;
          };

          TSIDP_DEBUG_TSNET = mkOption {
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
        assertion = cfg.settings.TSIDP_USE_LOCAL_TAILSCALED -> config.services.tailscale.enable == true;
        message = "Tailscale service must be enabled if services.tsidp.settings.TSIDP_USE_LOCAL_TAILSCALED is set to 1.";
      }
    ];

    systemd.services.tsidp = {
      description = "tsidp";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      restartTriggers = [
        cfg.package
        cfg.environmentFile
        settingsFile
      ];

      environment = {
        HOME = "/var/lib/tsidp";
      };
      serviceConfig = {
        Type = "simple";
        ExecStart = getExe cfg.package;
        Restart = "always";

        DynamicUser = true;
        StateDirectory = "tsidp";
        WorkingDirectory = "/var/lib/tsidp";
        ReadWritePaths = mkIf (cfg.settings.TSIDP_USE_LOCAL_TAILSCALED == 1) [
          "/var/run/tailscale"
          "/var/lib/tailscale"
        ];
        BindPaths = mkIf (cfg.settings.TSIDP_USE_LOCAL_TAILSCALED == 1) [
          "/var/run/tailscale:/var/run/tailscale"
        ];

        EnvironmentFile = [
          cfg.environmentFile
          settingsFile
        ];

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
  ];
}
