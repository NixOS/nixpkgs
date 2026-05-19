{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  pixman,
  wayland,
  wayland-protocols,
  wayland-scanner,
  tllist,
  unstableGitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mhalo";
  version = "0-unstable-2024-09-14";

  src = fetchFromGitHub {
    owner = "progandy";
    repo = "mhalo";
    rev = "3088f5152f66360828df0e7935b020f6500f540b";
    hash = "sha256-AKardcq/vkU+bMsWSdPXQlrQgl3eer0xJdPvQvy0IVo=";
  };

  __structuredAttrs = true;

  strictDeps = true;

  depsBuildBuild = [ pkg-config ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    pixman
    wayland
    wayland-protocols
    tllist
  ];

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Mouse highlighter for Wayland";
    homepage = "https://github.com/progandy/mhalo";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ eana ];
    mainProgram = "mhalo";
  };
})
