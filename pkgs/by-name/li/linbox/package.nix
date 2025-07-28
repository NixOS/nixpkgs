{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  autoreconfHook,
  givaro,
  pkg-config,
  blas,
  lapack,
  fflas-ffpack,
  gmpxx,
}:

assert (!blas.isILP64) && (!lapack.isILP64);

stdenv.mkDerivation rec {
  pname = "linbox";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "linbox-team";
    repo = "linbox";
    rev = "v${version}";
    sha256 = "sha256-mW84a98KPLqcHMjX3LIYTmVe0ngUdz6RJLpoDaAqKU8=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/linbox-team/linbox/commit/4be26e9ef0eaf36a9909e5008940e8bf7dc625b6.patch";
      sha256 = "PX0Tik7blXOV2vHUq92xMxaADkNoNGiax4qrjQyGK6U=";
    })
    (fetchpatch {
      name = "gcc-14.patch";
      url = "https://github.com/linbox-team/linbox/commit/b8f2d4ccdc0af4418d14f72caf6c4d01969092a3.patch";
      includes = [
        "linbox/matrix/sparsematrix/sparse-ell-matrix.h"
        "linbox/matrix/sparsematrix/sparse-ellr-matrix.h"
      ];
      hash = "sha256-sqwgHkECexR2uX/SwYP7r9ZGHnGG+i4RXtfnvWsVQlk=";
    })
    (fetchpatch {
      name = "clang-19.patch";
      url = "https://github.com/linbox-team/linbox/commit/4f7a9bc830696b2f2c0219feaa74e85202700412.patch";
      hash = "sha256-DoKh8/+2WPbMhN9MhpKmQ5sKmizD9iE81zS/XI0aM9Q=";
    })
    (fetchpatch {
      name = "clang-19.patch";
      url = "https://github.com/linbox-team/linbox/commit/4a1e1395804d4630ec556c61ba3f2cb67e140248.patch";
      hash = "sha256-sCe/8hb27RuMxU1XXWsVU5gaGk2V+T6Ee7yrC5G5Hsc=";
    })
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    givaro
    blas
    gmpxx
    fflas-ffpack
  ];

  configureFlags = [
    "--with-blas-libs=-lblas"
    "--without-archnative"
  ]
  ++ lib.optionals stdenv.hostPlatform.isx86_64 [
    # disable SIMD instructions (which are enabled *when available* by default)
    "--${if stdenv.hostPlatform.sse3Support then "enable" else "disable"}-sse3"
    "--${if stdenv.hostPlatform.ssse3Support then "enable" else "disable"}-ssse3"
    "--${if stdenv.hostPlatform.sse4_1Support then "enable" else "disable"}-sse41"
    "--${if stdenv.hostPlatform.sse4_2Support then "enable" else "disable"}-sse42"
    "--${if stdenv.hostPlatform.avxSupport then "enable" else "disable"}-avx"
    "--${if stdenv.hostPlatform.avx2Support then "enable" else "disable"}-avx2"
    "--${if stdenv.hostPlatform.fmaSupport then "enable" else "disable"}-fma"
    "--${if stdenv.hostPlatform.fma4Support then "enable" else "disable"}-fma4"
  ];

  # https://github.com/linbox-team/linbox/issues/304
  hardeningDisable = [ "fortify3" ];

  doCheck = true;

  enableParallelBuilding = true;

  meta = with lib; {
    description = "C++ library for exact, high-performance linear algebra";
    mainProgram = "linbox-config";
    license = licenses.lgpl21Plus;
    teams = [ teams.sage ];
    platforms = platforms.unix;
    homepage = "https://linalg.org/";
  };
}
