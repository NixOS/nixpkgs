{
  writeShellScript,
  lib,
  curl,
  git,
  jq,
  yq,
  nix-update,
}:

writeShellScript "update-esphome-device-builder" ''
  set -euo pipefail

  PATH=${
    lib.makeBinPath [
      curl
      git
      jq
      yq
      nix-update
    ]
  }

  LATEST=$(curl https://api.github.com/repos/esphome/device-builder/releases/latest | jq -r '.name')
  echo "Latest version: $LATEST"

  FRONTEND_VERSION=$(curl https://raw.githubusercontent.com/esphome/device-builder/$LATEST/pyproject.toml | \
    tomlq -r '.project.dependencies|.[]|select(startswith("esphome-device-builder-frontend"))|match("[0-9.]+").string')

  echo "Frontend version: $FRONTEND_VERSION"

  nix-update esphome-device-builder.frontend --version $FRONTEND_VERSION
  nix-update esphome-device-builder --version $LATEST
''
