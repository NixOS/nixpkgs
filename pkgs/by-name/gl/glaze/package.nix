{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  openssl,
  enableSIMD ? stdenv.hostPlatform.avx2Support,
  enableSSL ? false,
  # Deprecated, remove after 26.05
  enableInterop ? null,
}:

assert lib.warnIf (enableInterop != null) ''
  glaze: `enableInterop` no longer has any effect and will be removed. Upstream
  dropped the experimental FFI interop implementation and the
  `glaze_BUILD_INTEROP` CMake option in 6.0.0, so please drop it from your
  override.
'' true;

stdenv.mkDerivation (finalAttrs: {
  pname = "glaze";
  version = "8.0.0";

  src = fetchFromGitHub {
    owner = "stephenberry";
    repo = "glaze";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UQsR+b7FHGcC/nNpc7ffRurIyN3xM12PwN2UkrV1dRo=";
  };

  nativeBuildInputs = [ cmake ];
  propagatedBuildInputs = lib.optionals enableSSL [ openssl ];

  # https://github.com/stephenberry/glaze/blob/main/CMakeLists.txt
  cmakeFlags = [
    (lib.cmakeBool "glaze_DISABLE_SIMD_WHEN_SUPPORTED" (!enableSIMD))
    (lib.cmakeBool "glaze_ENABLE_SSL" enableSSL)
    (lib.cmakeBool "glaze_ENABLE_FUZZING" (!stdenv.hostPlatform.isMusl))
  ];

  meta = {
    homepage = "https://stephenberry.github.io/glaze/";
    changelog = "https://github.com/stephenberry/glaze/releases/tag/v${finalAttrs.version}";
    description = "Extremely fast, in memory, JSON and interface library for modern C++";
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      moni
      miniharinn
    ];
    license = lib.licenses.mit;
  };
})
