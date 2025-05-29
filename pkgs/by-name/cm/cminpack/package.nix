{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
  withBlas ? true,
  blas,
}:

stdenv.mkDerivation rec {
  pname = "cminpack";
  version = "1.3.8";

  src = fetchFromGitHub {
    owner = "devernay";
    repo = "cminpack";
    rev = "v${version}";
    hash = "sha256-eFJ43cHbSbWld+gPpMaNiBy1X5TIcN9aVxjh8PxvVDU=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = lib.optionals withBlas [
    blas
  ];

  cmakeFlags = [
    "-DUSE_BLAS=${if withBlas then "ON" else "OFF"}"
    "-DBUILD_SHARED_LIBS=${if stdenv.hostPlatform.isStatic then "OFF" else "ON"}"
  ];

  meta = {
    description = "Software for solving nonlinear equations and nonlinear least squares problems";
    homepage = "http://devernay.free.fr/hacks/cminpack/";
    changelog = "https://github.com/devernay/cminpack/blob/v${version}/README.md#history";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
    maintainers = [ ];
  };
}
