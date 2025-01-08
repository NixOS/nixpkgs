{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.typesense;
  settingsFormatIni = pkgs.formats.ini {
    listToValue = lib.concatMapStringsSep " " (lib.generators.mkValueStringDefault { });
    mkKeyValue = lib.generators.mkKeyValueDefault {
      mkValueString = v: if v == null then "" else lib.generators.mkValueStringDefault { } v;
    } "=";
  };
  configFile = settingsFormatIni.generate "typesense.ini" cfg.settings;
in
{
  options.services.typesense = {
    enable = lib.mkEnableOption "typesense";
    package = lib.mkPackageOption pkgs "typesense" { };

    apiKeyFile = lib.mkOption {
      type = lib.types.path;
      description = ''
        Sets the admin api key for typesense. Always use this option
        instead of {option}`settings.server.api-key` to prevent the key
        from being written to the world-readable nix store.
      '';
    };

    settings = lib.mkOption {
      description = "Typesense configuration. Refer to [the documentation](https://typesense.org/docs/0.24.1/api/server-configuration.html) for supported values.";
      default = { };
      type = lib.types.submodule {
        freeformType = settingsFormatIni.type;
        options.server = {
          data-dir = lib.mkOption {
            type = lib.types.str;
            default = "/var/lib/typesense";
            description = "Path to the directory where data will be stored on disk.";
          };

          api-address = lib.mkOption {
            type = lib.types.str;
            description = "Address to which Typesense API service binds.";
          };

          api-port = lib.mkOption {
            type = lib.types.port;
            default = 8108;
            description = "Port on which the Typesense API service listens.";
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.typesense = {
      description = "Typesense search engine";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      script = ''
        export TYPESENSE_API_KEY=$(cat ${cfg.apiKeyFile})
        exec ${cfg.package}/bin/typesense-server --config ${configFile}
      '';

      serviceConfig = {
        Restart = "on-failure";
        DynamicUser = true;
        User = "typesense";
        Group = "typesense";

        StateDirectory = "typesense";
        StateDirectoryMode = "0750";

        # Hardening
        CapabilityBoundingSet = "";
        LockPersonality = true;
        # MemoryDenyWriteExecute = true; needed since 0.25.1
        NoNewPrivileges = true;
        PrivateUsers = true;
        PrivateTmp = true;
        PrivateDevices = true;
        PrivateMounts = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProcSubset = "pid";
        ProtectSystem = "strict";
        RemoveIPC = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
        ];
        UMask = "0077";
      };
    };
  };
}
