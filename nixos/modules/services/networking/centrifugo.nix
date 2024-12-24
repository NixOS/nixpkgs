{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.centrifugo;

  settingsFormat = pkgs.formats.json { };

  configFile = settingsFormat.generate "centrifugo.json" cfg.settings;
in
{
  options.services.centrifugo = {
    enable = lib.mkEnableOption "Centrifugo messaging server";

    package = lib.mkPackageOption pkgs "centrifugo" { };

    settings = lib.mkOption {
      type = settingsFormat.type;
      default = { };
      description = ''
        Declarative Centrifugo configuration. See the [Centrifugo
        documentation] for a list of options.

        [Centrifugo documentation]: https://centrifugal.dev/docs/server/configuration
      '';
    };

    credentials = lib.mkOption {
      type = lib.types.attrsOf lib.types.path;
      default = { };
      example = {
        CENTRIFUGO_UNI_GRPC_TLS_KEY = "/run/keys/centrifugo-uni-grpc-tls.key";
      };
      description = ''
        Environment variables with absolute paths to credentials files to load
        on service startup.
      '';
    };

    environmentFiles = lib.mkOption {
      type = lib.types.listOf lib.types.path;
      default = [ ];
      description = ''
        Files to load environment variables from. Options set via environment
        variables take precedence over {option}`settings`.

        See the [Centrifugo documentation] for the environment variable name
        format.

        [Centrifugo documentation]: https://centrifugal.dev/docs/server/configuration#os-environment-variables
      '';
    };

    extraGroups = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [ "redis-centrifugo" ];
      description = ''
        Additional groups for the systemd service.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.centrifugo = {
      description = "Centrifugo messaging server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        Type = "exec";

        ExecStartPre = "${lib.getExe cfg.package} checkconfig --config ${configFile}";
        ExecStart = "${lib.getExe cfg.package} --config ${configFile}";
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";

        Restart = "always";
        RestartSec = "1s";

        # Copy files to the credentials directory with file name being the
        # environment variable name. Note that "%d" specifier expands to the
        # path of the credentials directory.
        LoadCredential = lib.mapAttrsToList (name: value: "${name}:${value}") cfg.credentials;
        Environment = lib.mapAttrsToList (name: _: "${name}=%d/${name}") cfg.credentials;

        EnvironmentFile = cfg.environmentFiles;

        SupplementaryGroups = cfg.extraGroups;

        DynamicUser = true;
        UMask = "0077";

        ProtectHome = true;
        ProtectProc = "invisible";
        ProcSubset = "pid";
        ProtectClock = true;
        ProtectHostname = true;
        ProtectControlGroups = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        PrivateUsers = true;
        PrivateDevices = true;
        RestrictRealtime = true;
        RestrictNamespaces = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        DeviceAllow = [ "" ];
        DevicePolicy = "closed";
        CapabilityBoundingSet = [ "" ];
        MemoryDenyWriteExecute = true;
        LockPersonality = true;
        SystemCallArchitectures = "native";
        SystemCallErrorNumber = "EPERM";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
        ];
      };
    };
  };
}
