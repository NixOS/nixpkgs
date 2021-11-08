{ picom, lib, fetchFromGitHub }:

picom.overrideAttrs (oldAttrs: rec {
  pname = "picom-next";
  version = "unstable-2021-10-31";
  src = fetchFromGitHub {
    owner = "yshui";
    repo = "picom";
    rev = "fade045eadf171d2c732820d6ebde7d1943a1397";
    sha256 = "fPiLZ63+Bw5VCxVNqj9i5had2YLa+jFMMf85MYdqvHU=";
  };
  meta.maintainers = with lib.maintainers; oldAttrs.meta.maintainers ++ [ GKasparov ];
})
