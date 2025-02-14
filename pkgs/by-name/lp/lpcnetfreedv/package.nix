{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  cmake,
  nix-update-script,
}:

let
  dataVersion = "191005_v1.0";
  data = fetchurl {
    url = "http://rowetel.com/downloads/deep/lpcnet_${dataVersion}.tgz";
    sha256 = "sha256-UJRAkkdR/dh/+qVoPuPd3ZN69cgzuRBMzOZdUWFJJsg=";
  };
in
stdenv.mkDerivation {
  pname = "lpcnetfreedv";
  version = "unstable-2022-08-22";

  src = fetchFromGitHub {
    owner = "drowe67";
    repo = "LPCNet";
    rev = "67a6eb74d0c07faddcdce199856862cc45779d25";
    sha256 = "sha256-eHYZoDgoZBuuLvQn9X7H/zmK5onOAniOgY1/8RVn8gk=";
  };

  nativeBuildInputs = [ cmake ];

  postPatch = ''
    mkdir build
    ln -s ${data} build/lpcnet_${dataVersion}.tgz
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    homepage = "https://freedv.org/";
    description = "Experimental Neural Net speech coding for FreeDV";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ mvs ];
    platforms = lib.platforms.all;
  };
}
