{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  mupen64plus,
  libGL,
  vulkan-headers,
  vulkan-loader,
  libhighscore,
  unstableGitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "highscore-mupen64plus-video-parallel";
  version = "0-unstable-2026-04-10";

  src = fetchFromGitHub {
    owner = "highscore-emu";
    repo = "parallel-rdp";
    rev = "cee71758e013b899182ea4e2e77d9d77544a98cc";
    hash = "sha256-4krPaQ+2kTMGxUfGbL9yyz/qp2rTHtOC5F6zE+0NrGo=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    mupen64plus
    libGL
    vulkan-headers
    vulkan-loader
  ];

  passthru.updateScript = unstableGitUpdater {
    hardcodeZeroVersion = true;
  };

  meta = {
    description = "ParaLLEl-RDP with mupen64plus-highscore modifications";
    homepage = "https://github.com/highscore-emu/parallel-rdp";
    license = lib.licenses.mit;
    inherit (libhighscore.meta) maintainers platforms;
  };
})
