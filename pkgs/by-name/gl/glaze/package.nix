{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  cmake,
  openssl,
  enableSIMD ? stdenv.hostPlatform.avx2Support,
  enableSSL ? true,
  enableInterop ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "glaze";
  version = "9.0.0";

  src = fetchFromGitHub {
    owner = "stephenberry";
    repo = "glaze";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dzvKhaSfaDuJ+yHep+OgC6kTRMW59kOtSDw2KD1drVI=";
  };
  # Rename minify/prettify emit lambda to avoid Qt macro (fixes vicinae until a newer release drops)
  patches = [
    (fetchpatch2 {
      url = "https://patch-diff.githubusercontent.com/raw/stephenberry/glaze/pull/2977.patch";
      hash = "sha256-xNdjTSsbjyLFoIM/wKvA8janCm8SXX8PpjKYnRoR9fg=";
    })
  ];

  nativeBuildInputs = [ cmake ];
  propagatedBuildInputs = lib.optionals enableSSL [ openssl ];

  # https://github.com/stephenberry/glaze/blob/main/CMakeLists.txt
  cmakeFlags = [
    (lib.cmakeBool "glaze_DISABLE_SIMD_WHEN_SUPPORTED" (!enableSIMD))
    (lib.cmakeBool "glaze_ENABLE_SSL" enableSSL)
    (lib.cmakeBool "glaze_BUILD_INTEROP" enableInterop)
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
