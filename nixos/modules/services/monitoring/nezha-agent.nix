{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.nezha-agent;

  # nezha-agent uses yaml as the configuration file format.
  # Since we need to use jq to update the content, so here we generate json
  settingsFormat = pkgs.formats.json { };
  configFile = settingsFormat.generate "config.json" cfg.settings;
in
{
  meta = {
    maintainers = with lib.maintainers; [ moraxyc ];
  };
  options = {
    services.nezha-agent = {
      enable = lib.mkEnableOption "Agent of Nezha Monitoring";

      package = lib.mkPackageOption pkgs "nezha-agent" { };

      debug = lib.mkEnableOption "verbose log";

      settings = lib.mkOption {
        description = ''
          Generate to {file}`config.json` as a Nix attribute set.
          Check the [guide](https://nezha.wiki/en_US/guide/agent.html)
          for possible options.
        '';
        type = lib.types.submodule {
          freeformType = settingsFormat.type;

          options = {
            disable_command_execute = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = ''
                Disable executing the command from dashboard.
              '';
            };
            disable_nat = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = ''
                Disable NAT penetration.
              '';
            };
            disable_send_query = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = ''
                Disable sending TCP/ICMP/HTTP requests.
              '';
            };
            gpu = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = ''
                Enable GPU monitoring.
              '';
            };
            tls = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = ''
                Enable SSL/TLS encryption.
              '';
            };
            temperature = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = ''
                Enable temperature monitoring.
              '';
            };
            use_ipv6_country_code = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = ''
                Use ipv6 countrycode to report location.
              '';
            };
            skip_connection_count = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = ''
                Do not monitor the number of connections.
              '';
            };
            skip_procs_count = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = ''
                Do not monitor the number of processes.
              '';
            };
            report_delay = lib.mkOption {
              type = lib.types.ints.between 1 4;
              default = 3;
              description = ''
                The interval between system status reportings.
                The value must be an integer from 1 to 4.
              '';
            };
            server = lib.mkOption {
              type = lib.types.str;
              example = "127.0.0.1:8008";
              description = ''
                Address to the dashboard.
              '';
            };
            uuid = lib.mkOption {
              type = with lib.types; nullOr str;
              # pre-defined uuid of Dns in RFC 4122
              example = "6ba7b810-9dad-11d1-80b4-00c04fd430c8";
              default = null;
              description = ''
                Must be set to a unique identifier, preferably a UUID according to
                RFC 4122. UUIDs can be generated with `uuidgen` command, found in
                the `util-linux` package.

                Set {option}`services.nezha-agent.genUuid` to true to generate uuid
                from {option}`networking.fqdn` automatically.
              '';
            };
          };
        };
      };

      genUuid = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to generate uuid from fqdn automatically.
          Please note that changes in hostname/domain will result in different uuid.
        '';
      };

      clientSecretFile = lib.mkOption {
        type = with lib.types; nullOr path;
        default = null;
        description = ''
          Path to the file contained the client_secret of the dashboard.
        '';
      };
    };
  };

  imports = with lib; [
    (mkRenamedOptionModule
      [ "services" "nezha-agent" "disableCommandExecute" ]
      [ "services" "nezha-agent" "settings" "disable_command_execute" ]
    )
    (mkRenamedOptionModule
      [ "services" "nezha-agent" "disableNat" ]
      [ "services" "nezha-agent" "settings" "disable_nat" ]
    )
    (mkRenamedOptionModule
      [ "services" "nezha-agent" "disableSendQuery" ]
      [ "services" "nezha-agent" "settings" "disable_send_query" ]
    )
    (mkRenamedOptionModule
      [ "services" "nezha-agent" "gpu" ]
      [ "services" "nezha-agent" "settings" "gpu" ]
    )
    (mkRenamedOptionModule
      [ "services" "nezha-agent" "tls" ]
      [ "services" "nezha-agent" "settings" "tls" ]
    )
    (mkRenamedOptionModule
      [ "services" "nezha-agent" "temperature" ]
      [ "services" "nezha-agent" "settings" "temperature" ]
    )
    (mkRenamedOptionModule
      [ "services" "nezha-agent" "useIPv6CountryCode" ]
      [ "services" "nezha-agent" "settings" "use_ipv6_country_code" ]
    )
    (mkRenamedOptionModule
      [ "services" "nezha-agent" "skipConnection" ]
      [ "services" "nezha-agent" "settings" "skip_connection_count" ]
    )
    (mkRenamedOptionModule
      [ "services" "nezha-agent" "skipProcess" ]
      [ "services" "nezha-agent" "settings" "skip_procs_count" ]
    )
    (mkRenamedOptionModule
      [ "services" "nezha-agent" "reportDelay" ]
      [ "services" "nezha-agent" "settings" "report_delay" ]
    )
    (mkRenamedOptionModule
      [ "services" "nezha-agent" "server" ]
      [ "services" "nezha-agent" "settings" "server" ]
    )
    (lib.mkRemovedOptionModule [ "services" "nezha-agent" "extraFlags" ] ''
      Use `services.nezha-agent.settings` instead.

      Nezha-agent v1 is no longer configured via command line flags.
    '')
    (lib.mkRemovedOptionModule [ "services" "nezha-agent" "passwordFile" ] ''
      Use `services.nezha-agent.clientSecretFile` instead.

      Nezha-agent v1 uses the client secret from the dashboard to connect.
    '')
  ];

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.settings.uuid == null -> cfg.genUuid;
        message = "Please set `service.nezha-agent.settings.uuid` while `genUuid` is false.";
      }
      {
        assertion = cfg.settings.uuid != null -> !cfg.genUuid;
        message = "When `service.nezha-agent.genUuid = true`, `settings.uuid` cannot be set.";
      }
    ];

    services.nezha-agent.settings = {
      debug = cfg.debug;
      # Automatic updates should never be enabled in NixOS.
      disable_auto_update = true;
      disable_force_update = true;
    };

    systemd.services.nezha-agent = {
      serviceConfig = {
        Restart = "on-failure";
        StateDirectory = "nezha-agent";
        RuntimeDirectory = "nezha-agent";
        WorkingDirectory = "/var/lib/nezha-agent";
        ReadWritePaths = "/var/lib/nezha-agent";

        LoadCredential = lib.optionalString (
          cfg.clientSecretFile != null
        ) "client-secret:${cfg.clientSecretFile}";

        # Hardening
        ProcSubset = "all"; # Needed to get host information
        DynamicUser = true;
        RemoveIPC = true;
        LockPersonality = true;
        ProtectClock = true;
        MemoryDenyWriteExecute = true;
        PrivateUsers = true;
        ProtectHostname = true;
        RestrictSUIDSGID = true;
        AmbientCapabilities = [ ];
        CapabilityBoundingSet = "";
        NoNewPrivileges = true;
        PrivateTmp = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        RestrictNamespaces = true;
        RestrictRealtime = true;
        SystemCallArchitectures = "native";
        UMask = "0066";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
        ];
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
        ];
        PrivateDevices = "yes";
      };
      environment.HOME = "/var/lib/nezha-agent";
      enableStrictShellChecks = true;
      startLimitIntervalSec = 10;
      startLimitBurst = 3;
      script = ''
        cp "${configFile}" "''${RUNTIME_DIRECTORY}"/config.json
        ${lib.optionalString (cfg.clientSecretFile != null) ''
          ${lib.getExe pkgs.jq} --arg client_secret "$(<"''${CREDENTIALS_DIRECTORY}"/client-secret)" \
            '. + { client_secret: $client_secret }' < "''${RUNTIME_DIRECTORY}"/config.json > "''${RUNTIME_DIRECTORY}"/config.json.tmp
          mv "''${RUNTIME_DIRECTORY}"/config.json.tmp "''${RUNTIME_DIRECTORY}"/config.json
        ''}
        ${lib.optionalString cfg.genUuid ''
          ${lib.getExe pkgs.jq} --arg uuid "$(${lib.getExe' pkgs.util-linux "uuidgen"} --md5 -n @dns -N "${config.networking.fqdn}")" \
            '. + { uuid: $uuid }' < "''${RUNTIME_DIRECTORY}"/config.json > "''${RUNTIME_DIRECTORY}"/config.json.tmp
          mv "''${RUNTIME_DIRECTORY}"/config.json.tmp "''${RUNTIME_DIRECTORY}"/config.json
        ''}
        ${lib.getExe cfg.package} --config "''${RUNTIME_DIRECTORY}"/config.json
      '';
      wantedBy = [ "multi-user.target" ];
    };
  };
}
