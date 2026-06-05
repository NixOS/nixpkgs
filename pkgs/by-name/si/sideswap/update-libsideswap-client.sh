#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-update gnugrep gnused curl

set -eu -o pipefail

mainfile="$(nix-instantiate --eval -E "with import ./. {}; (builtins.unsafeGetAttrPos \"version\" sideswap).file" | tr -d '"')"
libfile="$(dirname -- "$mainfile")/libsideswap-client.nix"

mainversion="$(nix-instantiate --eval -E "with import ./. {}; sideswap.version" | tr -d '"')"

# Update the comment in libsideswap-client.nix.
sed -i "s@sideswapclient/blob/v[^\/]+/deploy@sideswapclient/blob/v${mainversion}/deploy@" $libfile

# Find libsideswap_client commit used in sideswap/deploy/build_linux.sh.
libversion=$(curl --show-error --silent ${GITHUB_TOKEN:+-u ":${GITHUB_TOKEN}"} "https://raw.githubusercontent.com/sideswap-io/sideswapclient/refs/tags/v${mainversion}/deploy/build_linux.sh" | grep -A 1 'pushd sideswap_rust' | grep 'git checkout' | sed 's/git checkout //')

# Update revision of the lib.
sed -i "/rev =/s/[0-9a-f]\{40\}/${libversion}/" $libfile

# Find the date of the commit to use as 0-unstable-YYYY-MM-DD version of the lib.
libdate=$(curl --show-error --silent "https://github.com/sideswap-io/sideswap_rust/commit/${libversion}.patch" | grep '^Date: ' | head -1)
libunstableversion=$(date -d "${libdate#Date: }" +"%Y-%m-%d")
sed -i "/version =/s/0-unstable-....-..-../0-unstable-${libunstableversion}/" $libfile

# Update hash and cargoHash of the lib. Send output to /dev/null not to break "update.nix" which expects JSON here.
nix-update sideswap.lib --version=skip > /dev/null
