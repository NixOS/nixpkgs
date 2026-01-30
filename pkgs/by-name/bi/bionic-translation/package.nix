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
  version = "0-unstable-2025-11-25";

  src = fetchFromGitLab {
    owner = "android_translation_layer";
    repo = "bionic_translation";
    rev = "5c31d4366fbb0af70690e72e5a861e7b44ffb1ef";
    hash = "sha256-dlHjx6+yymvIjDEs2TZexZUIUz32iKD0r+H4AJ89xig=";
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
