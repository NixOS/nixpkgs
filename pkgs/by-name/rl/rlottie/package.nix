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
  version = "0.2-unstable-2026-08-11";

  src = fetchFromGitHub {
    owner = "Samsung";
    repo = "rlottie";
    rev = "27f2f23ece8a98f3e0a870e2c125faaac37e8904";
    hash = "sha256-wEcdPKmS0f6C0A/Rg7vsZGoRi2Uv1EmA31BR2EmIlGg=";
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
