#! /usr/bin/env nix-shell
#! nix-shell -i bash -p cacert curl jq unzip
# shellcheck shell=bash
set -eu -o pipefail

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
    curl --silent --show-error --retry 3 --fail -X GET -o "$EXTTMP/$N.zip" "$URL"
    # Unpack the file we need to stdout then pull out the version
    VER=$(jq -r '.version' <(unzip -qc "$EXTTMP/$N.zip" "extension/package.json"))
    # Calculate the hash
    HASH=$(nix-hash --flat --sri --type sha256 "$EXTTMP/$N.zip")

    # Clean up.
    rm -Rf "$EXTTMP"
    # I don't like 'rm -Rf' lurking in my scripts but this seems appropriate.

    cat <<-EOF
  {
    name = "$2";
    publisher = "$1";
    version = "$VER";
    hash = "$HASH";
  }
EOF
}

# See if we can find our `code` binary somewhere.
if [ $# -ne 0 ]; then
    CODE=$1
else
    CODE=$(command -v code || command -v codium)
fi

if [ -z "$CODE" ]; then
    # Not much point continuing.
    fail "VSCode executable not found"
fi

# Try to be a good citizen and clean up after ourselves if we're killed.
trap clean_up SIGINT

# Begin the printing of the nix expression that will house the list of extensions.
printf '{ extensions = [\n'

# Note that we are only looking to update extensions that are already installed.
for i in $($CODE --list-extensions)
do
    OWNER=$(echo "$i" | cut -d. -f1)
    EXT=$(echo "$i" | cut -d. -f2)

    get_vsixpkg "$OWNER" "$EXT"
done
# Close off the nix expression.
printf '];\n}'
