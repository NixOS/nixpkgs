# Nextcloud restore script, based on https://docs.nextcloud.com/server/latest/admin_manual/maintenance/restore.html.
if [ "$#" != "1" ] || [ "$1" = "-h" ] || [ "$1" = "--help" ] ;then
  echo "Usage: nextcloud-restore BACKUP_DIR"
  echo "Restore the backup contained in BACKUP_DIR/nextcloud-backup."
  echo "Note that this requires a working nextcloud installation which will then be overwritten."
  exit 1
fi
if [ "$(id -u)" != "0" ] ;then
  echo "This script has to be run as root, aborting."
  exit 1
fi
BACKUP_DIR="$1"

# Read backup metadata
METADATA_FILE="$BACKUP_DIR/nextcloud-backup/metadata.json"
NEXTCLOUD_MAJOR_VERSION=$(echo "$NEXTCLOUD_VERSION" | jq --raw-input --raw-output '. / "." | .[0] | tonumber')
BACKUP_NEXTCLOUD_MAJOR_VERSION=$(jq '.nextcloudVersion / "." | .[0] | tonumber' "$METADATA_FILE")
BACKUP_NEXTCLOUD_DBTYPE=$(jq --raw-output '.databaseType' "$METADATA_FILE")
# A few sanity checks to make sure that it's possible to restore the backup.
if [ ! "$BACKUP_NEXTCLOUD_MAJOR_VERSION" = "$NEXTCLOUD_MAJOR_VERSION" ] ;then
  echo "The backup is for Nextcloud $BACKUP_NEXTCLOUD_MAJOR_VERSION but Nextcloud $NEXTCLOUD_VERSION is installed."
  echo "Please change to Nextcloud $BACKUP_NEXTCLOUD_MAJOR_VERSION before restoring (and then possibly upgrade), aborting."
  exit 1
fi
if [ ! "$BACKUP_NEXTCLOUD_DBTYPE" = "$NEXTCLOUD_DBTYPE" ] ;then
  echo "The backup is for the database $BACKUP_NEXTCLOUD_DBTYPE but the current installation uses $NEXTCLOUD_DBTYPE, aborting."
  exit 1
fi

# Check that the backup seems complete
if [ "$NEXTCLOUD_DBTYPE" = "sqlite" ] ;then
  DB_BACKUP_NAME="database-sqlite.bak"
elif [ "$NEXTCLOUD_DBTYPE" = "pgsql" ]; then
  DB_BACKUP_NAME="database-pgsql.bak"
elif [ "$NEXTCLOUD_DBTYPE" = "mysql" ]; then
  DB_BACKUP_NAME="database-mysql.bak"
fi
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

if [ ! -e "$NEXTCLOUD_DATADIR/config/override.config.php" ] ;then
  echo "Expected to find the file $NEXTCLOUD_DATADIR/config/override.config.php but it seems to be missing."
  echo "It appears that nextcloud has not been set up correctly, aborting."
  exit 1
fi
printf "WARNING: Restoring the backup will overwrite the current nextcloud instance. Continue? (y/n):"
read -r answer
if [ "$answer" = "${answer#[Yy]}" ] ;then
    echo "Restore cancelled, aborting."
    exit 1
fi

echo "Enabling maintenance mode..."
nextcloud-occ maintenance:mode --on
echo "Restoring config and manually installed apps..."
rsync -rlt --del --perms --chmod=u+rwX --chown=nextcloud:nextcloud "$BACKUP_DIR/nextcloud-backup/config.php" "$NEXTCLOUD_DATADIR/config/"
rsync -rlt --del --perms --chmod=u+rwX --chown=nextcloud:nextcloud "$BACKUP_DIR/nextcloud-backup/store-apps" "$NEXTCLOUD_HOME"
echo "Restoring data directory..."
rsync -rlt --del --perms --chmod=u+rwX --chown=nextcloud:nextcloud "$BACKUP_DIR/nextcloud-backup/data" "$NEXTCLOUD_DATADIR"
echo "Restoring $NEXTCLOUD_DBTYPE database..."
if [ "$NEXTCLOUD_DBPASS_FILE" != "" ] ;then
  NEXTCLOUD_DBPASS=$(cat "$NEXTCLOUD_DBPASS_FILE")
else
  NEXTCLOUD_DBPASS=""
fi
if [ "$NEXTCLOUD_DBTYPE" = "sqlite" ] ;then
  if [ -e "$NEXTCLOUD_DATADIR/data/$NEXTCLOUD_DBNAME.db" ] ;then
    rm "$NEXTCLOUD_DATADIR/data/$NEXTCLOUD_DBNAME.db"
  fi
  sqlite3 "$NEXTCLOUD_DATADIR/data/$NEXTCLOUD_DBNAME.db" < "$BACKUP_DIR/nextcloud-backup/$DB_BACKUP_NAME"
  chown nextcloud:nextcloud "$NEXTCLOUD_DATADIR/data/$NEXTCLOUD_DBNAME.db"
  chmod u+rw "$NEXTCLOUD_DATADIR/data/$NEXTCLOUD_DBNAME.db"
elif [ "$NEXTCLOUD_DBTYPE" = "pgsql" ] ;then
  args=(
    -h "$NEXTCLOUD_DBHOST"
    -U "$NEXTCLOUD_DBUSER"
    --no-password
    --clean --if-exists
    -d "$NEXTCLOUD_DBNAME"
    "$BACKUP_DIR/nextcloud-backup/$DB_BACKUP_NAME"
  )
  PGPASSWORD="$NEXTCLOUD_DBPASS" sudo -E -u nextcloud pg_restore "${args[@]}"
elif [ "$NEXTCLOUD_DBTYPE" = "mysql" ] ;then
  args=(
    -h "$NEXTCLOUD_DBHOST"
    -u "$NEXTCLOUD_DBUSER"
  )
  if [ ! "$NEXTCLOUD_DBPASS" = "" ] ;then
    args+=(-p "$NEXTCLOUD_DBPASS")
  fi
  args+=("$NEXTCLOUD_DBNAME")
  # Shellcheck prints a warning that this reads the backup file as the root and not as the nextcloud user
  # shellcheck disable=SC2024
  sudo -u nextcloud mysql "${args[@]}" < "$BACKUP_DIR/nextcloud-backup/$DB_BACKUP_NAME"
fi
echo "Disabling maintenance mode..."
nextcloud-occ maintenance:mode --off
echo "Nextcloud backup successfully restored."
echo "If the backup was not very recent, it might make sense to run \"nextcloud-occ maintenance:data-fingerprint\"."
echo "See https://docs.nextcloud.com/server/latest/admin_manual/maintenance/restore.html#synchronising-with-clients-after-data-recovery for more information."
