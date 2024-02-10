#!@runtimeShell@

set -euo pipefail
shopt -s nullglob

export PATH="@binPath@"
# used for glob ordering of package names
export LC_ALL=C

if [ $# -eq 0 ]; then
  >&2 echo "Usage: $0 <packages directory> [path to a file with a list of excluded packages] > deps.nix"
  exit 1
fi

pkgs=$1
tmp=$(realpath "$(mktemp -td nuget-to-nix.XXXXXX)")
trap 'rm -r "$tmp"' EXIT

excluded_list=$(realpath "${2:-/dev/null}")

export DOTNET_NOLOGO=1
export DOTNET_CLI_TELEMETRY_OPTOUT=1

mapfile -t sources < <(dotnet nuget list source --format short | awk '/^E / { print $2 }')

declare -A base_addresses

for index in "${sources[@]}"; do
  base_addresses[$index]=$(
    curl --compressed --netrc -fsL "$index" | \
      jq -r '.resources[] | select(."@type" == "PackageBaseAddress/3.0.0")."@id"')
done

echo "{ fetchNuGet }: ["

cd "$pkgs"
for package in *; do
  cd "$package"
  for version in *; do
    id=$(xq -r .package.metadata.id "$version"/*.nuspec)

    if grep -qxF "$id.$version.nupkg" "$excluded_list"; then
      continue
    fi

    used_source="$(jq -r '.source' "$version"/.nupkg.metadata)"
    for source in "${sources[@]}"; do
      url="${base_addresses[$source]}$package/$version/$package.$version.nupkg"
      if [[ "$source" == "$used_source" ]]; then
        sha256="$(nix-hash --type sha256 --flat --base32 "$version/$package.$version".nupkg)"
        found=true
        break
      else
        if sha256=$(nix-prefetch-url "$url" 2>"$tmp"/error); then
          # If multiple remote sources are enabled, nuget will try them all
          # concurrently and use the one that responds first. We always use the
          # first source that has the package.
          echo "$package $version is available at $url, but was restored from $used_source" 1>&2
          found=true
          break
        else
          if ! grep -q 'HTTP error 404' "$tmp/error"; then
            cat "$tmp/error" 1>&2
            exit 1
          fi
        fi
      fi
    done

    if ! ${found-false}; then
      echo "couldn't find $package $version" >&2
      exit 1
    fi

    if [[ "$source" != https://api.nuget.org/v3/index.json ]]; then
      echo "  (fetchNuGet { pname = \"$id\"; version = \"$version\"; sha256 = \"$sha256\"; url = \"$url\"; })"
    else
      echo "  (fetchNuGet { pname = \"$id\"; version = \"$version\"; sha256 = \"$sha256\"; })"
    fi
  done
  cd ..
done

cat << EOL
]
EOL
