{ lib
, buildGoModule
, fetchFromGitHub
, stdenv
}:

let
  finalAttrs = {
    pname = "fm";
    version = "0.16.0";

    src = fetchFromGitHub {
      owner = "mistakenelf";
      repo = "fm";
      rev = "v${finalAttrs.version}";
      hash = "sha256-wiACaszbkO9jBYmIfeQpcx984RY41Emyu911nkJxUFY=";
    };

    vendorHash = "sha256-AfRGoKiVZGVIbsDj5pV1zCkp2FpcfWKS0t+cTU51RRc=";

    meta = {
      homepage = "https://github.com/mistakenelf/fm";
      description = "A terminal based file manager";
      changelog = "https://github.com/mistakenelf/fm/releases/tag/${finalAttrs.src.rev}";
      license = with lib.licenses; [ mit ];
      mainProgram = "fm";
      maintainers = with lib.maintainers; [ AndersonTorres ];
    };
  };
in
buildGoModule finalAttrs
