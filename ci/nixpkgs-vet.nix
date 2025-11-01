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
      fileset = difference (gitTracked path) (unions [
        (path + /.github)
        (path + /ci)
      ]);
      root = path;
    };

  filteredBase = filtered base;
  filteredHead = filtered head;
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
    $NIXPKGS_VET_NIX_PACKAGE/bin/nix-store --init

    nixpkgs-vet --base ${filteredBase} ${filteredHead}

    # TODO: Upstream into nixpkgs-vet, see:
    # https://github.com/NixOS/nixpkgs-vet/issues/164
    badFiles=$(find ${filteredHead}/pkgs -type f -name '*.nix' -print | xargs grep -l '^[^#]*<nixpkgs/' || true)
    if [[ -n $badFiles ]]; then
      echo "Nixpkgs is not allowed to use <nixpkgs> to refer to itself."
      echo "The offending files:"
      echo "$badFiles"
      exit 1
    fi

    # TODO: Upstream into nixpkgs-vet, see:
    # https://github.com/NixOS/nixpkgs-vet/issues/166
    conflictingPaths=$(find ${filteredHead} | awk '{ print $1 " " tolower($1) }' | sort -k2 | uniq -D -f 1 | cut -d ' ' -f 1)
    if [[ -n $conflictingPaths ]]; then
      echo "Files in nixpkgs must not vary only by case."
      echo "The offending paths:"
      echo "$conflictingPaths"
      exit 1
    fi

    touch $out
  ''
