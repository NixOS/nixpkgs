{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.krill;
  toml = pkgs.formats.toml { };
in
{
  meta = {
    maintainers = [ lib.maintainers.stepbrobd ];
    teams = [ lib.teams.ngi ];
  };

  options.services.krill = {
    enable = lib.mkEnableOption "Krill, RPKI CA and Publication Server";

    package = lib.mkPackageOption pkgs "krill" { };

    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = "/run/secrets/krill";
      description = ''
        Environment file for krill.

        Krill requires an admin token to start.
        Use this file to provide `KRILL_ADMIN_TOKEN=...`
        (e.g. via agenix or sops-nix).
      '';
    };

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = toml.type;
        options = {
          storage_uri = lib.mkOption {
            type = lib.types.str;
            default = "/var/lib/krill/data";
            description = ''
              Where Krill stores its data e.g. CA keys and the publication repository.
              The default keeps it inside service state directory.
            '';
          };
          log_type = lib.mkOption {
            type = lib.types.enum [
              "stderr"
              "file"
              "syslog"
            ];
            default = "stderr";
            description = "Where Krill logs to.";
          };
        };
      };
      default = { };
      description = ''
        Configuration written to `krill.conf`.
        See <https://krill.docs.nlnetlabs.nl/en/stable/config.html> for available options.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    systemd.services.krill = {
      description = "Krill RPKI CA and Publication Server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        Type = "exec";
        ExecStart = "${lib.getExe' cfg.package "krill"} --config ${toml.generate "krill.conf" cfg.settings}";
        EnvironmentFile = lib.optional (cfg.environmentFile != null) cfg.environmentFile;
        Restart = "on-failure";
        RestartSec = 10;
        StateDirectory = "krill";
        StateDirectoryMode = "0700";
        RuntimeDirectory = "krill";
        UMask = "0077";
        CapabilityBoundingSet = [ "" ];
        DynamicUser = true;
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateTmp = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectSystem = "strict";
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        SystemCallArchitectures = "native";
        SystemCallErrorNumber = "EPERM";
        SystemCallFilter = "@system-service";
      };
    };
  };
}
