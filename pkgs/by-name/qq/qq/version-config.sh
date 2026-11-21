if [[ -z "${INTERNAL_VERSION:-}" ]]; then
  echo "INTERNAL_VERSION is not set, skipping version config management"
  exit 0
fi

CONFIG_PATH="$HOME/.config/QQ/versions/config.json"
CONFIG_DIR="$(dirname "$CONFIG_PATH")"

if [[ ! -f "$CONFIG_PATH" ]]; then
  if [[ ! -d "$CONFIG_DIR" ]]; then
    echo "Creating QQ version config directory at $CONFIG_DIR"
    mkdir -p "$CONFIG_DIR"
  fi
else
  baseVersion=$(sed -n 's/.*"baseVersion"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' "$CONFIG_PATH")
  currentVersion=$(sed -n 's/.*"curVersion"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' "$CONFIG_PATH")

  # Here we assert that the buildId is the same as baseVersion's buildId and skip checking it separately
  if [[ "$baseVersion" == "$INTERNAL_VERSION" && "$currentVersion" == "$INTERNAL_VERSION" ]]; then
    echo "Version config file already up to date"

    if [[ -w "$CONFIG_PATH" ]]; then
      echo "Making existing version config file read-only"
      chmod u-w "$CONFIG_PATH"
    fi

    exit 0
  fi

  if [[ ! -w "$CONFIG_PATH" ]]; then
    echo "Making existing version config file writable temporarily"
    chmod u+w "$CONFIG_PATH"
  fi
fi

cat > "$CONFIG_PATH" << EOF
{
  "_comment": "This file is managed by the qq-version-config.sh to disable auto updates, do not edit it manually. Set the \`disableAutoUpdate\` option to false to disable this behavior.",
  "baseVersion": "$INTERNAL_VERSION",
  "curVersion": "$INTERNAL_VERSION",
  "buildId": "${INTERNAL_VERSION##*-}"
}
EOF

chmod u-w "$CONFIG_PATH"
