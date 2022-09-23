{ picom, lib, fetchFromGitHub }:

picom.overrideAttrs (oldAttrs: rec {
  pname = "picom-next";
  version = "unstable-2022-08-23";
  src = fetchFromGitHub {
    owner = "yshui";
    repo = "picom";
    rev = "e0758eb5e572d5d7cf28f28e5e409f20e0bd2ded";
    sha256 = "sha256-L0cFkKPFw92dx3P9jlkwgw7/otjUVkVZbOE0UT6gF+I=";
  };
  meta.maintainers = with lib.maintainers; oldAttrs.meta.maintainers ++ [ GKasparov ];
})
