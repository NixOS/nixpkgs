#!@runtimeShell@
# shellcheck shell=bash

set -euo pipefail
shopt -s nullglob

export SSL_CERT_FILE=@cacert@/etc/ssl/certs/ca-bundle.crt
export PATH="@binPath@:$PATH"
# used for glob ordering of package names
export LC_ALL=C

>&2 echo "WARNING: nuget-to-nix has deprecated in favor of nuget-to-json."

if [ $# -eq 0 ]; then
    >&2 echo "Usage:"
    >&2 echo "  $0 <packages directory> [path to a file with a list of excluded packages] > deps.nix"
    >&2 echo "  $0 --convert deps.json > deps.nix"
    exit 1
fi

jsonDeps=
if [ "$1" == "--convert" ]; then
    if [ ! -e "$2" ]; then
        echo "File not found."
        exit 1
    fi

    if IFS='' read -r -d '' jsonDeps <"$2"; then
        echo "Null bytes found in file." >&2
        exit 1
    fi
else
    if ! jsonDeps=$(nuget-to-json "$@"); then
        echo "nuget-to-json failed."
        exit 1
    fi
fi

# pkgs/by-name/az/azure-functions-core-tools/deps.json
IFS='' readarray -d '' depsParts < <(jq 'map([.pname, .version, .sha256, .hash, .url]) | flatten[]' --raw-output0 <<<"$jsonDeps")
index=0

echo '{ fetchNuGet }: ['

while [ "$index" -lt "${#depsParts[@]}" ]; do
    pname="${depsParts[index]}"
    version="${depsParts[++index]}"
    sha256="${depsParts[++index]}"
    hash="${depsParts[++index]}"
    url="${depsParts[++index]}"
    ((++index)) # Go to next pname

    echo -n "  (fetchNuGet { pname = \"$pname\"; version = \"$version\"; "
    if [ "$sha256" != null ]; then
        echo -n "sha256 = \"$sha256\"; "
    else
        echo -n "hash = \"$hash\"; "
    fi
    if [ "$url" != "null" ]; then
        echo -n "url = \"$url\"; "
    fi
    echo '})'
done

echo ']'
