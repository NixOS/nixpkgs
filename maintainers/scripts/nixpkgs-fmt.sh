#!/usr/bin/env nix-shell
#! nix-shell -I nixpkgs=. -i bash -p treefmt nixpkgs-fmt nixfmt

################################################################################
# nixpkgs-fmt.sh                                                               #
################################################################################
# This script "formats" Nixpkgs.                                               #
#                                                                              #
################################################################################

format_tree() {
    treefmt
}

format_tree

exit 0
