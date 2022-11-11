{ picom, lib, fetchFromGitHub }:

picom.overrideAttrs (oldAttrs: rec {
  pname = "picom-next";
  version = "unstable-2022-09-29";
  src = fetchFromGitHub {
    owner = "yshui";
    repo = "picom";
    rev = "0fe4e0a1d4e2c77efac632b15f9a911e47fbadf3";
    sha256 = "1slcmayja8cszapxzs83xl1i9n9q0dz79cn5gzzf4mfcwvnxp8km";
  };
  meta.maintainers = with lib.maintainers; oldAttrs.meta.maintainers ++ [ GKasparov ];
})
