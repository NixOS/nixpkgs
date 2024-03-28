{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.databacker-mysql-backup;

  defaultUser = "mysqlbackup";

  dumpTargetIsLocalDir =
    lib.isPath cfg.dumpTarget
    || lib.isString cfg.dumpTarget && builtins.substring 0 1 cfg.dumpTarget == "/";

  mysqlBackupEnvVars = lib.generators.toKeyValue {
    mkKeyValue = lib.flip lib.generators.mkKeyValueDefault "=" {
      mkValueString =
        v:
        if builtins.isInt v then
          toString v
        else if lib.isString v then
          "\"${v}\""
        else if true == v then
          "true"
        else if false == v then
          "false"
        else if null == v then
          ""
        else
          throw "unsupported type ${builtins.typeOf v}: ${(lib.generators.toPretty { }) v}";
    };
  };
  filteredConfig = lib.converge (lib.filterAttrsRecursive (
    _: v:
    !lib.elem v [
      { }
      null
    ]
  )) cfg.config;
  mysqlBackupEnv = pkgs.writeText "mysqlBackup.env" (mysqlBackupEnvVars filteredConfig);
in
{
  options = {
    services.databacker-mysql-backup = {
      enable = lib.mkEnableOption (lib.mdDoc "MySQL backups with databacker's mysql-backup");

      user = lib.mkOption {
        type = lib.types.str;
        default = defaultUser;
        description = lib.mdDoc ''
          User to be used to perform backup.
        '';
      };

      package = lib.mkPackageOption pkgs "mysql-backup" { };

      dumpTarget = lib.mkOption {
        type = lib.types.either lib.types.path lib.types.str;
        default = "/var/backup/mysql";
        example = ''
          /var/backup/mysql
          smb://hostname/share/path/
          s3://bucketname.fqdn.com/path
        '';
        description = lib.mdDoc ''
          Where to put the dump files. If a path or a string starting with /, then it will be treated as a local directory. Otherwise mysql-backup will treat it as a url (for example smb:// or s3://)
        '';
      };

      retention = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "3d";
        description = lib.mdDoc ''
          How long to keep the dumps. If null (the default), no pruning is done and all backups are kept.
          Refer to the [documentation](https://github.com/databacker/mysql-backup/blob/master/docs/prune.md) for the format.
        '';
      };

      databases = lib.mkOption {
        default = null;
        type = lib.types.nullOr (lib.types.listOf lib.types.str);
        description = lib.mdDoc ''
          List of database names to dump, or null to dump all databases (the default).
        '';
      };

      frequency = lib.mkOption {
        type = lib.types.nullOr lib.types.int;
        default = null;
        example = "60";
        description = lib.mdDoc ''
          How often to do a dump, in minutes.  Mutually exclusive with
          `services.databacker-mysql-backup.cron`.
        '';
      };

      begin = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "+10";
        description = lib.mdDoc ''
          What time to do the first dump. Must be in one of two formats: Absolute: HHMM,
          e.g. 2330 or `0415`; or Relative: +MM, i.e. how many minutes after starting the
          container, e.g. `+0` (immediate), `+10` (in 10 minutes), or `+90` in an hour and
          a half (default "+0") Mutually exclusive with
          `services.databacker-mysql-backup.cron`.

        '';
      };

      cron = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "15 1 * * *";
        description = lib.mdDoc ''
          Cron schedule for dumps and prunes.  Mutually exclusive with
          `services.databacker-mysql-backup.frequency` and `.begin`.
        '';
      };

      useLocalMySQL = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = lib.mdDoc ''
          Automatically connect to and use the local MySQL (managed by
          `services.mysql`). If set to false, you must provide connection and
          credentials.
        '';
      };

      localUserPrivs = lib.mkOption {
        type = lib.types.str;
        default = "SELECT, SHOW VIEW, TRIGGER, LOCK TABLES";
        description = lib.mdDoc ''
          Privileges to grant to the local MySQL user. Only relevant when
          `services.databacker-mysql-backup.useLocalMySQL` is set to `true`.
          Note that if `databases` is null (so all dbs should be backed up),
          then `SHOW DATABASES` will be automatically added to this list.
        '';
      };

      mysql = {
        host = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          example = "mysql.example.com";
          description = lib.mdDoc ''
            MySQL server to connect to.
            Only required when `services.databacker-mysql-backup.useLocalMySQL` is set to `false`.
          '';
        };

        port = lib.mkOption {
          type = lib.types.nullOr lib.types.port;
          default = 3306;
          description = lib.mdDoc ''
            MySQL server port to connect to.
            Only required when `services.databacker-mysql-backup.useLocalMySQL` is set to `false`.
          '';
        };

        user = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          example = "root";
          description = lib.mdDoc ''
            MySQL user to connect as.
            Only required when `services.databacker-mysql-backup.useLocalMySQL` is set to `false`.
          '';
        };

        passwordFile = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          default = null;
          example = "/run/secrets/mysql-backup-password";
          description = lib.mdDoc ''
            Path to a file containing the MySQL user's password.
            Only required when `services.databacker-mysql-backup.useLocalMySQL` is set to `false`.
          '';
        };
      };

      extraConfigFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        example = "/etc/mysql-backup/extra.yaml";
        description = lib.mdDoc ''
          Path to an extra configuration file for mysql-backup. This file will be included in the final configuration file alongside the other options.
        '';
      };

      configFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        example = "/etc/mysql-backup/config.yaml";
        description = lib.mdDoc ''
          Path to the configuration file for mysql-backup. Use this for complete control over the configuration. If set, all other options affecting the configuration will be ignored.
        '';
      };
      config = lib.mkOption {
        type = lib.types.attrsOf (
          lib.types.nullOr (
            lib.types.oneOf [
              lib.types.bool
              lib.types.int
              lib.types.port
              lib.types.path
              lib.types.str
            ]
          )
        );
        default = { };
        example = ''
          {
            DB_DUMP_COMPRESSION = "bzip2";
            DB_DUMP_DEBUG = true;
            DB_DUMP_NICE = 10;
          }
        '';
        description = lib.mdDoc ''
          Extra configuration for the mysql-backup service. Use the environment variable
          format described in the [mysql-backup
          documentation](https://github.com/databacker/mysql-backup/blob/master/docs/configuration.md)

          **WARNING**: This config will be writtten to the globally-readable nix store, so
          do not include secrets in it. Instead use
          `services.databacker-mysql-backup.extraConfigFile`.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions =
      let
        keyMatches = key: (builtins.match ".*access_key.*|.*secret.*|.*pass.*" (lib.toLower key)) != null;
        matchingKeys = lib.filter keyMatches (lib.attrNames cfg.config);
      in
      [
        {
          assertion = builtins.length matchingKeys == 0;
          message = "You have keys in `services.databacker-mysql-backup.config` that look like they might be secrets. Please use `services.databacker-mysql-backup.extraConfigFile` instead.";
        }
        {
          assertion = (cfg.frequency != null) -> cfg.frequency >= 1;
          message = "The `services.databacker-mysql-backup.frequency` must be 1 or greater";
        }
        {
          assertion = cfg.configFile == null -> (cfg.cron != null) != (cfg.frequency != null);
          message = "You must set one of `services.databacker-mysql-backup.cron` or both `.frequency` and `begin`.";
        }
        {
          assertion = (cfg.cron != null) -> cfg.frequency == null && cfg.begin == null;
          message = "You cannot set both `services.databacker-mysql-backup.cron` and `frequency`/`begin`";
        }
        {
          assertion = (cfg.frequency != null) -> cfg.begin != null;
          message = "If you set `services.databacker-mysql-backup.frequency` you also need to set `.begin`";
        }
        {
          assertion = (cfg.begin != null) -> cfg.frequency != null;
          message = "If you set `services.databacker-mysql-backup.begin` you also need to set `.frequency`";
        }
        {
          assertion = !(cfg.configFile != null && cfg.extraConfigFile != null);
          messsage = "You cannot set both `services.databacker-mysql-backup.configFile` and `services.databacker-mysql-backup.extraConfigFile` at the same time.";
        }
        {
          assertion =
            cfg.useLocalMySQL
            -> (cfg.mysql.host == null && cfg.mysql.user == null && cfg.mysql.passwordFile == null);
          message = "If `services.databacker-mysql-backup.useLocalMySQL` is set to `true`, you must not set an options under `services.databacker-mysql-backup.mysql.*`.";
        }
        {
          assertion =
            !cfg.useLocalMySQL
            -> (cfg.mysql.host != null && cfg.mysql.user != null && cfg.mysql.passwordFile != null);
          message = "If `services.databacker-mysql-backup.useLocalMySQL` is set to `true`, you must not set an options under `services.databacker-mysql-backup.mysql.*`.";
        }
      ];

    users.users = lib.optionalAttrs (cfg.user == defaultUser) {
      ${defaultUser} = {
        isSystemUser = true;
        createHome = false;
        group = "nogroup";
      };
    };

    services.mysql = lib.mkIf cfg.useLocalMySQL {
      ensureUsers = [
        {
          name = cfg.user;
          ensurePermissions =
            let
              grant = db: lib.nameValuePair "${db}.*" cfg.localUserPrivs;
            in
            if cfg.databases == null then
              { "*.*" = cfg.localUserPrivs + ", SHOW DATABASES"; }
            else
              lib.listToAttrs (map grant cfg.databases);
        }
      ];
    };

    services.databacker-mysql-backup.config =
      lib.optionalAttrs (cfg.configFile == null) {
        DB_DUMP_TARGET = cfg.dumpTarget;
        DB_NAMES = if cfg.databases == null then "" else lib.concatStringsSep "," cfg.databases;
      }
      // lib.optionalAttrs (cfg.cron != null) { DB_DUMP_CRON = cfg.cron; }
      // lib.optionalAttrs (cfg.frequency != null) {
        DB_DUMP_FREQ = cfg.frequency;
        DB_DUMP_BEGIN = cfg.begin;
      }
      // lib.optionalAttrs (cfg.retention != null) { RETENTION = cfg.retention; }
      // (
        if cfg.useLocalMySQL then
          {
            DB_SERVER = "/run/mysqld/mysqld.sock";
            DB_USER = cfg.user;
          }
        else
          {
            DB_SERVER = cfg.mysql.host;
            DB_PORT = toString cfg.mysql.port;
            DB_USER = cfg.mysql.user;
          }
      );

    systemd.services.databacker-mysql-backup = {
      description = "MySQL Backup Service from databacker";
      enable = true;
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ] ++ lib.optional cfg.useLocalMySQL "mysql.service";
      requires = lib.optional cfg.useLocalMySQL "mysql.service";
      serviceConfig = {
        EnvironmentFile = mysqlBackupEnv;
        User = cfg.user;
        Restart = "on-failure";
        RestartSec = "5s";
        ReadWritePaths = lib.optional dumpTargetIsLocalDir cfg.dumpTarget;
        CapabilityBoundingSet = "";
        NoNewPrivileges = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectHostname = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;
        RestrictAddressFamilies = [
          "AF_UNIX"
          "AF_INET"
          "AF_INET6"
        ];
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        PrivateMounts = true;
        SystemCallArchitectures = "native";
        LoadCredential =
          [ ]
          ++ lib.optionals (cfg.mysql.passwordFile != null) [ "DB_PASS:${cfg.mysql.passwordFile}" ];
      };
      script =
        let
          # is there a better way to get the first non-null value?
          activeConfigFile = lib.foldr (x: y: if x != null then x else y) null [
            cfg.configFile
            cfg.extraConfigFile
          ];
          args = lib.optionalString (activeConfigFile != null) (
            lib.escapeShellArgs [
              "--config-file"
              activeConfigFile
            ]
          );
        in
        ''
          if [ -d "$CREDENTIALS_DIRECTORY" ]; then
            for file in "$CREDENTIALS_DIRECTORY"/*; do
                if [ ! -f "$file" ]; then
                    continue
                fi
                filename=$(basename -- "$file")
                content=$(cat "$file")
                # Export an environment variable with the name of the file and content as its value
                declare "$filename=$content"
                export "$filename"
            done
          fi
          env
          ${lib.getExe cfg.package} dump ${args}
        '';
    };
    systemd.tmpfiles = lib.mkIf dumpTargetIsLocalDir {
      rules = [ "d ${cfg.dumpTarget} 0700 ${cfg.user} - - -" ];
    };
  };
}
