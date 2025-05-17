{
  lib,
  runCommand,
  nixpkgs,
  singleSystem,
  linkFarm,
}:

let
  nixpkgs' = builtins.path {
    name = "nixpkgs-prime";
    path = nixpkgs;
  };
in
{
  evalSystem,
  chunkSize,
  firstEval ? singleSystem { inherit evalSystem chunkSize; },
  secondEval ? singleSystem {
    inherit evalSystem chunkSize;
    nixpkgsPath = nixpkgs';
  },
}:

let
  checks = {
    badFiles = runCommand "bad-files-check" { } ''
      badFiles=$(find ${nixpkgs}/pkgs -type f -name '*.nix' -print | xargs grep -l '^[^#]*<nixpkgs/' || true)
      if [[ -n $badFiles ]]; then
        echo "Nixpkgs is not allowed to use <nixpkgs> to refer to itself."
        echo "The offending files: $badFiles"
        exit 1
      fi

      touch "$out"
    '';

    conflictingPaths = runCommand "conflicting-files-check" { } ''
      conflictingPaths=$(find ${nixpkgs} | awk '{ print $1 " " tolower($1) }' | sort -k2 | uniq -D -f 1 | cut -d ' ' -f 1)
      if [[ -n $conflictingPaths ]]; then
        echo "Files in nixpkgs must not vary only by case"
        echo "The offending paths: $conflictingPaths"
        exit 1
      fi

      touch "$out"
    '';

    evalPurity = runCommand "eval-purity-check" { } ''
      if ! diff -u ${firstEval}/paths ${secondEval}/paths; then
        echo
        echo "Error: Nixpkgs evaluation depends on Nixpkgs path"
        exit 1
      fi

      touch "$out"
    '';
  };
in
(linkFarm "release-checks-${evalSystem}" (
  lib.mapAttrsToList (_: check: {
    inherit (check) name;
    path = check;
  }) checks
))
// checks
// {
  inherit secondEval;
}
