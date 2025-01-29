#! /usr/bin/env nix-shell
#! nix-shell update-shell.nix -i bash

# Update script for the vscode versions and hashes.
# Usually doesn't need to be called by hand,
# but is called by a bot: https://github.com/samuela/nixpkgs-upkeep/actions
# Call it by hand if the bot fails to automatically update the versions.

set -eou pipefail

ROOT="$(dirname "$(readlink -f "$0")")"
if [ ! -f "$ROOT/vscode.nix" ]; then
    echo "ERROR: cannot find vscode.nix in $ROOT"
    exit 1
fi

# VSCode

VSCODE_VER=$(curl --fail --silent https://update.code.visualstudio.com/api/releases/stable | jq --raw-output .[0])
VSCODE_INSIDER_VER=$(curl --fail --silent https://update.code.visualstudio.com/api/releases/insider | jq --raw-output .[0])
sed -i "s/stableVersion = \".*\"/stableVersion = \"${VSCODE_VER}\"/" "$ROOT/vscode.nix"
sed -i "s/insiderVersion = \".*\"/insiderVersion = \"${VSCODE_INSIDER_VER}\"/" "$ROOT/vscode.nix"

TEMP_FOLDER=$(mktemp -d)

VSCODE_X64_LINUX_URL="https://update.code.visualstudio.com/${VSCODE_VER}/linux-x64/stable"

# Split output by newlines into Bash array
readarray -t VSCODE_X64_LINUX <<<"$(nix-prefetch-url --print-path "$VSCODE_X64_LINUX_URL")"

tar xf "${VSCODE_X64_LINUX[1]}" -C "$TEMP_FOLDER"
VSCODE_COMMIT=$(jq --raw-output .commit "$TEMP_FOLDER"/VSCode-linux-x64/resources/app/product.json)
sed -i "s/rev = \".\{40\}\"/rev = \"${VSCODE_COMMIT}\"/" "$ROOT/vscode.nix"

SERVER_X64_LINUX_URL="https://update.code.visualstudio.com/commit:${VSCODE_COMMIT}/server-linux-x64/stable"
SERVER_X64_LINUX_SHA256=$(nix-prefetch-url "$SERVER_X64_LINUX_URL")
sed -i "s/sha256 = \".\{51,52\}\"/sha256 = \"${SERVER_X64_LINUX_SHA256}\"/" "$ROOT/vscode.nix"

update_platform_hashes() {
    local channel=$1
    local version=$2

    # Linux x86
    VSCODE_X86_LINUX_URL="https://update.code.visualstudio.com/${version}/linux-x64/${channel}"
    VSCODE_X86_LINUX_SHA256=$(nix-prefetch-url "$VSCODE_X86_LINUX_URL")
    sed -i "s/${channel}\.x86_64-linux = \".\{52\}\"/${channel}.x86_64-linux = \"${VSCODE_X86_LINUX_SHA256}\"/" "$ROOT/vscode.nix"

    # Darwin x64
    VSCODE_X64_DARWIN_URL="https://update.code.visualstudio.com/${version}/darwin/${channel}"
    VSCODE_X64_DARWIN_SHA256=$(nix-prefetch-url "$VSCODE_X64_DARWIN_URL")
    sed -i "s/${channel}\.x86_64-darwin = \".\{52\}\"/${channel}.x86_64-darwin = \"${VSCODE_X64_DARWIN_SHA256}\"/" "$ROOT/vscode.nix"

    # Linux ARM64
    VSCODE_AARCH64_LINUX_URL="https://update.code.visualstudio.com/${version}/linux-arm64/${channel}"
    VSCODE_AARCH64_LINUX_SHA256=$(nix-prefetch-url "$VSCODE_AARCH64_LINUX_URL")
    sed -i "s/${channel}\.aarch64-linux = \".\{52\}\"/${channel}.aarch64-linux = \"${VSCODE_AARCH64_LINUX_SHA256}\"/" "$ROOT/vscode.nix"

    # Darwin ARM64
    VSCODE_AARCH64_DARWIN_URL="https://update.code.visualstudio.com/${version}/darwin-arm64/${channel}"
    VSCODE_AARCH64_DARWIN_SHA256=$(nix-prefetch-url "$VSCODE_AARCH64_DARWIN_URL")
    sed -i "s/${channel}\.aarch64-darwin = \".\{52\}\"/${channel}.aarch64-darwin = \"${VSCODE_AARCH64_DARWIN_SHA256}\"/" "$ROOT/vscode.nix"

    # Linux ARMHF
    VSCODE_ARMV7L_LINUX_URL="https://update.code.visualstudio.com/${version}/linux-armhf/${channel}"
    VSCODE_ARMV7L_LINUX_SHA256=$(nix-prefetch-url "$VSCODE_ARMV7L_LINUX_URL")
    sed -i "s/${channel}\.armv7l-linux = \".\{52\}\"/${channel}.armv7l-linux = \"${VSCODE_ARMV7L_LINUX_SHA256}\"/" "$ROOT/vscode.nix"
}

# Update stable hashes
update_platform_hashes "stable" "$VSCODE_VER"

# Update insiders hashes
update_platform_hashes "insider" "$VSCODE_INSIDER_VER"
