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
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "scipopt";
    repo = "papilo";
    tag = "v${version}";
    hash = "WMw9v57nuP6MHj9Ft4l5FxdIF5VUWCRm/909tbz7VD4=";
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
