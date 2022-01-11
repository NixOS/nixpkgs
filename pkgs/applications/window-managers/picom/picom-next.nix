{ picom, lib, fetchFromGitHub }:

picom.overrideAttrs (oldAttrs: rec {
  pname = "picom-next";
  version = "unstable-2021-11-19";
  src = fetchFromGitHub {
    owner = "yshui";
    repo = "picom";
    rev = "1c7a4ff5a3cd5f3e25abcac0196896eea5939dce";
    sha256 = "sha256-2uy2ofXhEWKuM+nEUqU16c85UGt6fJGtPZj+az907aw=";
  };
  meta.maintainers = with lib.maintainers; oldAttrs.meta.maintainers ++ [ GKasparov ];
})
