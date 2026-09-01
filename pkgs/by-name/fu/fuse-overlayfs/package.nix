{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  fuse3,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fuse-overlayfs";
  version = "1.18";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "fuse-overlayfs";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Us7FKKJrZH5l+NRIEw2b3RTAGw08YfsIBauwH866P8E=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [ fuse3 ];

  enableParallelBuilding = true;
  strictDeps = true;

  outputs = [
    "out"
    "man"
  ];

  passthru.tests = { inherit (nixosTests) podman; };

  meta = {
    description = "FUSE implementation for overlayfs";
    longDescription = "An implementation of overlay+shiftfs in FUSE for rootless containers.";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ ma9e ];
    teams = [ lib.teams.podman ];
    platforms = lib.platforms.linux;
    inherit (finalAttrs.src.meta) homepage;
    mainProgram = "fuse-overlayfs";
  };
})
