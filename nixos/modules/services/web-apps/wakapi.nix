{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.services.wakapi;

  settingsFormat = pkgs.formats.yaml { };
  settingsFile = settingsFormat.generate "wakapi-settings" cfg.settings;

  inherit (lib)
    getExe
    mkOption
    mkEnableOption
    mkPackageOption
    types
    mkIf
    optional
    singleton
    mkRemovedOptionModule
    ;
in
{
  imports = [
    (mkRemovedOptionModule [
      "services"
      "wakapi"
      "passwordSalt"
    ] "Use services.wakapi.environmentFiles instead.")
    (mkRemovedOptionModule [
      "services"
      "wakapi"
      "passwordSaltFile"
    ] "Use services.wakapi.environmentFiles instead.")
    (mkRemovedOptionModule [
      "services"
      "wakapi"
      "smtpPassword"
    ] "Use services.wakapi.environmentFiles instead.")
    (mkRemovedOptionModule [
      "services"
      "wakapi"
      "smtpPasswordFile"
    ] "Use services.wakapi.environmentFiles instead.")
  ];

  options.services.wakapi = {
    enable = mkEnableOption "Wakapi";
    package = mkPackageOption pkgs "wakapi" { };
    stateDir = mkOption {
      type = types.path;
      default = "/var/lib/wakapi";
      description = ''
        The state directory where data is stored. Will also be used as the
        working directory for the wakapi service.
      '';
    };

    settings = mkOption {
      inherit (settingsFormat) type;
      default = { };
      description = ''
        Settings for Wakapi.

        See [config.default.yml](https://github.com/muety/wakapi/blob/master/config.default.yml) for a list of all possible options.
      '';
    };

    environmentFiles = mkOption {
      type = types.listOf types.path;
      default = [ ];
      description = ''
        Use this to set `WAKAPI_PASSWORD_SALT` and `WAKAPI_MAIL_SMTP_PASS`.
      '';
    };

    database = {
      createLocally = mkEnableOption ''
        automatic database configuration.

        ::: {.note}
        Only PostgreSQL is supported for the time being.
        :::
      '';

      dialect = mkOption {
        type = types.nullOr (
          types.enum [
            "postgres"
            "sqlite3"
            "mysql"
            "cockroach"
            "mssql"
          ]
        );
        default = cfg.settings.db.dialect or null; # handle case where dialect is not set
        defaultText = ''
          Database dialect from settings if {option}`services.wakatime.settings.db.dialect`
          is set, or `null` otherwise.
        '';
        description = ''
          The database type to use for Wakapi.
        '';
      };

      name = mkOption {
        type = types.str;
        default = cfg.settings.db.name or "wakapi";
        defaultText = ''
          Database name from settings if {option}`services.wakatime.settings.db.name`
          is set, or "wakapi" otherwise.
        '';
        description = ''
          The name of the database to use for Wakapi.
        '';
      };

      user = mkOption {
        type = types.str;
        default = cfg.settings.db.user or "wakapi";
        defaultText = ''
          User from settings if {option}`services.wakatime.settings.db.user`
          is set, or "wakapi" otherwise.
        '';
        description = ''
          The name of the user to use for Wakapi.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.wakapi = {
      description = "Wakapi (self-hosted WakaTime-compatible backend)";
      wants = [
        "network-online.target"
      ]
      ++ optional (cfg.database.dialect == "postgres") "postgresql.target";
      after = [
        "network-online.target"
      ]
      ++ optional (cfg.database.dialect == "postgres") "postgresql.target";
      wantedBy = [ "multi-user.target" ];

      script = ''
        exec ${getExe cfg.package} -config ${settingsFile}
      '';

      serviceConfig = {
        EnvironmentFile = cfg.environmentFiles;

        User = config.users.users.wakapi.name;
        Group = config.users.users.wakapi.group;

        DynamicUser = true;
        PrivateTmp = true;
        PrivateUsers = true;
        PrivateDevices = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectClock = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectControlGroups = true;
        NoNewPrivileges = true;
        ProtectProc = "invisible";
        ProtectSystem = "full";
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        CapabilityBoundingSet = "CAP_NET_BIND_SERVICE";
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        WorkingDirectory = cfg.stateDir;
        RuntimeDirectory = "wakapi";
        StateDirectory = "wakapi";
        StateDirectoryMode = "0700";
        Restart = "always";
      };
    };

    services.wakapi.settings = {
      env = lib.mkDefault "production";
    };

    assertions = [
      {
        assertion = cfg.database.createLocally -> cfg.settings.db.dialect != null;
        message = "`services.wakapi.database.createLocally` is true, but a database dialect is not set!";
      }
    ];

    warnings = [
      (lib.optionalString (cfg.database.createLocally && cfg.settings.db.dialect != "postgres") ''
        You have enabled automatic database configuration, but the database dialect is not set to "posgres".

        The Wakapi module only supports PostgreSQL. Please set `services.wakapi.database.createLocally`
        to `false`, or switch to "postgres" as your database dialect.
      '')
    ];

    users = {
      users.wakapi = {
        group = "wakapi";
        createHome = false;
        isSystemUser = true;
      };
      groups.wakapi = { };
    };

    services.postgresql = mkIf (cfg.database.createLocally && cfg.database.dialect == "postgres") {
      enable = true;

      ensureDatabases = singleton cfg.database.name;
      ensureUsers = singleton {
        name = cfg.settings.db.user;
        ensureDBOwnership = true;
      };

      authentication = ''
        host ${cfg.settings.db.name} ${cfg.settings.db.user} 127.0.0.1/32 trust
      '';
    };
  };

  meta.maintainers = with lib.maintainers; [
    isabelroses
    NotAShelf
  ];
}
