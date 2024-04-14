{ lib
, buildGoModule
, fetchFromGitHub
, stdenv
}:

let
  finalAttrs = {
    pname = "fm";
    version = "1.0.0";

    src = fetchFromGitHub {
      owner = "mistakenelf";
      repo = "fm";
      rev = "v${finalAttrs.version}";
      hash = "sha256-j92xf75JTLBaVr8GjAwlqgrieZCifVaIBy9ZMoDIaEY=";
    };

    vendorHash = "sha256-iDKDUpxaV/ZGKvTeNu4m5X/tqQA311Nb+2gvrehpdpw=";

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
