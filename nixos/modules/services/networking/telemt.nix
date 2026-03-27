{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.telemt;

  # TOML format generator for type-safe serialization of Nix attribute sets.
  configFormat = pkgs.formats.toml { };

  # Resolves the mutually exclusive 'settings' and 'configFile' options
  # into a single path to be used by the service.
  effectiveConfigFile =
    if cfg.configFile != null then
      cfg.configFile
    else
      configFormat.generate "telemt-config.toml" cfg.settings;
in

{
  options = {
    services.telemt = {
      enable = lib.mkEnableOption "Telemt - MTProxy for Telegram on Rust + Tokio";

      package = lib.mkPackageOption pkgs "telemt" { };

      settings = lib.mkOption {
        type = lib.types.submodule {
          freeformType = configFormat.type;
        };
        default = { };
        example = {
          general = {
            use_middle_proxy = false;
            log_level = "normal";
          };
          general.modes = {
            classic = false;
            secure = false;
            tls = true;
          };
          general.links = {
            show = "*";
          };
          server = {
            port = 443;
            listen_addr_ipv4 = "0.0.0.0";
            listen_addr_ipv6 = "::";
            proxy_protocol = false;
          };
          server.api = {
            enabled = true;
            listen = "0.0.0.0:9091";
          };
          censorship = {
            tls_domain = "petrovich.ru";
            mask = true;
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
        example = "/etc/secrets/telemt/config.toml";
        description = ''
          Path to an existing Telemt configuration file in TOML format.

          Use this for secrets management outside the Nix store.

          Mutually exclusive with `services.telemt.settings`.
          See the [upstream example](https://github.com/telemt/telemt/blob/main/config.toml).
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
    ];

    systemd.services.telemt = {
      description = "Telemt MTProxy Server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        Restart = "on-failure";
        RestartSec = "5s";

        DynamicUser = true;

        LoadCredential = "config.toml:${effectiveConfigFile}";

        RuntimeDirectory = "telemt";
        RuntimeDirectoryMode = "0700";

        WorkingDirectory = "/run/telemt";

        # Resource limits.
        LimitNOFILE = 1048576;
        LimitNPROC = 512;
        LimitCORE = 0;

        ExecStart = "${lib.getExe cfg.package} /run/credentials/telemt.service/config.toml";

        # Security hardening.
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
  };

  meta.maintainers = with lib.maintainers; [
    c0bectb
    r4v3n6101
  ];
}
