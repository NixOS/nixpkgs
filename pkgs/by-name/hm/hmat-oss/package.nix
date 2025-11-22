{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  blas,
  lapack,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hmat-oss";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "jeromerobert";
    repo = "hmat-oss";
    tag = finalAttrs.version;
    hash = "sha256-Yeeqze1J1u1j7a5UrivjCvwJdhBGeBqVouhbnjUrCX8=";
  };

  cmakeFlags = [
    "-DHMAT_GIT_VERSION=OFF"
  ];

  nativeBuildInputs = [
    cmake
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    pkg-config # used to find the LAPACK
  ];

  buildInputs = [
    blas
    lapack
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Hierarchical matrix C/C++ library";
    homepage = "https://github.com/jeromerobert/hmat-oss";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ gdinh ];
  };
})
