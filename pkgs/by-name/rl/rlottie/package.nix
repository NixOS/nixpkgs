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
  version = "0.2-unstable-2026-10-01";

  src = fetchFromGitHub {
    owner = "Samsung";
    repo = "rlottie";
    rev = "ea06d2f29ba01b8d06c00a838d107f5e484ae59b";
    hash = "sha256-p4UUPpH35XTXwlnWJAwtRxfP2DkxlvWEQBxZpt2YMlE=";
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
