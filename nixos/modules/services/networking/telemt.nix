{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.telemt;

  configFormat = pkgs.formats.toml { };

  effectiveConfigFile =
    if cfg.configFile != null then
      cfg.configFile
    else
      configFormat.generate "telemt-config.toml" cfg.settings;
in

{
  options = {
    services.telemt = {
      enable = lib.mkEnableOption "Telemt - MTProxy for Telegram";

      package = lib.mkPackageOption pkgs "telemt" { };

      settings = lib.mkOption {
        type = lib.types.submodule {
          freeformType = configFormat.type;
        };
        default = { };
        example = {
          general = {
            use_middle_proxy = false;
          };
          server = {
            port = 443;
          };
          censorship = {
            tls_domain = "petrovich.ru";
          };
          access = {
            users = {
              hello = "00000000000000000000000000000000";
            };
          };
        };
        description = ''
          Telemt configuration as a Nix attribute set.

          **Warning:** Secrets are stored world-readable in the Nix store.

          Mutually exclusive with `services.telemt.configFile`.
          See the [upstream documentation](https://github.com/telemt/telemt/blob/main/docs/CONFIG_PARAMS.en.md) for available parameters.
        '';
      };

      configFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        example = "/etc/secrets/telemt.toml";
        description = ''
          Path to an existing Telemt configuration file in TOML format.

          Use this for secrets management outside the Nix store.

          Mutually exclusive with `services.telemt.settings`.
          See the [upstream example](https://github.com/telemt/telemt/blob/main/config.toml).
        '';
      };

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to automatically open the firewall for Telemt.
          Opens the data-plane MTProto TCP port based on the `services.telemt.settings.server.port`.

          Does not work with `services.telemt.configFile`.
          When using an external config file, the port is not known to NixOS, so the firewall cannot be configured automatically.
          Use `networking.firewall.allowedTCPPorts` manually in this case.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {

    assertions = [
      {
        assertion = (cfg.settings != { }) != (cfg.configFile != null);
        message = ''
          Provide configuration via exactly one of these methods:
            - Set `services.telemt.settings` with Nix attribute set, or
            - Set `services.telemt.configFile` with path to external TOML file.
        '';
      }
      {
        assertion = cfg.openFirewall -> cfg.configFile == null;
        message = ''
          `services.telemt.openFirewall` cannot be used with `services.telemt.configFile`.
          When using an external config file, the port is not known to NixOS, so the firewall cannot be configured automatically.

          Either:
            - Use `services.telemt.settings` with `services.telemt.settings.server.port` set and remove `services.telemt.configFile`, or
            - Disable `services.telemt.openFirewall` and configure `networking.firewall.allowedTCPPorts` manually.
        '';
      }
      {
        assertion =
          cfg.openFirewall && cfg.configFile == null && cfg.settings ? server && cfg.settings.server ? port;
        message = ''
          `services.telemt.openFirewall` requires `services.telemt.settings.server.port` to be set.

          When opening the firewall automatically, the port must be specified in the Nix configuration.
        '';
      }
    ];

    systemd.services.telemt = {
      description = "Telemt MTProxy Server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        Restart = "on-failure";
        RestartSec = "5";

        DynamicUser = true;

        LoadCredential = "config.toml:${effectiveConfigFile}";

        RuntimeDirectory = "telemt";
        RuntimeDirectoryMode = "0700";

        WorkingDirectory = "/run/telemt";

        # Resource limits
        LimitNOFILE = 1048576;
        LimitNPROC = 512;
        LimitCORE = 0;

        ExecStart = "${lib.getExe cfg.package} /run/credentials/telemt.service/config.toml";

        # Security hardening
        NoNewPrivileges = true;
        PrivateTmp = true;
        PrivateDevices = true;
        PrivateMounts = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;
        ProtectProc = "invisible";
        ProcSubset = "pid";
        ProtectClock = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;

        AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
        CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ];

        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        RestrictSUIDSGID = true;
        RestrictRealtime = true;
        RestrictNamespaces = true;
        RemoveIPC = true;
        UMask = "0077";

        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
        ];

        SystemCallFilter = [
          "@system-service"
        ];

        SystemCallArchitectures = "native";
      };
    };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.settings.server.port ];
  };

  meta.maintainers = with lib.maintainers; [
    c0bectb
    r4v3n6101
  ];
}
