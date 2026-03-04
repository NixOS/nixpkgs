{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  openssl,
  enableSIMD ? stdenv.hostPlatform.avx2Support,
  enableSSL ? true,
  enableInterop ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "glaze";
  version = "7.1.0";

  src = fetchFromGitHub {
    owner = "stephenberry";
    repo = "glaze";
    tag = "v${finalAttrs.version}";
    hash = "sha256-W48BDsxUrFjjqUFwBcBqHr5Y7h+BtGGWdioGukBqzbE=";
  };

  nativeBuildInputs = [ cmake ];
  propagatedBuildInputs = lib.optionals enableSSL [ openssl ];

  # https://github.com/stephenberry/glaze/blob/main/CMakeLists.txt
  cmakeFlags = [
    (lib.cmakeBool "glaze_DISABLE_SIMD_WHEN_SUPPORTED" (!enableSIMD))
    (lib.cmakeBool "glaze_ENABLE_SSL" enableSSL)
    (lib.cmakeBool "glaze_BUILD_INTEROP" enableInterop)
  ];

  meta = {
    description = "Extremely fast, in memory, JSON and interface library for modern C++";
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ moni ];
    license = lib.licenses.mit;
  };
})
