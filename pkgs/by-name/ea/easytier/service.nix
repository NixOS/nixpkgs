# Non-module dependencies (`importApply`)
{
  formats,
  iproute2,
  bash,
}:

# Service module
{
  lib,
  config,
  options,
  ...
}:
let
  cfg = config.easytier;
  instanceName = cfg.settings.instance_name;
  toml = formats.toml { };
in
{
  _class = "service";

  meta.maintainers = with lib.maintainers; [ moraxyc ];

  options = {
    easytier = {
      package = lib.mkOption {
        description = "Package to use for easytier";
        defaultText = "The package that provided this module.";
        type = lib.types.package;
      };

      peers = lib.mkOption {
        type = with lib.types; listOf str;
        default = [ ];
        description = ''
          Peers to connect initially. Valid format is: `<proto>://<addr>:<port>`.
        '';
        example = [
          "tcp://example.com:11010"
        ];
      };

      configServer = lib.mkOption {
        type = with lib.types; nullOr str;
        default = null;
        description = ''
          Configure the instance from config server. When this option
          set, any other settings for configuring the service manually
          except {option}`easytier.settings.hostname` will be ignored. Valid formats are:

          - full uri for custom server: `udp://example.com:22020/<token>`
          - username only for official server: `<token>`
        '';
        example = "udp://example.com:22020/myusername";
      };

      settings = lib.mkOption {
        type = lib.types.submodule {
          freeformType = toml.type;
          options = {
            hostname = lib.mkOption {
              type = with lib.types; nullOr str;
              default = null;
              description = "Hostname shown in peer list and web console.";
            };
            instance_name = lib.mkOption {
              type = lib.types.str;
              description = "Identify different instances on same host";
            };
            network_identity = {
              network_name = lib.mkOption {
                type = with lib.types; nullOr str;
                default = null;
                description = "EasyTier network name.";
              };
              network_secret = lib.mkOption {
                type = with lib.types; nullOr str;
                default = null;
                description = ''
                  EasyTier network credential used for verification and encryption.
                  It is highly recommended to use {option}`easytier.environmentFiles` to
                  avoid leaking the secret into the world-readable Nix store.
                '';
              };
            };
          };
        };
        description = "Settings to generate config file";
      };

      configFile = lib.mkOption {
        type = lib.types.path;
        description = ''
          EasyTier config file.

          When this option is set, it takes precedence over all other
          {option}`easytier.settings.*` options.
        '';
      };

      environmentFiles = lib.mkOption {
        type = with lib.types; listOf path;
        default = [ ];
        description = ''
          Files containing environment variables (like {env}`ET_NETWORK_SECRET`)
          to be passed to the service. All command-line args
          have corresponding environment variables
        '';
        example = lib.literalExpression ''
          [
            /path/to/.env
            /path/to/.env.secret
          ]
        '';
      };

      extraArgs = lib.mkOption {
        description = "Extra arguments to pass to `easytier-core`";
        type = with lib.types; listOf str;
        default = [ ];
      };
    };
  };

  config = {
    easytier = {
      settings.peer = lib.mkIf (cfg.peers != [ ]) (map (p: { uri = p; }) cfg.peers);
      configFile = lib.mkDefault (
        toml.generate "easytier-${instanceName}.toml" (
          lib.attrsets.filterAttrsRecursive (_: v: v != null) cfg.settings
        )
      );
    };
    process = {
      argv = [
        (lib.getExe' cfg.package "easytier-core")
      ]
      ++ lib.optional (cfg.settings.hostname != null) "--hostname=${cfg.settings.hostname}"
      ++ lib.optional (cfg.configServer == null) "--config-file=${config.configData."config.toml".path}"
      ++ lib.optional (cfg.configServer != null) "--config-server=${cfg.configServer}"
      ++ cfg.extraArgs;
    };
    configData."config.toml" = {
      enable = lib.mkDefault (cfg.configServer == null);
      source = cfg.configFile;
    };
  }
  # Refine the service for systemd
  // lib.optionalAttrs (options ? systemd) {
    systemd.mainExecStart = config.systemd.lib.escapeSystemdExecArgs config.process.argv;

    systemd.service = {
      description = "EasyTier Daemon - ${instanceName}";
      wants = [
        "network-online.target"
        "nss-lookup.target"
      ];
      after = [
        "network-online.target"
        "nss-lookup.target"
      ];
      wantedBy = [ "multi-user.target" ];
      path = [
        cfg.package
        iproute2
        bash
      ];
      restartTriggers = [ cfg.configFile ];
      serviceConfig = {
        Type = "simple";
        Restart = "on-failure";
        StateDirectory = "easytier/easytier-${instanceName}";
        StateDirectoryMode = "0700";
        WorkingDirectory = "%S/easytier/easytier-${instanceName}";
        EnvironmentFile = cfg.environmentFiles;

        # Hardening
        DynamicUser = true;
        CapabilityBoundingSet = [
          "CAP_NET_RAW"
          "CAP_NET_ADMIN"
        ];
        AmbientCapabilities = [
          "CAP_NET_RAW"
          "CAP_NET_ADMIN"
        ];
        DeviceAllow = "/dev/net/tun";
        MemoryDenyWriteExecute = true;
        PrivateTmp = true;
        ProtectHome = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        RestrictRealtime = true;
        UMask = "0077";
      };
    };
  };
}
