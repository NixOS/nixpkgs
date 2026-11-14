#!/usr/bin/env bash

# Allow use of !() and ensure unmatched globs expand to empty
shopt -s extglob nullglob

# Based on: https://github.com/dani-garcia/vaultwarden/wiki/Backing-up-your-vault
if [ ! -d "$BACKUP_FOLDER" ]; then
  echo "Backup folder '$BACKUP_FOLDER' does not exist" >&2
  exit 1
fi

if [ ! -d "$DATA_FOLDER" ]; then
  echo "No data folder (yet). This will happen on first launch if backup is triggered before vaultwarden has started."
  exit 0
fi

if [[ -f "$DATA_FOLDER"/db.sqlite3 ]]; then
  if ! sqlite3 "$DATA_FOLDER"/db.sqlite3 ".backup '$BACKUP_FOLDER/db.sqlite3'"; then
    echo "Failed to backup Vaultwarden SQLite database" >&2
    exit 1
  fi
fi

extra_files=("$DATA_FOLDER"/!(db.*))
if [ ${#extra_files[@]} -gt 0 ]; then
  cp -r "${extra_files[@]}" "$BACKUP_FOLDER"/
fi
