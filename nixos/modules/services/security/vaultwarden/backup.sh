#!/usr/bin/env bash

# Allow use of !() when copying to not copy certain files
shopt -s extglob

# Based on: https://github.com/dani-garcia/vaultwarden/wiki/Backing-up-your-vault
if [ ! -d "$BACKUP_FOLDER" ]; then
  echo "Backup folder '$BACKUP_FOLDER' does not exist" >&2
  exit 1
fi

if [[ -f "$DATA_FOLDER"/db.sqlite3 ]]; then
  sqlite3 "$DATA_FOLDER"/db.sqlite3 ".backup '$BACKUP_FOLDER/db.sqlite3'"
fi

if [ ! -d "$DATA_FOLDER" ]; then
  echo "No data folder (yet). This will happen on first launch if backup is triggered before vaultwarden has started."
  exit 0
fi

cp -r "$DATA_FOLDER"/!(db.*) "$BACKUP_FOLDER"/
