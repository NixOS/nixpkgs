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
  version = "1.11.1";

  src = fetchFromGitHub {
    owner = "jeromerobert";
    repo = "hmat-oss";
    tag = finalAttrs.version;
    hash = "sha256-IuCL6d6oAOGnFKKXsqtNaWYVxUKZ1jTDvkA8cIkuU74=";
  };

  cmakeFlags = [
    (lib.cmakeBool "HMAT_GIT_VERSION" false)
    # Find BLAS/LAPACK via pkg-config to avoid linking against Accelerate on Darwin.
    (lib.cmakeBool "BLA_PREFER_PKGCONFIG" true)
    (lib.cmakeFeature "CBLAS_INCLUDE_DIR" "${lib.getDev blas}/include")
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    blas
    lapack
  ];

  meta = {
    description = "Hierarchical matrix C/C++ library";
    homepage = "https://github.com/jeromerobert/hmat-oss";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ gdinh ];
  };
})
