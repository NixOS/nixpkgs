{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.mysqlBackup;
  defaultUser = "mysqlbackup";

  compressionPkg =
    {
      gzip = pkgs.gzip;
      xz = pkgs.xz;
      zstd = pkgs.zstd;
    }
    .${cfg.compressionAlg};

  fileExt =
    {
      gzip = ".gz";
      zstd = ".zst";
      xz = ".xz";
    }
    .${cfg.compressionAlg};

  validCompressionLevels = {
    zstd = range: 1 <= range && range <= 19;
    xz = range: 0 <= range && range <= 9;
    gzip = range: 1 <= range && range <= 9;
  };

  compressionCmd =
    let
      compressionLevelFlag = lib.optionalString (cfg.compressionLevel != null) (
        "-" + toString cfg.compressionLevel
      );
    in
    {
      gzip = "${pkgs.gzip}/bin/gzip -c ${cfg.gzipOptions} ${compressionLevelFlag}";
      xz = "${pkgs.xz}/bin/xz -z -c ${compressionLevelFlag} -";
      zstd = "${pkgs.zstd}/bin/zstd ${compressionLevelFlag} -";
    }
    .${cfg.compressionAlg};

  backupScript = ''
    set -o pipefail
    failed=""
    ${lib.concatMapStringsSep "\n" backupDatabaseScript cfg.databases}
    if [ -n "$failed" ]; then
      echo "Backup of database(s) failed:$failed"
      exit 1
    fi
  '';

  backupDatabaseScript = db: ''
    dest="${cfg.location}/${db}${fileExt}"
    if ${pkgs.mariadb}/bin/mysqldump ${lib.optionalString cfg.singleTransaction "--single-transaction"} ${db} | ${compressionCmd} > $dest.tmp; then
      mv $dest.tmp $dest
      echo "Backed up to $dest"
    else
      echo "Failed to back up to $dest"
      rm -f $dest.tmp
      failed="$failed ${db}"
    fi
  '';

in
{
  options = {
    services.mysqlBackup = {
      enable = lib.mkEnableOption "MySQL backups";

      calendar = lib.mkOption {
        type = lib.types.str;
        default = "01:15:00";
        description = ''
          Configured when to run the backup service systemd unit (DayOfWeek Year-Month-Day Hour:Minute:Second).
        '';
      };

      compressionAlg = lib.mkOption {
        type = lib.types.enum [
          "gzip"
          "zstd"
          "xz"
        ];
        default = "gzip";
        description = ''
          Compression algorithm to use for database dumps.
        '';
      };

      compressionLevel = lib.mkOption {
        type = lib.types.nullOr lib.types.int;
        default = null;
        description = ''
          Compression level to use for gzip, zstd or xz.
          For gzip: 1-9 (note: if compression level is also specified in gzipOptions, the gzipOptions value will be overwritten)
          For zstd: 1-19
          For xz: 0-9
        '';
      };

      user = lib.mkOption {
        type = lib.types.str;
        default = defaultUser;
        description = ''
          User to be used to perform backup.
        '';
      };

      databases = lib.mkOption {
        default = [ ];
        type = lib.types.listOf lib.types.str;
        description = ''
          List of database names to dump.
        '';
      };

      location = lib.mkOption {
        type = lib.types.path;
        default = "/var/backup/mysql";
        description = ''
          Location to put the compressed MySQL database dumps.
        '';
      };

      singleTransaction = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = ''
          Whether to create database dump in a single transaction
        '';
      };

      gzipOptions = lib.mkOption {
        default = "--no-name --rsyncable";
        type = lib.types.str;
        description = ''
          Command line options to use when invoking `gzip`.
          Only used when compression is set to "gzip".
          If compression level is specified both here and in compressionLevel, the compressionLevel value will take precedence.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    # assert config to be correct
    assertions = [
      {
        assertion =
          cfg.compressionLevel == null || validCompressionLevels.${cfg.compressionAlg} cfg.compressionLevel;
        message =
          let
            rangeMsg = {
              "zstd" = "zstd compression level must be between 1 and 19";
              "xz" = "xz compression level must be between 0 and 9";
              "gzip" = "gzip compression level must be between 1 and 9";
            };
          in
          rangeMsg.${cfg.compressionAlg};
      }
    ];

    # ensure unix user to be used to perform backup exist.
    users.users = lib.optionalAttrs (cfg.user == defaultUser) {
      ${defaultUser} = {
        isSystemUser = true;
        createHome = false;
        home = cfg.location;
        group = "nogroup";
      };
    };

    # add the compression tool to the system environment.
    environment.systemPackages = [ compressionPkg ];

    # ensure database user to be used to perform backup exist.
    services.mysql.ensureUsers = [
      {
        name = cfg.user;
        ensurePermissions =
          let
            privs = "SELECT, SHOW VIEW, TRIGGER, LOCK TABLES";
            grant = db: lib.nameValuePair "${db}.*" privs;
          in
          lib.listToAttrs (map grant cfg.databases);
      }
    ];

    systemd = {
      timers.mysql-backup = {
        description = "Mysql backup timer";
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnCalendar = cfg.calendar;
          AccuracySec = "5m";
          Unit = "mysql-backup.service";
        };
      };
      services.mysql-backup = {
        description = "MySQL backup service";
        enable = true;
        serviceConfig = {
          Type = "oneshot";
          User = cfg.user;
        };
        script = backupScript;
      };
      tmpfiles.rules = [
        "d ${cfg.location} 0700 ${cfg.user} - - -"
      ];
    };
  };
}
