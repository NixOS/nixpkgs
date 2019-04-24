#!/usr/bin/env bash

# Based on: https://github.com/dani-garcia/bitwarden_rs/wiki/Backing-up-your-vault
if ! mkdir -p "$BACKUP_FOLDER"; then
  echo "Could not create backup folder '$BACKUP_FOLDER'" >&2
  exit 1
fi

if [[ ! -f "$DATA_FOLDER"/db.sqlite3 ]]; then
  echo "Could not find SQLite database file '$DATA_FOLDER/db.sqlite3'" >&2
  exit 1
fi

sqlite3 "$DATA_FOLDER"/db.sqlite3 ".backup '$BACKUP_FOLDER/db.sqlite3'"
cp "$DATA_FOLDER"/rsa_key.{der,pem,pub.der} "$BACKUP_FOLDER"
cp -r "$DATA_FOLDER"/attachments "$BACKUP_FOLDER"
cp -r "$DATA_FOLDER"/icon_cache "$BACKUP_FOLDER"
