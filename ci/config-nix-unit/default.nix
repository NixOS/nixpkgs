{
  lib,
  nix-unit,
  runCommand,
  nixpkgs,
}:

runCommand "config-nix-unit"
  {
    nativeBuildInputs = [ nix-unit ];
  }
  ''
    export HOME=$TMPDIR

    # `pkgs/top-level/impure.nix` falls back to this file when Nixpkgs is
    # imported without a `config` argument. The tests use it to tell apart
    # "config was passed explicitly" from "config came from the environment",
    # which is why they need a controlled environment and cannot run at
    # evaluation time.
    echo '{ allowUnfree = true; }' > "$TMPDIR/nixpkgs-config.nix"
    export NIXPKGS_CONFIG="$TMPDIR/nixpkgs-config.nix"

    nix-unit --eval-store "$HOME" ${./tests.nix} \
      --arg nixpkgsPath "${lib.cleanSource nixpkgs}"
    touch $out
  ''
