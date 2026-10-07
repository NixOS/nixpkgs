{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  givaro,
  pkg-config,
  blas,
  lapack,
  gmpxx,
  fetchpatch2,
}:

assert (!blas.isILP64) && (!lapack.isILP64);

stdenv.mkDerivation rec {
  pname = "fflas-ffpack";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "linbox-team";
    repo = "fflas-ffpack";
    rev = "v${version}";
    sha256 = "sha256-Eztc2jUyKRVUiZkYEh+IFHkDuPIy+Gx3ZW/MsuOVaMc=";
  };

  patches = [
    (fetchpatch2 {
      name = "detect-openmp.patch";
      url = "https://github.com/linbox-team/fflas-ffpack/commit/833bb2fa4e87e51e3f7fa1d97f3b4372c1ee4200.patch?full_index=1";
      hash = "sha256-COJxb1Y47rLBogJuXzznKHOSs9gAX1BtN+j8pEqOhLY=";
      excludes = [ "benchmarks/*" ];
    })
    (fetchpatch2 {
      name = "do-not-use-_mm_permute_ps-for-simd128_float.patch";
      url = "https://github.com/linbox-team/fflas-ffpack/commit/be33b602ecdef543a30ea494899b08610c7e0a74.patch?full_index=1";
      hash = "sha256-YWUFnPViXwyyHLXuewX6KQsgUiwgl6vfYnZX2JzgkE4=";
    })
  ];

  nativeCheckInputs = [
    gmpxx
  ];

  enableParallelBuilding = true;

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ]
  ++ lib.optionals doCheck nativeCheckInputs;

  buildInputs = [
    givaro
    blas
    lapack
  ];

  configureFlags = [
    "--with-blas-libs=-lcblas"
    "--with-lapack-libs=-llapacke"
    "--without-archnative"
  ];
  doCheck = true;

  meta = {
    description = "Finite Field Linear Algebra Subroutines";
    mainProgram = "fflas-ffpack-config";
    license = lib.licenses.lgpl21Plus;
    teams = [ lib.teams.sage ];
    platforms = lib.platforms.unix;
    homepage = "https://linbox-team.github.io/fflas-ffpack/";
  };
}
