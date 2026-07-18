{
  lib,
  stdenv,
  fetchFromGitHub,
  eglexternalplatform,
  pkg-config,
  meson,
  ninja,
  wayland-scanner,
  libGL,
  libgbm,
  libdrm,
  wayland,
  wayland-protocols,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "egl-wayland2";
  version = "1.0.1-unstable-2026-07-07";

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "egl-wayland2";
    rev = "b2834a6c05ea0892edf1aaf15f0f0d72418a2a0f";
    hash = "sha256-sYknMcjFLFHFb3lw5XgTLWBWPXawn5mjpyZTf7ZxLlk=";
  };

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    libGL
    libgbm
    libdrm
    wayland
    wayland-protocols
    eglexternalplatform
  ];

  absolutizeEglExternalPlatformIcdJson = true;

  strictDeps = true;
  __structuredAttrs = true;

  passthru.updateScript = nix-update-script { extraArgs = [ "--use-github-releases" ]; };

  meta = {
    description = "Dma-buf-based Wayland external platform library";
    homepage = "https://github.com/NVIDIA/egl-wayland2/";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      vancluever
      ccicnce113424
    ];
  };
})
