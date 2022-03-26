{ picom, lib, fetchFromGitHub }:

picom.overrideAttrs (oldAttrs: rec {
  pname = "picom-next";
  version = "unstable-2022-02-05";
  src = fetchFromGitHub {
    owner = "yshui";
    repo = "picom";
    rev = "928963721c8789fc5f27949e8b0730771aab940d";
    sha256 = "sha256-qu9HnUG5VQbiSgduW1oR/tVvzEckaD2TWzds4R5zI+Y=";
  };
  meta.maintainers = with lib.maintainers; oldAttrs.meta.maintainers ++ [ GKasparov ];
})
