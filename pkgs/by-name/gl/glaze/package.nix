{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  openssl,
  enableSIMD ? false,
  enableSSL ? true,
  enableInterop ? true,
}:

stdenv.mkDerivation (final: {
  pname = "glaze";
  version = "6.0.0";

  src = fetchFromGitHub {
    owner = "stephenberry";
    repo = "glaze";
    tag = "v${final.version}";
    hash = "sha256-4bEBnPLp7v6Jrd8h6q5LJc93om2VP3ZqB4JNSpKzPao=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = lib.optionals enableSSL [ openssl ];

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
