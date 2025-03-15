# Nextcloud backup script, based on https://docs.nextcloud.com/server/latest/admin_manual/maintenance/backup.html.
if [ "$#" -gt "0" ] ;then
  if [ "$1" = "-h" ] || [ "$1" = "--help" ] ;then
    echo "Usage: nextcloud-backup [BACKUP_DIR]"
    echo "The backup will be created under 'options.services.nextcloudBackup.backupDir' unless BACKUP_DIR is given."
    exit 1
  fi
fi
if [ "$(id -un)" != "nextcloud" ] ;then
  echo "This script has to be run as the nextcloud user, aborting."
  exit 1
fi
if [ "$#" = "1" ] ;then
  BACKUP_DIR="$1"
fi
if [ ! -d "$BACKUP_DIR" ] ;then
  echo "The backup directory '$BACKUP_DIR' does not exist, aborting."
  exit 1
fi

echo "Enabling maintenance mode..."
nextcloud-occ maintenance:mode --on
echo "Copying config and manually installed apps..."
mkdir -p "$BACKUP_DIR/nextcloud-backup"
rsync -rlt --del --perms "$NEXTCLOUD_DATADIR/config/config.php" "$BACKUP_DIR/nextcloud-backup"
rsync -rlt --del --perms "$NEXTCLOUD_HOME/store-apps" "$BACKUP_DIR/nextcloud-backup"
echo "Copying data directory..."
rsync -rlt --del --perms "$NEXTCLOUD_DATADIR/data" "$BACKUP_DIR/nextcloud-backup"

echo "Dumping $NEXTCLOUD_DBTYPE database..."
if [ ! "$NEXTCLOUD_DBPASS_FILE" = "" ] ;then
  NEXTCLOUD_DBPASS=$(cat "$NEXTCLOUD_DBPASS_FILE")
else
  NEXTCLOUD_DBPASS=""
fi
if [ "$NEXTCLOUD_DBTYPE" = "sqlite" ] ;then
  DB_BACKUP_NAME="database-sqlite.bak"
  sqlite3 "$NEXTCLOUD_DATADIR/data/$NEXTCLOUD_DBNAME.db" .dump > "$BACKUP_DIR/nextcloud-backup/$DB_BACKUP_NAME"
elif [ "$NEXTCLOUD_DBTYPE" = "pgsql" ] ;then
  DB_BACKUP_NAME="database-pgsql.bak"
  args=(
    -h "$NEXTCLOUD_DBHOST"
    -U "$NEXTCLOUD_DBUSER"
    --no-password -F custom
    -f "$BACKUP_DIR/nextcloud-backup/$DB_BACKUP_NAME"
    "$NEXTCLOUD_DBNAME"
  )
  PGPASSWORD="$NEXTCLOUD_DBPASS" pg_dump "${args[@]}"
elif [ "$NEXTCLOUD_DBTYPE" = "mysql" ] ;then
  DB_BACKUP_NAME="database-mysql.bak"
  args=(
    -h "$NEXTCLOUD_DBHOST"
    -u "$NEXTCLOUD_DBUSER"
  )
  if [ ! "$NEXTCLOUD_DBPASS" = "" ] ;then
    args+=(-p "$NEXTCLOUD_DBPASS")
  fi
  args+=(
    --add-drop-table
    --single-transaction
    "$NEXTCLOUD_DBNAME"
  )
  mysqldump "${args[@]}" > "$BACKUP_DIR/nextcloud-backup/$DB_BACKUP_NAME"
fi

echo "Disabling maintenance mode..."
nextcloud-occ maintenance:mode --off
jq --null-input \
  "{time: \"$(date --rfc-3339=seconds)\", nextcloudVersion: \"$NEXTCLOUD_VERSION\", databaseType: \"$NEXTCLOUD_DBTYPE\"}" \
  > "$BACKUP_DIR/nextcloud-backup/metadata.json"

# Check that the backup seems complete
for f in \
  "$BACKUP_DIR/nextcloud-backup/config.php" \
  "$BACKUP_DIR/nextcloud-backup/$DB_BACKUP_NAME" \
  "$BACKUP_DIR/nextcloud-backup/store-apps" \
  "$BACKUP_DIR/nextcloud-backup/data"
do
  if [ ! -e "$f" ] ;then
    echo "Did not find file $f."
    echo "It looks like the backup is incomplete, aborting."
    exit 1
  fi
done
echo "Successfully created backup in $BACKUP_DIR/nextcloud-backup."
