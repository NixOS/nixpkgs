{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  calceph,
  withCalceph ? true,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "supernovas";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "smithsonian";
    repo = "supernovas";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2M5gBtjCPdVpLU5YsUWVJoRH1YWMZ48ADHwwc3ZJRPk=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = lib.optionals withCalceph [ calceph ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
    (lib.cmakeBool "ENABLE_CALCEPH" withCalceph)
    (lib.cmakeBool "BUILD_EXAMPLES" false)
  ];

  meta = {
    description = "High-performance astrometry library for C/C++";
    homepage = "https://smithsonian.github.io/SuperNOVAS/";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ kiranshila ];
    platforms = lib.platforms.all;
  };
})
