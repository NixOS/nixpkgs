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
    mkOption
    types
    mkIf
    ;

  defaultUser = "homebox";
  defaultGroup = "homebox";
in
{
  options.services.homebox = {
    enable = mkEnableOption "homebox";
    package = mkPackageOption pkgs "homebox" { };
    user = mkOption {
      type = types.str;
      default = defaultUser;
      description = "User account under which Homebox runs.";
    };
    group = mkOption {
      type = types.str;
      default = defaultGroup;
      description = "Group under which Homebox runs.";
    };
    settings = mkOption {
      type = types.submodule { freeformType = types.attrsOf (types.nullOr types.str); };
      defaultText = lib.literalExpression ''
        {
          HBOX_STORAGE_CONN_STRING = "file:///var/lib/homebox";
          HBOX_STORAGE_PREFIX_PATH = "data";
          HBOX_DATABASE_DRIVER = "sqlite3";
          HBOX_DATABASE_SQLITE_PATH = "/var/lib/homebox/data/homebox.db?_pragma=busy_timeout=999&_pragma=journal_mode=WAL&_fk=1";
          HBOX_OPTIONS_ALLOW_REGISTRATION = "false";
          HBOX_OPTIONS_CHECK_GITHUB_RELEASE = "false";
          HBOX_MODE = "production";
        }
      '';
      description = ''
        The homebox configuration as environment variables. For definitions and available options see the upstream
        [documentation](https://homebox.software/en/configure/#configure-homebox).
      '';
    };
    database = {
      createLocally = mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Configure local PostgreSQL database server for Homebox.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = !(cfg.settings ? HBOX_STORAGE_DATA);
        message = ''
          `services.homebox.settings.HBOX_STORAGE_DATA` has been deprecated.
          Please use `services.homebox.settings.HBOX_STORAGE_CONN_STRING` and `services.homebox.settings.HBOX_STORAGE_PREFIX_PATH` instead.
        '';
      }
    ];

    users = {
      users = mkIf (cfg.user == defaultUser) {
        ${defaultUser} = {
          description = "homebox service user";
          inherit (cfg) group;
          isSystemUser = true;
        };
      };
      groups = mkIf (cfg.group == defaultGroup) { ${defaultGroup} = { }; };
    };

    services.homebox.settings = lib.mkMerge [
      (lib.mapAttrs (_: mkDefault) {
        HBOX_STORAGE_CONN_STRING = "file:///var/lib/homebox";
        HBOX_STORAGE_PREFIX_PATH = "data";
        HBOX_DATABASE_DRIVER = "sqlite3";
        HBOX_DATABASE_SQLITE_PATH = "/var/lib/homebox/data/homebox.db?_pragma=busy_timeout=999&_pragma=journal_mode=WAL&_fk=1";
        HBOX_OPTIONS_ALLOW_REGISTRATION = "false";
        HBOX_OPTIONS_CHECK_GITHUB_RELEASE = "false";
        HBOX_MODE = "production";
      })

      (mkIf cfg.database.createLocally {
        HBOX_DATABASE_DRIVER = "postgres";
        HBOX_DATABASE_HOST = "/run/postgresql";
        HBOX_DATABASE_USERNAME = "homebox";
        HBOX_DATABASE_DATABASE = "homebox";
        HBOX_DATABASE_PORT = toString config.services.postgresql.settings.port;
      })
    ];

    services.postgresql = mkIf cfg.database.createLocally {
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
      environment = lib.filterAttrs (_: v: v != null) cfg.settings;
      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        ExecStart = lib.getExe cfg.package;
        LimitNOFILE = "1048576";
        PrivateTmp = true;
        PrivateDevices = true;
        Restart = "always";
        StateDirectory = "homebox";

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
  meta.maintainers = with lib.maintainers; [
    patrickdag
    swarsel
  ];
}
