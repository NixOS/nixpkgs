{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
  boost,
  blas,
  gmp,
  tbb_2021_11,
  gfortran,
}:

stdenv.mkDerivation rec {
  pname = "scipopt-papilo";
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "scipopt";
    repo = "papilo";
    tag = "v${version}";
    hash = "sha256-oQ9iq5UkFK0ghUx6uxdJIOo5niQjniHegSZptqi2fgE=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    blas
    gmp
    gfortran
    boost
    tbb_2021_11
  ];

  cmakeFlags = [
    (lib.cmakeBool "GMP" true)
    (lib.cmakeBool "QUADMATH" true)
    (lib.cmakeBool "TBB" true)
    (lib.cmakeBool "TBB_DOWNLOAD" false)
    (lib.cmakeBool "SOPLEX" false)
  ];

  meta = {
    maintainers = with lib.maintainers; [ fettgoenner ];
    description = "Parallel Presolve for Integer and Linear Optimization";
    license = lib.licenses.lgpl3;
    homepage = "https://github.com/scipopt/papilo";
    mainProgram = "papilo";
  };
}
