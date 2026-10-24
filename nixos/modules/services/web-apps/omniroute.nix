{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.omniroute;
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
            nullOr (oneOf [
              str
              int
              bool
            ])
          );
          options = {
            DATA_DIR = lib.mkOption {
              type = lib.types.str;
              default = "/var/lib/omniroute";
              description = ''
                Directory for the database, backups and other files.
                Has to be made accessible via systemd, because the service runs as DynamicUser.
              '';
            };
            OMNIROUTE_SHOW_LOG = lib.mkOption {
              type = lib.types.str;
              default = "1";
              description = ''
                Whether to expose the service logs to the system journal.
              '';
            };
          };
        };
      description = ''
        Freeform attribute where all environment variables that Omniroute supports can be set.
        A full list is found at https://github.com/diegosouzapw/OmniRoute/blob/main/docs/reference/ENVIRONMENT.md
      '';
    };

    extraEnvironmentFiles = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = ''
        Additional files that are passed as environment variables.
        Useful for secrets.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.omniroute = {
      description = "OmniRoute AI gateway";
      documentation = [ "https://github.com/diegosouzapw/OmniRoute" ];
      wantedBy = [ "multi-user.target" ];

      environment = lib.mapAttrs (
        _: v:
        if v == null then
          null
        else if lib.isBool v then
          lib.boolToString v
        else
          toString v
      ) cfg.settings;

      serviceConfig = {
        Type = "exec";
        DynamicUser = true;

        StateDirectory = "omniroute";
        WorkingDirectory = cfg.settings.DATA_DIR;

        ExecStart = "${lib.getExe cfg.package} --no-open";
        Restart = "on-failure";

        EnvironmentFile = cfg.extraEnvironmentFiles;

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
          # @privileged and @mount are required for the chromium-internal sandbox
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
