#!@runtimeShell@

set -euo pipefail
shopt -s nullglob

export PATH="@binPath@"
# used for glob ordering of package names
export LC_ALL=C

usage="Usage: $0 [-h|--help] [--nuget-config <nuget-config>] [--] <packages-directory> [<excluded-packages>] > deps.nix
    <packages-directory>           Path to a nuget packages directory
    <excluded-packages>            Optional path to a file with a list of excluded packages
    --nuget-config <nuget-config>  Optional path to the nuget.config file
    --help, -h                     Show this help message"

print_usage_error() {
  echo "$usage" >&2
  if [ $# -gt 0 ]; then
    echo >&2
    echo "Error: $@" >&2
  fi
}

while [ $# -gt 0 ]; do
  arg=$1
  case "$arg" in
  --nuget-config)
    shift
    if [ $# -eq 0 ]; then
      print_usage_error "flag $arg requires path to nuget config"
      exit 1
    fi
    nuget_config=$1
    shift
    ;;
  -h | --help)
    echo "$usage" >&2
    exit 0
    ;;
  --)
    shift
    break
    ;;
  -*)
    print_usage_error "unknown flag $arg"
    exit 1
    ;;
  *)
    break
    ;;
  esac
done

case $# in
1 | 2) ;;
0)
  print_usage_error "expected packages directory argument"
  exit 1
  ;;
*)
  print_usage_error "unexpected trailing arguments: $@"
  exit 1
  ;;
esac

pkgs=$1
# NB for compatibility we treat empty path as if it is not set.
if [ -n "${2-}" ]; then
  excluded_list=$(realpath -- "$2")
fi

tmp=$(realpath "$(mktemp -td nuget-to-nix.XXXXXX)")
trap 'rm -r "$tmp"' EXIT

export DOTNET_NOLOGO=1
export DOTNET_CLI_TELEMETRY_OPTOUT=1

mapfile -t sources < <(dotnet nuget list source --format short \
  ${nuget_config+"--configfile=$nuget_config"} |
  awk '/^E / { print $2 }')

declare -a remote_sources
declare -A base_addresses

for index in "${sources[@]}"; do
    if [[ -d "$index" ]]; then
        continue
    fi

    remote_sources+=($index)

    base_addresses[$index]=$(
    curl --compressed --netrc -fsL "$index" | \
      jq -r '.resources[] | select(."@type" == "PackageBaseAddress/3.0.0")."@id"')
done

echo "{ fetchNuGet }: ["

cd "$pkgs"
for package in *; do
  [[ -d "$package" ]] || continue
  cd "$package"
  for version in *; do
    id=$(xq -r .package.metadata.id "$version"/*.nuspec)

    if [ -n "${excluded_list-}" ]; then
      if grep -qxF "$id.$version.nupkg" "$excluded_list"; then
        continue
      fi
    fi

    used_source="$(jq -r '.source' "$version"/.nupkg.metadata)"
    found=false

    if [[ -d "$used_source" ]]; then
        continue
    fi

    for source in "${remote_sources[@]}"; do
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

    if [[ $found = false ]]; then
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
