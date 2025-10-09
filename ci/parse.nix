{
  lib,
  nix,
  runCommand,
}:
let
  nixpkgs =
    with lib.fileset;
    toSource {
      root = ../.;
      fileset = (fileFilter (file: file.hasExt "nix") ../.);
    };
in
runCommand "nix-parse-${nix.name}"
  {
    nativeBuildInputs = [
      nix
    ];
  }
  ''
    export NIX_STORE_DIR=$TMPDIR/store
    export NIX_STATE_DIR=$TMPDIR/state

    cd "${nixpkgs}"

    # Passes all files to nix-instantiate at once.
    # Much faster, but will only show first error.
    parse-all() {
      find . -type f -iname '*.nix' | xargs -P $(nproc) nix-instantiate --parse >/dev/null 2>/dev/null
    }

    # Passes each file separately to nix-instantiate with -n1.
    # Much slower, but will show all errors.
    parse-each() {
      find . -type f -iname '*.nix' | xargs -n1 -P $(nproc) nix-instantiate --parse >/dev/null
    }

    if ! parse-all; then
      parse-each
    fi

    touch $out
  ''
