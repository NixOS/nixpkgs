#!/usr/bin/env bash
set -euo pipefail
# Dumps a Makefile which can be used to instantiate the derivations that Hydra will evaluate

# Usage:
#  $1   = nix expression to `import`, such as <nixpkgs/nixos/release-small.nix>
#  $2   = attribute within $1, which should be a Hydra job attrset (i.e. has a .constituents attribute)
#  $3   = additional arguments for nix-instantiate, such as 'system = "aarch64-linux";'

# Example:
#   make -j32 -f <(instantiate-constitutents.sh '<nixpkgs/nixos/release-small.nix>' tested 'supportedSystems = ["x86_64-linux"];')

if [ ! "$#" -eq 3 ]; then
    cat << EOF
    This script expects three arguments:
    1. A nix expression to instantiate (e.g. `<nixpkgs/nixos/release-small.nix>`)
    2. The name of the Hydra jobset attr within (1) (e.g. `tested`)
    3. Additional args to `nix-instantiate` (e.g. `system = ["aarch64-linux"]'`

    Example usage:
    $ make -j32 -f <(instantiate-constitutents.sh '<nixpkgs/nixos/release-small.nix>' tested 'supportedSystems = ["x86_64-linux"];')
EOF
    exit 1
fi
DEST="$(mktemp -d)"
echo "drv files will be written to $DEST" 1>&2
IMPORT="$1"
TOPLEVEL_ATTR="$2"
ARGS="$3"

readonly DEST IMPORT TOPLEVEL_ATTR ARGS

echo "default: build"
ATTRS=$(nix eval --raw --impure --expr "let lib = import <nixpkgs/lib>; in lib.concatStringsSep \"\\n\" (with import $IMPORT {$ARGS}; $TOPLEVEL_ATTR.constituents)")
for ATTR in $ATTRS; do
    cat << EOF
$DEST/$ATTR:; @nix-instantiate --expr '(import $IMPORT {$ARGS}).$ATTR' --add-root $DEST/$ATTR
drvs: $DEST/$ATTR
build: $DEST/$ATTR
DRVS += $DEST/$ATTR
EOF
done

echo "build:; nix build -L \$\$(readlink -f $DEST/*)"
