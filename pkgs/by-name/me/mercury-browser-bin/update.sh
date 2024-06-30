#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq nix-prefetch

set -e

dirname="$(dirname "$0")"

updateHash() {
	version=$1
	simd=$2

	hashKey="${simd}_hash"

	url="https://github.com/Alex313031/Mercury/releases/download/v.${version}/mercury-browser_${version}_${simd}.deb"
	hash=$(nix-prefetch-url --type sha256 "$url")
	sriHash="$(nix hash to-sri --type sha256 "$hash")"

	sed -i "s|$hashKey = \"[a-zA-Z0-9\/+-=]*\";|$hashKey = \"$sriHash\";|g" "$dirname/default.nix"
}

updateVersion() {
	sed -i "s/version = \"[0-9.]*\";/version = \"$1\";/g" "$dirname/default.nix"
}

currentVersion=$(grep -m 1 'version = ' <"$dirname/default.nix" | awk '{ print $3 }' | tr -d '";')
latestTag=$(curl https://api.github.com/repos/Alex313031/Mercury/tags | jq -r '.[] | .name' | sort --version-sort | tail -1)
latestVersion="$(expr "$latestTag" : 'v.\(.*\)')"

echo "Current version: ${currentVersion}"
echo "Latest version: ${latestVersion}"

if [[ "$currentVersion" == "$latestVersion" ]]; then
	echo "Mercury is up-to-date: ${currentVersion}"
	exit 0
fi

updateVersion "$latestVersion"

for simd in AVX2 AVX SSE4 SSE3; do
	updateHash "$latestVersion" "$simd"
done
