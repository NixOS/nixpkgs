{
  stdenv,
  fetchFromGitHub,
  libiconv,
}:

let
  mecab-base = import ./base.nix { inherit fetchFromGitHub libiconv; };
in
stdenv.mkDerivation (
  finalAttrs:
  (
    (mecab-base finalAttrs)
    // {
      pname = "mecab-nodic";
    }
  )
)
