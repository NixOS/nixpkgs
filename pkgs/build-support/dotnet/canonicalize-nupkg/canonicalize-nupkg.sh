#!@runtimeShell@

set -euo pipefail

export PATH="@binPath@"

if [ $# -ne 2 ]; then
    >&2 echo "Usage: $0 input.nupkg output.nupkg"
    exit 1
fi

input=$(realpath "$1")
output=$(realpath "$2")

tmp=$(realpath "$(mktemp -td canonicalize-nupkg.XXXXXX)")
trap "rm -r $tmp" EXIT

cd "$tmp"
unzip -qq "$input"
chmod -R +rw .
rm -f .signature.p7s
# Sets all timestamps to Jan 1 1980, the earliest mtime zips support.
find -exec touch -t 198001010000.00 {} +
zip -qroX "$output" .
