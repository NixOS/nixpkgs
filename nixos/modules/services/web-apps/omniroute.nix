{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.omniroute;
  dataDir = "/var/lib/omniroute";
in
{
  options.services.omniroute = {
    enable = lib.mkEnableOption "OmniRoute AI gateway";
    package = lib.mkPackageOption pkgs "omniroute" { };

    settings = lib.mkOption {
      type =
        with lib.types;
        submodule {
          freeformType = attrsOf (
            nullOr (
              coercedTo
                (oneOf [
                  bool
                  int
                ])
                lib.toJSON
                (oneOf [
                  str
                  path
                  package
                ])
            )
          );
          options = {
            OMNIROUTE_SHOW_LOG = lib.mkOption {
              type = lib.types.bool;
              default = true;
              apply = value: if value then "1" else "0";
              description = ''
                Whether to expose the service logs to the system journal.
              '';
            };
          };
        };
      description = ''
        Freeform attribute where all environment variables that OmniRoute supports can be set.
        A full list is found at [ENVIRONMENT.md](https://github.com/diegosouzapw/OmniRoute/blob/main/docs/reference/ENVIRONMENT.md)
      '';
    };

    environmentFiles = lib.mkOption {
      type = lib.types.listOf lib.types.path;
      default = [ ];
      description = ''
        Additional files that are passed as environment variables.
        Useful for secrets.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    services.omniroute.settings.DATA_DIR = dataDir;

    systemd.services.omniroute = {
      description = "OmniRoute AI gateway";
      documentation = [ "https://github.com/diegosouzapw/OmniRoute" ];
      wantedBy = [ "multi-user.target" ];

      environment = cfg.settings;

      serviceConfig = {
        Type = "exec";
        DynamicUser = true;

        StateDirectory = "omniroute";
        WorkingDirectory = dataDir;

        ExecStart = "${lib.getExe cfg.package} --no-open";
        Restart = "on-failure";

        EnvironmentFile = cfg.environmentFiles;

        # Hardening
        ProtectHome = true;
        PrivateDevices = true;
        ProtectClock = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = true;
        ProtectKernelModules = true;
        ProtectHostname = true;
        ProtectKernelTunables = true;
        PrivateUsers = true;
        ProtectProc = "ptraceable";
        ProcSubset = "pid";
        RestrictRealtime = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX" # Required for JS os.homedir() function
        ];
        RestrictNamespaces = [
          # user, pid and net are required for the chromium-internal sandbox
          "~uts"
          "~mnt"
          "~cgroup"
          "~ipc"
        ];
        CapabilityBoundingSet = null;
        LockPersonality = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          # @privileged (partially implicity allowed) and @mount are required for the chromium-internal sandbox
          "@system-service"
          "@mount"
          "~@resources"
        ];
        SystemCallErrorNumber = "EPERM";
        UMask = "0077";
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ mynacol ];
}
