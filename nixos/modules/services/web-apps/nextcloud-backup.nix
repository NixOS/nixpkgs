{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.nextcloud;
  backupRsyncCommand = "${lib.getExe pkgs.rsync} -rlt --del --perms";
  restoreRsyncCommand = "${backupRsyncCommand} --chmod=u+rwX --chown=nextcloud:nextcloud";
  dbBackupRestore =
    if cfg.config.dbtype == "sqlite" then
      {
        # The sqlite database is automatically backed up since it's contained in the datadir
        backupFileName = "data/${cfg.config.dbname}.db";
        backupCommand = "";
        restoreCommand = "";
      }
    else if cfg.config.dbtype == "pgsql" then
      let
        backupFileName = "database-pgsql.bak";
        pg_dump = "${config.services.postgresql.package}/bin/pg_dump";
        pg_restore = "${config.services.postgresql.package}/bin/pg_restore";
        setPassword =
          if cfg.config.dbpassFile != null then
            ''
              export PGPASSWORD="$(cat ${cfg.config.dbpassFile})"
            ''
          else
            "";
        commonFlags = "-h ${cfg.config.dbhost} -U ${cfg.config.dbuser} --no-password";
      in
      {
        inherit backupFileName;
        backupCommand = ''
          ${setPassword}
          ${pg_dump} ${commonFlags} -F custom -f $1/nextcloud-backup/${backupFileName} ${cfg.config.dbname}
        '';
        restoreCommand = ''
          ${setPassword}
          sudo -E -u nextcloud ${pg_restore} ${commonFlags} --clean --if-exists -d ${cfg.config.dbname} $1/nextcloud-backup/${backupFileName}
        '';
      }
    else if cfg.config.dbtype == "mysql" then
      let
        backupFileName = "database-mysql.bak";
        mysqldump = "${config.services.mysql.package}/bin/mysqldump";
        mysql = "${config.services.mysql.package}/bin/mysql";
        # MySQL doesn't accept the socket path as a hostname
        hostFlag = if cfg.database.createLocally then "-h localhost" else "-h ${cfg.config.dbhost}";
        passwordFlag =
          if cfg.config.dbpassFile != null then
            ''
              -p "$(cat ${cfg.config.dbpassFile})"
            ''
          else
            "";
        commonFlags = hostFlag + " -u ${cfg.config.dbuser} " + passwordFlag;
      in
      {
        inherit backupFileName;
        backupCommand = ''
          ${mysqldump} ${commonFlags} --add-drop-table --single-transaction ${cfg.config.dbname} > $1/nextcloud-backup/${backupFileName}
        '';
        restoreCommand = ''
          sudo -u nextcloud ${mysql} ${commonFlags} ${cfg.config.dbname} < $1/nextcloud-backup/${backupFileName}
        '';
      }
    else
      throw "Unknown nextcloud database type ${cfg.config.dbtype}";
  checkBackup = ''
    for f in \
      "$1/nextcloud-backup/config.php" \
      "$1/nextcloud-backup/${dbBackupRestore.backupFileName}" \
      "$1/nextcloud-backup/store-apps" \
      "$1/nextcloud-backup/data"
    do
      if [ ! -e "$f" ] ;then
        echo "Did not find file $f."
        echo "It looks like the backup is incomplete, aborting."
        exit 1
      fi
    done
  '';
  backupScript = pkgs.writeShellScriptBin "nextcloud-backup" ''
    set -Eeuo pipefail
    if [ "$#" != "1" ] || [ "$1" = "-h" ] || [ "$1" = "--help" ] ;then
      echo "Usage: nextcloud-backup TARGET_DIR"
      echo "The backup will be created in TARGET_DIR/nextcloud-backup."
      exit 1
    fi
    if [ "$(id -un)" != "nextcloud" ] ;then
      echo "This script has to be run as the nextcloud user, aborting."
      exit 1
    fi
    # See https://docs.nextcloud.com/server/latest/admin_manual/maintenance/backup.html
    echo "Enabling maintenance mode..."
    ${lib.getExe cfg.occ} maintenance:mode --on
    echo "Copying config and manually installed apps..."
    mkdir -p $1/nextcloud-backup
    ${backupRsyncCommand} ${cfg.datadir}/config/config.php $1/nextcloud-backup
    ${backupRsyncCommand} ${cfg.home}/store-apps $1/nextcloud-backup
    echo "Copying data directory..."
    ${backupRsyncCommand} ${cfg.datadir}/data $1/nextcloud-backup
    echo "Dumping database..."
    ${dbBackupRestore.backupCommand}
    echo "Disabling maintenance mode..."
    ${lib.getExe cfg.occ} maintenance:mode --off
    ${lib.getExe pkgs.jq} --null-input \
      "{time: \"$(date --rfc-3339=seconds)\", nextcloudVersion: \"${cfg.package.version}\", databaseType: \"${cfg.config.dbtype}\"}" \
      >> $1/nextcloud-backup/metadata.json
    ${checkBackup}
    echo "Nextcloud backup completed."
  '';
  restoreScript = pkgs.writeShellScriptBin "nextcloud-restore" ''
    set -Eeuo pipefail
    if [ "$#" != "1" ] || [ "$1" = "-h" ] || [ "$1" = "--help" ] ;then
      echo "Usage: nextcloud-backup BACKUP_DIR"
      echo "Restore the backup contained in BACKUP_DIR/nextcloud-backup."
      echo "Note that this requires a working nextcloud installation which will then be overwritten."
      exit 1
    fi
    if [ "$(id -u)" != "0" ] ;then
      echo "This script has to be run as root, aborting."
      exit 1
    fi
    # Read backup metadata
    METADATA_FILE=$1/nextcloud-backup/metadata.json
    NEXTCLOUD_MAJOR_VERSION=$(${lib.getExe pkgs.jq} '.nextcloudVersion / "." | .[0] | tonumber' $METADATA_FILE)
    NEXTCLOUD_DB_TYPE=$(${lib.getExe pkgs.jq} --raw-output '.databaseType' $METADATA_FILE)
    # A few sanity checks to make sure that it's possible to restore the backup.
    if [ ! "$NEXTCLOUD_MAJOR_VERSION" = "${lib.versions.major cfg.package.version}" ] ;then
      echo "The backup is for Nextcloud $NEXTCLOUD_MAJOR_VERSION but Nextcloud ${lib.versions.major cfg.package.version} is installed."
      echo "Please change to Nextcloud $NEXTCLOUD_MAJOR_VERSION before restoring (and then possibly upgrade), aborting."
      exit 1
    fi
    if [ ! "$NEXTCLOUD_DB_TYPE" = "${cfg.config.dbtype}" ] ;then
      echo "The backup is for the database $NEXTCLOUD_DB_TYPE but the current installation uses ${cfg.config.dbtype}, aborting."
      exit 1
    fi
    ${checkBackup}
    if [ ! -e "${cfg.datadir}/config/override.config.php" ] ;then
      echo "Expected to find the file ${cfg.datadir}/config/override.config.php but it seems to be missing."
      echo "It appears that nextcloud has not been set up correctly, aborting."
      exit 1
    fi
    printf "WARNING: Restoring the backup will overwrite the current nextcloud instance. Continue? (y/n):"
    read answer
    if [ "$answer" = "''${answer#[Yy]}" ] ;then
        echo "Restore cancelled, aborting."
        exit 1
    fi
    echo "Enabling maintenance mode..."
    ${lib.getExe cfg.occ} maintenance:mode --on
    echo "Restoring config and manually installed apps..."
    ${restoreRsyncCommand} $1/nextcloud-backup/config.php ${cfg.datadir}/config/
    ${restoreRsyncCommand} $1/nextcloud-backup/store-apps ${cfg.home}
    echo "Restoring data directory..."
    ${restoreRsyncCommand} $1/nextcloud-backup/data ${cfg.datadir}
    echo "Restoring database..."
    ${dbBackupRestore.restoreCommand}
    echo "Disabling maintenance mode..."
    ${lib.getExe cfg.occ} maintenance:mode --off
    echo "Nextcloud backup successfully restored."
    echo "If the backup was not very recent, it might make sense to run \"nextcloud-occ maintenance:data-fingerprint\"."
    echo "See https://docs.nextcloud.com/server/latest/admin_manual/maintenance/restore.html#synchronising-with-clients-after-data-recovery for more information."
  '';
in
{
  options.services.nextcloudBackup = {
    backupScript = lib.mkOption {
      type = lib.types.package;
      default = backupScript;
      defaultText = lib.literalMD "generated script";
      internal = true;
      description = lib.mdDoc ''
        A script that backs up this Nextcloud instance to a given folder.
      '';
    };
    restoreScript = lib.mkOption {
      type = lib.types.package;
      default = restoreScript;
      defaultText = lib.literalMD "generated script";
      internal = true;
      description = lib.mdDoc ''
        A script that restores the Nextcloud instance from a given backup.
      '';
    };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      backupScript
      restoreScript
    ];
  };
}
