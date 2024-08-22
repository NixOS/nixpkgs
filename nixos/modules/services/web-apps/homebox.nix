{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.services.homebox;
  inherit (lib)
    mkEnableOption
    mkPackageOption
    mkDefault
    types
    mkIf
    ;
in
{
  options.services.homebox = {
    enable = mkEnableOption "homebox";
    package = mkPackageOption pkgs "homebox" { };
    settings = lib.mkOption {
      type = types.attrsOf types.str;
      defaultText = ''
        HBOX_STORAGE_DATA = "/var/lib/homebox/data";
        HBOX_STORAGE_SQLITE_URL = "/var/lib/homebox/data/homebox.db?_pragma=busy_timeout=999&_pragma=journal_mode=WAL&_fk=1";
        HBOX_OPTIONS_ALLOW_REGISTRATION = "false";
        HBOX_MODE = "production";
      '';
      description = ''
        The homebox configuration as Environment variables. For definitions and available options see the upstream
        [documentation](https://hay-kot.github.io/homebox/quick-start/#env-variables-configuration).
      '';
    };
  };

  config = mkIf cfg.enable {
    users.users.homebox = {
      isSystemUser = true;
      group = "homebox";
    };
    users.groups.homebox = { };
    services.homebox.settings = {
      HBOX_STORAGE_DATA = mkDefault "/var/lib/homebox/data";
      HBOX_STORAGE_SQLITE_URL = mkDefault "/var/lib/homebox/data/homebox.db?_pragma=busy_timeout=999&_pragma=journal_mode=WAL&_fk=1";
      HBOX_OPTIONS_ALLOW_REGISTRATION = mkDefault "false";
      HBOX_MODE = mkDefault "production";
    };
    systemd.services.homebox = {
      after = [ "network.target" ];
      environment = cfg.settings;
      serviceConfig = {
        User = "homebox";
        Group = "homebox";
        ExecStart = lib.getExe cfg.package;
        StateDirectory = "homebox";
        WorkingDirectory = "/var/lib/homebox";
        LimitNOFILE = "1048576";
        PrivateTmp = true;
        PrivateDevices = true;
        StateDirectoryMode = "0700";
        Restart = "always";

        # Hardening
        CapabilityBoundingSet = "";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
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
        ProtectSystem = "strict";
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_NETLINK"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "@pkey"
        ];
        RestrictSUIDSGID = true;
        PrivateMounts = true;
        UMask = "0077";
      };
      wantedBy = [ "multi-user.target" ];
    };
  };
  meta.maintainers = with lib.maintainers; [ patrickdag ];
}
