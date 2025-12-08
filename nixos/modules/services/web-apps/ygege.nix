{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.ygege;
in
{
  meta.maintainers = with lib.maintainers; [ nyanloutre ];

  options.services.ygege = {
    enable = lib.mkEnableOption "High-performance indexer for YGG Torrent";

    package = lib.mkPackageOption pkgs "ygege" { };

    environment = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {
        BIND_IP = "127.0.0.1";
        BIND_PORT = "8715";
        LOG_LEVEL = "warn";
      };
      example = {
        YGG_USERNAME = "your_ygg_username";
        YGG_PASSWORD = "your_ygg_password";
        BIND_IP = "0.0.0.0";
        BIND_PORT = "8715";
        LOG_LEVEL = "debug";
      };
      description = ''
        Environment variables to set for the service.

        Warning: do not set confidential information here
        because it is world-readable in the Nix store.
        Secrets should be specified using {option}`environmentFile`.

        See [Ygege documentation] for all available options.

        [Ygege documentation]: https://ygege.lila.ws/configuration#variables-denvironnement
      '';
    };

    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        Environment file for specifying additional settings such as secrets.

        See [Ygege documentation] for all available options.

        [Ygege documentation]: https://ygege.lila.ws/configuration#variables-denvironnement
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    services.ygege.environment = {
      BIND_IP = lib.mkDefault "127.0.0.1";
      BIND_PORT = lib.mkDefault "8715";
      LOG_LEVEL = lib.mkDefault "warn";
    };

    systemd.services.ygege = {
      description = "High-performance indexer for YGG Torrent";

      environment = cfg.environment;

      serviceConfig = {
        ExecStart = lib.getExe cfg.package;
        Restart = "always";

        DynamicUser = true;
        StateDirectory = "ygege";
        StateDirectoryMode = "0700";
        WorkingDirectory = "/var/lib/ygege";
        EnvironmentFile = cfg.environmentFile;

        CapabilityBoundingSet = "";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        PrivateDevices = true;
        PrivateUsers = true;
        ProcSubset = "pid";
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        RestrictAddressFamilies = [
          "AF_UNIX"
          "AF_INET"
          "AF_INET6"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
          "~@resources"
        ];
        UMask = "0066";
      };

      wantedBy = [ "multi-user.target" ];
    };
  };
}
