{
  config,
  pkgs,
  lib,
  utils,
  ...
}:
let
  cfg = config.services.pghero;
  settingsFormat = pkgs.formats.yaml { };
  settingsFile = settingsFormat.generate "pghero.yaml" cfg.settings;
in
{
  options.services.pghero = {
    enable = lib.mkEnableOption "PgHero service";
    package = lib.mkPackageOption pkgs "pghero" { };

    listenAddress = lib.mkOption {
      type = lib.types.str;
      example = "[::1]:3000";
      description = ''
        `hostname:port` to listen for HTTP traffic.

        This is bound using the systemd socket activation.
      '';
    };

    extraArgs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = ''
        Additional command-line arguments for the systemd service.

        Refer to the [Puma web server documentation] for available arguments.

        [Puma web server documentation]: https://puma.io/puma#configuration
      '';
    };

    settings = lib.mkOption {
      type = settingsFormat.type;
      default = { };
      example = {
        databases = {
          primary = {
            url = "<%= ENV['PRIMARY_DATABASE_URL'] %>";
          };
        };
      };
      description = ''
        PgHero configuration. Refer to the [PgHero documentation] for more
        details.

        [PgHero documentation]: https://github.com/ankane/pghero/blob/master/guides/Linux.md#multiple-databases
      '';
    };

    environment = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      description = ''
        Environment variables to set for the service. Secrets should be
        specified using {option}`environmentFile`.
      '';
    };

    environmentFiles = lib.mkOption {
      type = lib.types.listOf lib.types.path;
      default = [ ];
      description = ''
        File to load environment variables from. Loaded variables override
        values set in {option}`environment`.
      '';
    };

    extraGroups = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [ "tlskeys" ];
      description = ''
        Additional groups for the systemd service.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.sockets.pghero = {
      unitConfig.Description = "PgHero HTTP socket";
      wantedBy = [ "sockets.target" ];
      listenStreams = [ cfg.listenAddress ];
    };

    systemd.services.pghero = {
      description = "PgHero performance dashboard for PostgreSQL";
      wantedBy = [ "multi-user.target" ];
      requires = [ "pghero.socket" ];
      after = [
        "pghero.socket"
        "network.target"
      ];

      environment = {
        RAILS_ENV = "production";
        PGHERO_CONFIG_PATH = settingsFile;
      } // cfg.environment;

      serviceConfig = {
        Type = "notify";
        WatchdogSec = "10";

        ExecStart = utils.escapeSystemdExecArgs (
          [
            (lib.getExe cfg.package)
            "--bind-to-activated-sockets"
            "only"
          ]
          ++ cfg.extraArgs
        );
        Restart = "always";

        WorkingDirectory = "${cfg.package}/share/pghero";

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
        SystemCallFilter = [ "@system-service" ];
      };
    };
  };
}
