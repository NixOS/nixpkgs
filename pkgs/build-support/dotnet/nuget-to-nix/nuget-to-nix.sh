#!@runtimeShell@

set -euo pipefail
shopt -s nullglob

export PATH="@binPath@"
# used for glob ordering of package names
export LC_ALL=C

if [ $# -eq 0 ]; then
  >&2 echo "Usage: $0 <packages directory> [path to a file with a list of excluded packages] [path to nuget.config file] > deps.nix"
  exit 1
fi

pkgs=$1
tmp=$(realpath "$(mktemp -td nuget-to-nix.XXXXXX)")
trap 'rm -r "$tmp"' EXIT

excluded_list=$(realpath "${2:-/dev/null}")

nuget_config_path=$(realpath "${3:-/dev/null}")

DELIMITER='§'
nuget_list_command="dotnet nuget list source"
declare -a package_source_mapping
if [ -f "$nuget_config_path" ]; then
  nuget_list_command="$nuget_list_command --configfile $nuget_config_path"
  while read -r value; do
    package_source_mapping+=($value)
  done < <(xq -r --arg DELIMITER "$DELIMITER" '.configuration.packageSourceMapping[] |.[] | { "@key": ."@key", "package": (if (.package | type) == "array" then .package[] else .package end) } | { "package": .package["@pattern"], "source": ."@key" } | "\(.package)\($DELIMITER)\(.source)"  '  "$nuget_config_path")

else
  package_source_mapping=()
fi

export DOTNET_NOLOGO=1
export DOTNET_CLI_TELEMETRY_OPTOUT=1

declare -A sources
sanitize_source_key() {
   echo "$1" | sed 's/[^a-zA-Z0-9_]/_/g'
}
while IFS='=' read -r key value; do
    sources[$(sanitize_source_key "$key")]="$value"
done < <($nuget_list_command | awk '/^\s+[0-9]+\./ {name=$2} /https:\/\// {print name "=" $1}')

declare -A base_addresses

for index in "${sources[@]}"; do
    if [[ -d "$index" ]]; then
        continue
    fi

    if index_response=$(curl --compressed --netrc -ifsL "$index" 2>"$tmp/error"); then
      base_address=$( \
        echo "$index_response" | \
        awk '/^{/ {json=1} json' | \
        jq -r '.resources[] | select(."@type" == "PackageBaseAddress/3.0.0")."@id"' | \
        sed 's|/*$|/|')

      if [[ ! "$base_address" == */ ]]; then
        base_address="$base_address/"
      fi
      base_addresses[$index]="$base_address"

    else
        echo "Remote resolution failed for $index with $(echo "$index_response" | awk 'NR==1{print $2}')"
    fi
done

get_source_by_key() {
    local search_key="$1"
    shopt -s nocasematch
    for entry in "${package_source_mapping[@]}"; do
        key="${entry%%"$DELIMITER"*}"
        value="${entry#*"$DELIMITER"}"
        if [[ "$search_key" =~ $key ]]; then
             skey=$(sanitize_source_key "$value")
             if [[ -v sources[$skey] ]]; then
                 echo "${sources["$skey"]}"
                 shopt -u nocasematch
                 return
             fi
        fi
    done
    shopt -u nocasematch
    echo https://api.nuget.org/v3/index.json
}

echo "{ fetchNuGet }: ["

cd "$pkgs"
for package in *; do
  [[ -d "$package" ]] || continue
  cd "$package"
  for version in *; do
    id=$(xq -r .package.metadata.id "$version"/*.nuspec)

    if grep -qxF "$id.$version.nupkg" "$excluded_list"; then
      continue
    fi

    used_source="$(jq -r '.source' "$version"/.nupkg.metadata)"
    found=false

    if [[ -d "$used_source" ]]; then
        continue
    fi

    source=$(get_source_by_key "$package")
    url="${base_addresses[$source]}$package/$version/$package.$version.nupkg"
    if [[ "$source" == "$used_source" ]]; then
        sha256="$(nix-hash --type sha256 --flat --base32 "$version/$package.$version".nupkg)"
        found=true

    else
        if sha256=$(nix-prefetch-url "$url" 2>"$tmp"/error); then
          # If mapped source from the config file was different pull the package from default source
          echo "$package $version is available at $url, but was restored from $used_source" 1>&2
          found=true

        else
          if ! grep -q 'HTTP error 404' "$tmp/error"; then
            cat "$tmp/error" 1>&2
            exit 1
          fi
        fi
    fi


    if [[ $found = false ]]; then
      echo "Couldn't find $package $version at $source, have you forgotten to provide nuget.config path?" >&2
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
