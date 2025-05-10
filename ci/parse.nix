{
  fd,
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
      fd
      nix
    ];
  }
  ''
    export NIX_STORE_DIR=$TMPDIR/store
    export NIX_STATE_DIR=$TMPDIR/state

    cd "${nixpkgs}"

    # Passes all files to nix-instantiate at once with -X.
    # Much faster, but will only show first error.
    parse-all() {
      fd -t file -e nix -X nix-instantiate --parse >/dev/null 2>/dev/null
    }

    # Passes each file separately to nix-instantiate with -x.
    # Much slower, but will show all errors.
    parse-each() {
      fd -t file -e nix -x nix-instantiate --parse >/dev/null
    }

    if ! parse-all; then
      parse-each
    fi

    touch $out
  ''
