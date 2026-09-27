{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  unstableGitUpdater,
  meson,
  ninja,
  pkg-config,
}:

stdenv.mkDerivation {
  pname = "rlottie";
  version = "0.2-unstable-2026-09-11";

  src = fetchFromGitHub {
    owner = "Samsung";
    repo = "rlottie";
    rev = "683bbaa39dd0d366cf6b4bc300b4dfbee677ea6b";
    hash = "sha256-4XP/bqMWgJW/XbR0rb8N3U5YMpXhwaQ6oQG9+7Jw5bs=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  patches = [
    # rename format to run-clang-format to avoid conflict
    ./rename_format_to_run-clang-format.patch
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString (
    stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64
  ) "-U__ARM_NEON__";

  passthru.updateScript = unstableGitUpdater {
    tagPrefix = "v";
  };

  meta = {
    homepage = "https://github.com/Samsung/rlottie";
    description = "Platform independent standalone c++ library for rendering vector based animations and art in realtime";
    license = with lib.licenses; [
      mit
      bsd3
      mpl11
      ftl
    ];
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ CRTified ];
  };
}
