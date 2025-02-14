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
  version = "0.5-unstable-2025-01-19";

  src = fetchFromGitHub {
    owner = "drowe67";
    repo = "LPCNet";
    rev = "c8e51ac5e2fe674849cb53e7da44689b572cc246";
    sha256 = "sha256-0Knoym+deTuFAyJrrD55MijVh6DlhJp3lss66BJUHiA=";
  };

  nativeBuildInputs = [ cmake ];

  patches = [
    # extracted from https://github.com/drowe67/LPCNet/pull/59
    ./darwin.patch
  ];

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
