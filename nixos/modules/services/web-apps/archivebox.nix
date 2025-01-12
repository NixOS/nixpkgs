{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.archivebox;

  inherit (lib) mkOption types;
in
{
  options.services.archivebox = {
    enable = lib.mkEnableOption "ArchiveBox, open source self-hosted web archiving";

    package = lib.mkPackageOption pkgs "archivebox" { };

    settings = mkOption {
      type =
        with types;
        submodule {
          freeformType = attrsOf (
            nullOr (oneOf [
              bool
              int
              str
            ])
          );
          options = { };
        };
      default = { };
      description = ''
        Configuration settings for ArchiveBox.

        In version 0.8.0+ of ArchiveBox, the configuration was changed. Since ArchiveBox is now a plugin-based system, the configuration is no longer centralized.
        Therefore, to find plugin settings, go to `archivebox/pkgs` in the [upstream git repo](https://github.com/ArchiveBox/ArchiveBox) to look for plugin settings,
        or `archivebox/config/common.py` in the same repo for serverwide settings.

        Settings here are named the same as their environment variables, for simplicity. There are more than the settings documented here, the ones here are needed for other functions in the module.
      '';
    };

    environmentFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        An additional file with environment variables to load into the ArchiveBox service.
        This should be used for secret variables, such as the `SECRET_KEY` and `ADMIN_PASSWORD`.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    # Needs a persistant user since it stores the archived data
    users.users.archivebox = {
      isSystemUser = true;
      group = "archivebox";
    };
    users.groups.archivebox = { };

    systemd.services.archivebox = {
      after = [ "network.target" ];
      serviceConfig = {
        User = "archivebox";
        Group = "archivebox";
        StateDirectory = "archivebox";
        Environment = lib.mapAttrsToList (k: v: "${k}=${v}") (
          lib.filterAttrs (_: v: v != null) cfg.settings
        );

        ExecStartPre = "${lib.getExe cfg.package} install";
        ExecStart = "${lib.getExe cfg.package} server";

        # Hardening options
        PrivateDevices = true;
        PrivateIPC = true;
        PrivateUsers = true;

        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProcSubset = "pid";

        RestrictAddressFamilies = [
          "AF_UNIX"
          "AF_INET"
          "AF_INET6"
          "AF_NETLINK"
        ];
        RestrictRealtime = true;

        LockPersonality = true;

        SystemCallFilter = [
          "@system-service"
          "~@privileged"
        ];
        SystemCallArchitectures = "native";

        # These break Chromium-based extractors, so they are disabled.
        MemoryDenyWriteExecute = false;
        RestrictNamespaces = false;
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ pyrox0 ];
}
