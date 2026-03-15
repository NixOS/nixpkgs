#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i bash -p bash nix curl coreutils jq common-updater-scripts

set -eou pipefail

ROOT="$(dirname "$(readlink -f "$0")")"

latest=$(curl ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} -sL https://api.github.com/repos/AChep/keyguard-app/releases/latest)
latestTag=$(echo "$latest" | jq -r ".tag_name")
latestName=$(echo "$latest" | jq -r ".name")
latestVersion=$(echo "$latestName" | awk -F'v|-' '{print $2}')

currentVersion=$(nix-instantiate --eval -E "with import ./. {}; keyguard.version" | tr -d '"')

echo "latest  version: $latestVersion"
echo "current version: $currentVersion"

if [[ "$latestVersion" == "$currentVersion" ]]; then
    echo "package is up-to-date"
    exit 0
fi

hash=$(nix --extra-experimental-features nix-command hash convert --hash-algo sha256 --to sri $(nix-prefetch-url --unpack "https://github.com/AChep/keyguard-app/archive/refs/tags/${latestTag}.tar.gz"))
update-source-version keyguard $latestVersion $hash

sed -i 's/tag = "r[0-9]\+\(\.[0-9]\+\)\?";/tag = "'"$latestTag"'";/g' "$ROOT/package.nix"

# Update cargoHash for ssh-agent
sed -i -E 's|cargoHash = "[^"]*"|cargoHash = ""|' "$ROOT/ssh-agent.nix"
cargoHash=$( (nix-build -A keyguard.passthru.sshAgent 2>&1 || true) | awk '/got/{print $2}')
if [ -n "$cargoHash" ]; then
  sed -i -E 's|cargoHash = "[^"]*"|cargoHash = "'"$cargoHash"'"|' "$ROOT/ssh-agent.nix"
else
  echo "Failed to get cargoHash for ssh-agent, please update it manually"
fi

# Full build for host arch — captures all deps including build-time-only ones
"$(nix-build -A keyguard.mitmCache.updateScript)"

# Supported JVM os.arch values for linux desktop
ARCHS=("amd64" "aarch64")

# Map host uname -m to JVM os.arch
hostJvmArch=$(uname -m)
case "$hostJvmArch" in
  x86_64)  hostJvmArch="amd64" ;;
  aarch64) ;;  # already matches JVM convention
  *)       echo "Unsupported host architecture: $hostJvmArch"; exit 1 ;;
esac

depFiles=()
# For each non-host arch, fetch arch-specific deps via nixDownloadDeps
for arch in "${ARCHS[@]}"; do
  [[ "$arch" == "$hostJvmArch" ]] && continue

  echo "Fetching deps for $arch..."
  "$(nix-build -E "
    let pkgs = import ./. {}; in
    pkgs.keyguard.mitmCache.updateScript.override {
      pkg = pkgs.keyguard.overrideAttrs (old: {
        gradleFlags = old.gradleFlags ++ [ \"-Dos.arch=$arch\" ];
        gradleUpdateTask = \":desktopApp:nixDownloadDeps\";
      });
      data = \"${arch}-deps.json\";
    }
  ")"
  depFiles+=("$ROOT/${arch}-deps.json")
done

# Merge arch-specific deps into the main deps.json
jq --indent 1 -s 'reduce .[] as $item ({}; . * $item)' "$ROOT/deps.json" "${depFiles[@]}" > "$ROOT/merged-deps.json"
mv "$ROOT/merged-deps.json" "$ROOT/deps.json"
rm "${depFiles[@]}"
