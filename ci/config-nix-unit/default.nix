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
    nix-unit --eval-store "$HOME" ${./tests.nix} \
      --arg nixpkgsPath "${lib.cleanSource nixpkgs}"
    touch $out
  ''
