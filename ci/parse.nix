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
    nix-store --init

    cd "${nixpkgs}"

    # This will only show the first parse error, not all of them. That's fine, because
    # the other CI jobs will report in more detail. This job is about checking parsing
    # across different implementations / versions, not about providing the best DX.
    # Returning all parse errors requires significantly more resources.
    find . -type f -iname '*.nix' | xargs -P $(nproc) nix-instantiate --parse >/dev/null

    touch $out
  ''
