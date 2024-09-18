{ config, lib, pkgs, ... }: let
  inherit
    (lib)
    concatMapStringsSep
    generators
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    optionalString
    types
    ;

  cfg = config.services.typesense;
  settingsFormatIni = pkgs.formats.ini {
    listToValue = concatMapStringsSep " " (generators.mkValueStringDefault { });
    mkKeyValue = generators.mkKeyValueDefault
      {
        mkValueString = v:
          if v == null then ""
          else generators.mkValueStringDefault { } v;
      }
      "=";
  };
  configFile = settingsFormatIni.generate "typesense.ini" cfg.settings;
in {
  options.services.typesense = {
    enable = mkEnableOption "typesense";
    package = mkPackageOption pkgs "typesense" {};

    apiKeyFile = mkOption {
      type = types.path;
      description = ''
        Sets the admin api key for typesense. Always use this option
        instead of {option}`settings.server.api-key` to prevent the key
        from being written to the world-readable nix store.
      '';
    };

    settings = mkOption {
      description = "Typesense configuration. Refer to [the documentation](https://typesense.org/docs/0.24.1/api/server-configuration.html) for supported values.";
      default = {};
      type = types.submodule {
        freeformType = settingsFormatIni.type;
        options.server = {
          data-dir = mkOption {
            type = types.str;
            default = "/var/lib/typesense";
            description = "Path to the directory where data will be stored on disk.";
          };

          api-address = mkOption {
            type = types.str;
            description = "Address to which Typesense API service binds.";
          };

          api-port = mkOption {
            type = types.port;
            default = 8108;
            description = "Port on which the Typesense API service listens.";
          };
        };
      };
    };
  };

  config = mkIf cfg.enable {
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
