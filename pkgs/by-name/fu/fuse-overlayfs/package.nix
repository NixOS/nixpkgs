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
  version = "1.15";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "fuse-overlayfs";
    rev = "v${version}";
    hash = "sha256-awVDq87lxMtpTADhy8k95N/4yuGH+2Fn94j3JZzkuUY=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [ fuse3 ];

  enableParallelBuilding = true;
  strictDeps = true;

  passthru.tests = { inherit (nixosTests) podman; };

  meta = with lib; {
    description = "FUSE implementation for overlayfs";
    longDescription = "An implementation of overlay+shiftfs in FUSE for rootless containers.";
    license = licenses.gpl3;
    maintainers = with maintainers; [ ma9e ];
    teams = [ teams.podman ];
    platforms = platforms.linux;
    inherit (src.meta) homepage;
    mainProgram = "fuse-overlayfs";
  };
}
