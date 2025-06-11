{
  lib,
  nix,
  nixpkgs-vet,
  runCommand,
}:
{
  base ? ../.,
  head ? ../.,
}:
let
  filtered =
    with lib.fileset;
    path:
    toSource {
      fileset = (gitTracked path);
      root = path;
    };
in
runCommand "nixpkgs-vet"
  {
    nativeBuildInputs = [
      nixpkgs-vet
    ];
    env.NIXPKGS_VET_NIX_PACKAGE = nix;
  }
  ''
    export NIX_STATE_DIR=$(mktemp -d)

    nixpkgs-vet --base ${filtered base} ${filtered head}

    # TODO: Upstream into nixpkgs-vet, see:
    # https://github.com/NixOS/nixpkgs-vet/issues/164
    badFiles=$(find ${filtered head}/pkgs -type f -name '*.nix' -print | xargs grep -l '^[^#]*<nixpkgs/' || true)
    if [[ -n $badFiles ]]; then
      echo "Nixpkgs is not allowed to use <nixpkgs> to refer to itself."
      echo "The offending files:"
      echo "$badFiles"
      exit 1
    fi

    # TODO: Upstream into nixpkgs-vet, see:
    # https://github.com/NixOS/nixpkgs-vet/issues/166
    conflictingPaths=$(find ${filtered head} | awk '{ print $1 " " tolower($1) }' | sort -k2 | uniq -D -f 1 | cut -d ' ' -f 1)
    if [[ -n $conflictingPaths ]]; then
      echo "Files in nixpkgs must not vary only by case."
      echo "The offending paths:"
      echo "$conflictingPaths"
      exit 1
    fi

    touch $out
  ''
