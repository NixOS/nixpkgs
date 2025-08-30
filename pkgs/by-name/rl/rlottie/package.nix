{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  ninja,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rlottie";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "Samsung";
    repo = "rlottie";
    tag = "v${finalAttrs.version}";
    hash = "sha256-I09AohPpAw63g5DevuqxFD9tsgBScEZaKbTz5H7IfYE=";
  };

  patches = [
    # Fixed build with GCC 11
    (fetchpatch {
      url = "https://github.com/Samsung/rlottie/commit/2d7b1fa2b005bba3d4b45e8ebfa632060e8a157a.patch";
      hash = "sha256-2JPsj0WiBMMu0N3NUYDrHumvPN2YS8nPq5Zwagx6UWE=";
    })
  ];

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ];

  cmakeFlags = [
    (lib.cmakeFeature "LIB_INSTALL_DIR" "${placeholder "out"}/lib")
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
})
