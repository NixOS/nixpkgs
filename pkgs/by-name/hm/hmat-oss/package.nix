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
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "jeromerobert";
    repo = "hmat-oss";
    tag = finalAttrs.version;
    hash = "sha256-GnFlvZCEzSCcBVLjFWLe+AKXVA6UMs/gycrOJ2TBqrE=";
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

  # Accelerate marks old CBLAS symbols deprecated, triggering -Werror.
  #   error: 'cblas_saxpy' is deprecated: first deprecated in macOS 13.3 - An updated CBLAS interface supporting ILP64 is available.  Please compile with -DACCELERATE_NEW_LAPACK to access the new headers and -DACCELERATE_LAPACK_ILP64 for ILP64 support. [-Werror,-Wdeprecated-declarations]
  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isDarwin "-Wno-error=deprecated-declarations";

  enableParallelBuilding = true;

  meta = {
    description = "Hierarchical matrix C/C++ library";
    homepage = "https://github.com/jeromerobert/hmat-oss";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ gdinh ];
  };
})
