#! /usr/bin/env nix-shell
#! nix-shell -i bash -p cacert curl jq unzip
# shellcheck shell=bash
set -eu -o pipefail

# pass <vscode exec or -> <format> to specify format as either json or nix (default nix)
# note that json format is NOT a json array, but a sequence of json objects

# can be added to your configuration with the following command and snippet:
# $ ./pkgs/applications/editors/vscode/extensions/update_installed_exts.sh > extensions.nix
#
# packages = with pkgs;
#   (vscode-with-extensions.override {
#     vscodeExtensions = map
#       (extension: vscode-utils.buildVscodeMarketplaceExtension {
#         mktplcRef = {
#          inherit (extension) name publisher version sha256;
#         };
#       })
#       (import ./extensions.nix).extensions;
#   })
# ]

# Helper to just fail with a message and non-zero exit code.
function fail() {
    echo "$1" >&2
    exit 1
}

# Helper to clean up after ourselves if we're killed by SIGINT.
function clean_up() {
    TDIR="${TMPDIR:-/tmp}"
    echo "Script killed, cleaning up tmpdirs: $TDIR/vscode_exts_*" >&2
    rm -Rf "$TDIR/vscode_exts_*"
}

function get_vsixpkg() {
    N="$1.$2"

    # Create a tempdir for the extension download.
    EXTTMP=$(mktemp -d -t vscode_exts_XXXXXXXX)

    URL="https://$1.gallery.vsassets.io/_apis/public/gallery/publisher/$1/extension/$2/latest/assetbyname/Microsoft.VisualStudio.Services.VSIXPackage"

    # Quietly but delicately curl down the file, blowing up at the first sign of trouble.
    curl --silent --show-error --retry 3 --fail -X GET -o "$EXTTMP/$N.zip" "$URL" || {
        if (($? > 128))
        then exit $?
        fi
        cat >&2 <<EOF
unable to download $N
EOF
        return
}
    # Unpack the file we need to stdout then pull out the version
    VER=$(jq -r '.version' <(unzip -qc "$EXTTMP/$N.zip" "extension/package.json"))
    # Calculate the hash
    HASH=$(nix-hash --flat --sri --type sha256 "$EXTTMP/$N.zip")

    # Clean up.
    rm -Rf "$EXTTMP"
    # I don't like 'rm -Rf' lurking in my scripts but this seems appropriate.

    case $FORMAT in
        nix)
            cat <<-EOF
  {
    name = "$2";
    publisher = "$1";
    version = "$VER";
    hash = "$HASH";
  }
EOF
            ;;
        json)
            printf '{"name": "%s", "publisher": "%s", "version": "%s", "hash": "%s"}\n' "$2" "$1" "$VER" "$HASH"
            ;;
    esac
}

# See if we can find our `code` binary somewhere.
if [ $# -ne 0 ] && [ $1 != "-" ]; then
    CODE=$1
else
    CODE=$(command -v code || command -v codium)
fi

if [ $# -ge 2 ]; then
    FORMAT=$2
else
    FORMAT=nix
fi

if [ -z "$CODE" ]; then
    # Not much point continuing.
    fail "VSCode executable not found"
fi

# Try to be a good citizen and clean up after ourselves if we're killed.
trap clean_up EXIT

# Begin the printing of the nix expression that will house the list of extensions.
if [ "$FORMAT" = nix ]
then
    printf '{ extensions = [\n'
fi

# Note that we are only looking to update extensions that are already installed.
for i in $($CODE --list-extensions)
do
    OWNER=$(echo "$i" | cut -d. -f1)
    EXT=$(echo "$i" | cut -d. -f2)

    get_vsixpkg "$OWNER" "$EXT"
done
# Close off the nix expression.
if [ "$FORMAT" = nix ]
then
    printf '];\n}'
fi
