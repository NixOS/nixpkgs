{
  pkgs ? import ../.. { },
}:
let
  prevNixpkgs = pkgs.fetchFromGitHub {
    owner = "nixos";
    repo = "nixpkgs";
    # Parent commit of [#391544](https://github.com/NixOS/nixpkgs/pull/391544)
    # Which was before the type.merge.v2 introduction
    rev = "bcf94dd3f07189b7475d823c8d67d08b58289905";
    hash = "sha256-MuMiIY3MX5pFSOCvutmmRhV6RD0R3CG0Hmazkg8cMFI=";
  };
in
(pkgs.runCommand "lib-cross-eval-merge-v2"
  {
    nativeBuildInputs = [ pkgs.nix-unit ];
  }
  ''
    export HOME=$TMPDIR
    nix-unit --eval-store "$HOME" ${./checkAndMergeCompat.nix} \
      --arg currLibPath "${../.}" \
      --arg prevLibPath "${prevNixpkgs}/lib"
    mkdir $out
  ''
)
