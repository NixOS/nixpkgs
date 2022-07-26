#!@runtimeShell@

set -euo pipefail

export PATH="@binPath@"

if [ $# -eq 0 ]; then
  >&2 echo "Usage: $0 [packages directory] > deps.nix"
  exit 1
fi

pkgs=$1
tmpfile=$(mktemp /tmp/nuget-to-nix.XXXXXX)
trap "rm -f ${tmpfile}" EXIT

declare -A nuget_sources_cache

echo "{ fetchNuGet }: ["

while read pkg_spec; do
  { read pkg_name; read pkg_version; } < <(
    # Build version part should be ignored: `3.0.0-beta2.20059.3+77df2220` -> `3.0.0-beta2.20059.3`
    sed -nE 's/.*<id>([^<]*).*/\1/p; s/.*<version>([^<+]*).*/\1/p' "$pkg_spec")
  pkg_sha256="$(nix-hash --type sha256 --flat --base32 "$(dirname "$pkg_spec")"/*.nupkg)"

  pkg_src="$(jq --raw-output '.source' "$(dirname "$pkg_spec")/.nupkg.metadata")"
  if [[ $pkg_src != https://api.nuget.org/* ]]; then
    pkg_source_url="${nuget_sources_cache[$pkg_src]:=$(curl -n --fail "$pkg_src" | jq --raw-output '.resources[] | select(."@type" == "PackageBaseAddress/3.0.0")."@id"')}"
    pkg_url="$pkg_source_url${pkg_name,,}/${pkg_version,,}/${pkg_name,,}.${pkg_version,,}.nupkg"
    echo "  (fetchNuGet { pname = \"$pkg_name\"; version = \"$pkg_version\"; sha256 = \"$pkg_sha256\"; url = \"$pkg_url\"; })" >> ${tmpfile}
  else
    echo "  (fetchNuGet { pname = \"$pkg_name\"; version = \"$pkg_version\"; sha256 = \"$pkg_sha256\"; })" >> ${tmpfile}
  fi
done < <(find $1 -name '*.nuspec')

LC_ALL=C sort --ignore-case ${tmpfile}

echo "]"
