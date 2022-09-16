#!@runtimeShell@
# shellcheck shell=bash

[[ ${debug:-} ]] && { PS4=':$LINENO+'; set -x; }
set -o pipefail

export PATH="@binPath@"

if [ $# -eq 0 ]; then
  >&2 echo "Usage: $0 <packages directory> [path to file with a list of excluded packages] > deps.nix"
  exit 1
fi

pkgs=$1
exclusions=$2
tmpfile=$(mktemp -t nuget-to-nix.XXXXXX) || exit
trap 'rm -f "$tmpfile"' EXIT

# open tmpfile for stdout after making a backup of the original
# this way we don't need to reopen the output file every time we want to echo a single line into it
exec {orig_stdout_fd}>&1 >"$tmpfile" || exit

# cache nuget-formatted JSON index files
declare -A nuget_sources_cache || exit

while IFS= read -r -d '' pkg_spec; do : pkg_spec="$pkg_spec"
  { read -r pkg_name && read -r pkg_version; } < <(
    xmlstarlet sel -t -m '/*[local-name()="package"]/*[local-name()="metadata"]' -v './*[local-name()="id"]' -n -v './*[local-name()="version"]' -n <"$pkg_spec"
  ) || exit
  [[ $pkg_name && $pkg_version ]] || { echo "ERROR: Unable to extract package name and version from $pkg_spec" >&2; exit 1; }

  # note use of grep -Fx so we only count a complete, exact line match; otherwise we could have false substring matches or regexes that treat a name as a regex
  if [[ $exclusions ]]; then
    grep -qFxe "$pkg_name" "$exclusions" && continue
  fi

  pkg_sha256="$(nix-hash --type sha256 --flat --base32 "${pkg_spec%/*}"/*.nupkg)" || exit
  pkg_src="$(jq --raw-output '.source' "${pkg_spec%/*}/.nupkg.metadata")" || exit

  if [[ -d $pkg_src ]]; then
    # source is a local filesystem, not a a URL
    echo "  (fetchNuGet { pname = \"$pkg_name\"; version = \"$pkg_version\"; sha256 = \"$pkg_sha256\"; })" || exit
  else
    case $pkg_src in
      https://api.nuget.org/*)
        # default repository; no explicit URL required
        echo "  (fetchNuGet { pname = \"$pkg_name\"; version = \"$pkg_version\"; sha256 = \"$pkg_sha256\"; })" || exit
        ;;
      https://www.powershellgallery.com/api/v2/*)
        # using an OData API instead of the nuget service index format
        pkg_xml=$(curl -n --fail "https://www.powershellgallery.com/api/v2/Packages(Id='$pkg_name',Version='$pkg_version')") || exit
        pkg_url=$(xmlstarlet sel -N a=http://www.w3.org/2005/Atom -t -m /a:entry/a:content -v ./@src -n <<<"$pkg_xml") && [[ $pkg_url ]] || exit
        echo "  (fetchNuGet { pname = \"$pkg_name\"; version = \"$pkg_version\"; sha256 = \"$pkg_sha256\"; url = \"$pkg_url\"; })" || exit
        ;;
      *)
        # unrecognized repository; assume pkg_src is a nuget service index
        pkg_source_url="${nuget_sources_cache[$pkg_src]:=$(curl -n --fail "$pkg_src" | jq --raw-output '.resources[] | select(."@type" == "PackageBaseAddress/3.0.0")."@id"')}" || exit
        pkg_url="$pkg_source_url${pkg_name,,}/${pkg_version,,}/${pkg_name,,}.${pkg_version,,}.nupkg"
        echo "  (fetchNuGet { pname = \"$pkg_name\"; version = \"$pkg_version\"; sha256 = \"$pkg_sha256\"; url = \"$pkg_url\"; })" || exit
        ;;
    esac
  fi
done < <(find "$pkgs" -name '*.nuspec' -print0)

exec >&$orig_stdout_fd || exit # redirect stdout back to original destination, closing tmpfile

# only write the header if we got this far -- if anything failed above, no reason to print it
echo "{ fetchNuGet }: [" || exit
LC_ALL=C sort -s --ignore-case <"$tmpfile" || exit
echo "]" || exit
