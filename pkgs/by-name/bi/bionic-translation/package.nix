{
  lib,
  stdenv,
  fetchFromGitLab,
  mesa,
  wayland,
  libglvnd,
  libbsd,
  libunwind,
  libelf,
  meson,
  pkg-config,
  ninja,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bionic-translation";
  version = "0-unstable-2025-07-07";

  src = fetchFromGitLab {
    owner = "android_translation_layer";
    repo = "bionic_translation";
    rev = "18c65637bf02dba86415dd009036b72f62cbb37d";
    hash = "sha256-cqmWT9mbYJRLaX1Ey0lDfRFYM7JXuwayDN4o2WJIAVc=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    libbsd
    libelf
    libglvnd
    libunwind
    mesa
    wayland
  ];

  meta = {
    description = "Set of libraries for loading bionic-linked .so files on musl/glibc";
    homepage = "https://gitlab.com/android_translation_layer/bionic_translation";
    # No license specified yet
    license = lib.licenses.unfree;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ onny ];
  };
})
