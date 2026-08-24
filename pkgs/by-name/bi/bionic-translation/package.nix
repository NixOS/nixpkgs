{
  lib,
  stdenv,
  fetchFromGitLab,
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
  version = "0-unstable-2026-08-03";

  src = fetchFromGitLab {
    owner = "android_translation_layer";
    repo = "bionic_translation";
    rev = "484b1b05795784a5a57dbd4ffad21a3e680a33b2";
    hash = "sha256-43VJPhN8/J/pJr8mdV9/n+hrVZLzh7aQhAJ8cT53BHc=";
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
