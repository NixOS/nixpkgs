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
    mkMerge
    singleton
    ;
in
{
  options.services.wakapi = {
    enable = mkEnableOption "Wakapi";
    package = mkPackageOption pkgs "wakapi" { };

    settings = mkOption {
      inherit (settingsFormat) type;
      default = { };
      description = ''
        Settings for Wakapi.

        See [config.default.yml](https://github.com/muety/wakapi/blob/master/config.default.yml) for a list of all possible options.
      '';
    };

    passwordSalt = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        The password salt to use for Wakapi.
      '';
    };
    passwordSaltFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        The path to a file containing the password salt to use for Wakapi.
      '';
    };

    smtpPassword = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        The password used for the smtp mailed to used by Wakapi.
      '';
    };
    smtpPasswordFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        The path to a file containing the password for the smtp mailer used by Wakapi.
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
      ] ++ optional (cfg.database.dialect == "postgres") "postgresql.service";
      after = [
        "network-online.target"
      ] ++ optional (cfg.database.dialect == "postgres") "postgresql.service";
      wantedBy = [ "multi-user.target" ];

      script = ''
        exec ${getExe cfg.package} -config ${settingsFile}
      '';

      serviceConfig = {
        Environment = mkMerge [
          (mkIf (cfg.passwordSalt != null) "WAKAPI_PASSWORD_SALT=${cfg.passwordSalt}")
          (mkIf (cfg.smtpPassword != null) "WAKAPI_MAIL_SMTP_PASS=${cfg.smtpPassword}")
        ];
        EnvironmentFile = [
          (optional (cfg.passwordSaltFile != null) cfg.passwordSaltFile)
          (optional (cfg.smtpPasswordFile != null) cfg.smtpPasswordFile)
        ];

        User = config.users.users.wakapi.name;
        Group = config.users.users.wakapi.group;

        DynamicUser = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
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
        assertion = cfg.passwordSalt != null || cfg.passwordSaltFile != null;
        message = "Either `services.wakapi.passwordSalt` or `services.wakapi.passwordSaltFile` must be set.";
      }
      {
        assertion = cfg.passwordSalt != null -> cfg.passwordSaltFile != null;
        message = "Both `services.wakapi.passwordSalt` `services.wakapi.passwordSaltFile` should not be set at the same time.";
      }
      {
        assertion = cfg.smtpPassword != null -> cfg.smtpPasswordFile != null;
        message = "Both `services.wakapi.smtpPassword` `services.wakapi.smtpPasswordFile` should not be set at the same time.";
      }
      {
        assertion = cfg.db.createLocally -> cfg.db.dialect != null;
        message = "`services.wakapi.database.createLocally` is true, but a database dialect is not set!";
      }
    ];

    warnings = [
      (lib.optionalString (cfg.db.createLocall -> cfg.db.dialect != "postgres") ''
        You have enabled automatic database configuration, but the database dialect is not set to "posgres".

        The Wakapi module only supports for PostgreSQL. Please set `services.wakapi.database.createLocally`
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
