{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  meson,
  ninja,
  pkg-config,
}:

stdenv.mkDerivation {
  pname = "rlottie";
  version = "0.2-unstable-2026-07-03";

  src = fetchFromGitHub {
    owner = "Samsung";
    repo = "rlottie";
    rev = "f487eff2f8086b84ae1c7faa0418abec909e874b";
    hash = "sha256-/Sv5qX1V6VltJN0+bkKU2utaj8Yw1owb0KjJFWv41Js=";
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
