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
      defaultText = lib.literalExpression ''
        {
          HBOX_STORAGE_DATA = "/var/lib/homebox/data";
          HBOX_DATABASE_DRIVER = "sqlite3";
          HBOX_DATABASE_SQLITE_PATH = "/var/lib/homebox/data/homebox.db?_pragma=busy_timeout=999&_pragma=journal_mode=WAL&_fk=1";
          HBOX_OPTIONS_ALLOW_REGISTRATION = "false";
          HBOX_OPTIONS_CHECK_GITHUB_RELEASE = "false";
          HBOX_MODE = "production";
        }
      '';
      description = ''
        The homebox configuration as Environment variables. For definitions and available options see the upstream
        [documentation](https://homebox.software/en/configure/#configure-homebox).
      '';
    };
    database = {
      createLocally = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Configure local PostgreSQL database server for Homebox.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    users.users.homebox = {
      isSystemUser = true;
      group = "homebox";
    };
    users.groups.homebox = { };
    services.homebox.settings = lib.mkMerge [
      (lib.mapAttrs (_: mkDefault) {
        HBOX_STORAGE_DATA = "/var/lib/homebox/data";
        HBOX_DATABASE_DRIVER = "sqlite3";
        HBOX_DATABASE_SQLITE_PATH = "/var/lib/homebox/data/homebox.db?_pragma=busy_timeout=999&_pragma=journal_mode=WAL&_fk=1";
        HBOX_OPTIONS_ALLOW_REGISTRATION = "false";
        HBOX_OPTIONS_CHECK_GITHUB_RELEASE = "false";
        HBOX_MODE = "production";
      })

      (lib.mkIf cfg.database.createLocally {
        HBOX_DATABASE_DRIVER = "postgres";
        HBOX_DATABASE_HOST = "/run/postgresql";
        HBOX_DATABASE_USERNAME = "homebox";
        HBOX_DATABASE_DATABASE = "homebox";
        HBOX_DATABASE_PORT = toString config.services.postgresql.settings.port;
      })
    ];
    services.postgresql = lib.mkIf cfg.database.createLocally {
      enable = true;
      ensureDatabases = [ "homebox" ];
      ensureUsers = [
        {
          name = "homebox";
          ensureDBOwnership = true;
        }
      ];
    };
    systemd.services.homebox = {
      requires = lib.optional cfg.database.createLocally "postgresql.target";
      after = lib.optional cfg.database.createLocally "postgresql.target";
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
          "AF_UNIX"
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
