{ lib
, buildGoModule
, fetchFromGitHub
}:

let
  finalAttrs = {
    pname = "fm";
    version = "1.1.0";

    src = fetchFromGitHub {
      owner = "mistakenelf";
      repo = "fm";
      rev = "v${finalAttrs.version}";
      hash = "sha256-m0hjLXgaScJydwiV00b8W7f1y1Ka7bbYqcMPAOw1j+c=";
    };

    vendorHash = "sha256-/tUL08Vo3W7PMPAnJA9RPdMl0AwZj8BzclYs2257nqM=";

    meta = {
      homepage = "https://github.com/mistakenelf/fm";
      description = "Terminal based file manager";
      changelog = "https://github.com/mistakenelf/fm/releases/tag/${finalAttrs.src.rev}";
      license = with lib.licenses; [ mit ];
      mainProgram = "fm";
      maintainers = with lib.maintainers; [ AndersonTorres ];
    };
  };
in
buildGoModule finalAttrs
