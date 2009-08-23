#! /bin/sh

[ -n "$2" ] && NIXPKGS_ALL="$2";
[ -z "$NIXPKGS_ALL" ] && [ -f "/etc/nixos/nixpkgs" ] && NIXPKGS_ALL="/etc/nixos/nixpkgs";
[ -z "$NIXPKGS_ALL" ] && [ -f "$HOME/nixpkgs" ] && NIXPKGS_ALL="$HOME/nixpkgs";
[ -z "$NIXPKGS_ALL" ] && {
  echo "Cannot find Nixpkgs source. Please specify it via NIXPKGS_ALL or second command line argument"
  exit 1
};

derivation="$(nix-instantiate --show-trace - << EOF
let 
  pkgs = import "${NIXPKGS_ALL}" {};
  attrSet = import "${1}";
in
  pkgs.attrSetToDir attrSet
EOF
)"
echo "Derivation is: $derivation" >&2
output="$(nix-store -r "$derivation")"
echo "$output/attributes"
