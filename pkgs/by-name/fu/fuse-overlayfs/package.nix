{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  fuse3,
  nixosTests,
}:

stdenv.mkDerivation rec {
  pname = "fuse-overlayfs";
<<<<<<< HEAD
  version = "1.16";
=======
  version = "1.15";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "containers";
    repo = "fuse-overlayfs";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-FwAv5PmiBz25PNH/IEIV6cHjhlE+1mDTrgvR2vN++ZY=";
=======
    hash = "sha256-awVDq87lxMtpTADhy8k95N/4yuGH+2Fn94j3JZzkuUY=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [ fuse3 ];

  enableParallelBuilding = true;
  strictDeps = true;

  passthru.tests = { inherit (nixosTests) podman; };

<<<<<<< HEAD
  meta = {
    description = "FUSE implementation for overlayfs";
    longDescription = "An implementation of overlay+shiftfs in FUSE for rootless containers.";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ ma9e ];
    teams = [ lib.teams.podman ];
    platforms = lib.platforms.linux;
=======
  meta = with lib; {
    description = "FUSE implementation for overlayfs";
    longDescription = "An implementation of overlay+shiftfs in FUSE for rootless containers.";
    license = licenses.gpl3;
    maintainers = with maintainers; [ ma9e ];
    teams = [ teams.podman ];
    platforms = platforms.linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    inherit (src.meta) homepage;
    mainProgram = "fuse-overlayfs";
  };
}
