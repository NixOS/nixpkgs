#!/usr/bin/env bash
# Apply Tdarr node settings to NodeJSONDB via /api/v2/cruddb.
# Usage: tdarr-apply-node-db-config <server-url> <node-id> <node-updates-file> [node-config-path]

set -euo pipefail

if [ "$#" -lt 3 ]; then
  echo "usage: tdarr-apply-node-db-config <server-url> <node-id> <node-updates-file> [node-config-path]" >&2
  exit 1
fi

server_url="$1"
node_id="$2"
node_updates_file="$3"
node_config_path="${4:-}"

if [ ! -f "$node_updates_file" ]; then
  echo "node updates file not found: $node_updates_file" >&2
  exit 1
fi

log() {
  printf '%s\n' "$*"
}

log "Tdarr node config sync: waiting for server at ${server_url}"

# Wait for Tdarr server API.
for _ in $(seq 1 60); do
  if curl -sf --max-time 5 "$server_url/api/v2/status" >/dev/null; then
    break
  fi
  sleep 1
done

# Wait for node row to appear in NodeJSONDB.
for _ in $(seq 1 90); do
  payload_get="$(jq -cn --arg docID "$node_id" \
    '{data:{collection:"NodeJSONDB",mode:"getById",docID:$docID}}')"

  row="$(curl -sf --max-time 5 \
    -X POST "$server_url/api/v2/cruddb" \
    -H 'Content-Type: application/json' \
    --data "$payload_get" || echo '{}')"

  if [ "$row" != "{}" ] && [ "$row" != "null" ]; then
    break
  fi
  sleep 1
done

log "Tdarr node config sync: updating NodeJSONDB for ${node_id}"

# Build update payload safely using file
payload_update="$(jq -cn \
  --arg docID "$node_id" \
  --argfile obj "$node_updates_file" \
  '{data:{collection:"NodeJSONDB",mode:"update",docID:$docID,obj:$obj}}')"

curl -sf --max-time 10 \
  -X POST "$server_url/api/v2/cruddb" \
  -H 'Content-Type: application/json' \
  --data "$payload_update" >/dev/null

# Merge back into on-disk config if present
if [ -n "$node_config_path" ] && [ -f "$node_config_path" ]; then
  tmp_file="$(mktemp)"

  jq --argfile obj "$node_updates_file" \
    '. * $obj' \
    "$node_config_path" > "$tmp_file"

  mv "$tmp_file" "$node_config_path"

  log "Tdarr node config sync: merged desired values into ${node_config_path}"
fi
