{
  stdenv,
  lib,
  fetchFromGitHub,
  gfortran,
  cmake,
  pkg-config,
  armadillo,
  blas,
  lapack,
}:

stdenv.mkDerivation rec {
  pname = "OpenOrbitalOptimizer";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "susilethola";
    repo = "openorbitaloptimizer";
    rev = "v${version}";
    hash = "sha256-otIs2Y79KoEL4ut8YQe7Y27LpmpId8h/X8B6GIg8l+E=";
  };

  nativeBuildInputs = [
    pkg-config
    cmake
    gfortran
  ];

  buildInputs = [
    armadillo
    blas
    lapack
  ];

  outputs = [
    "out"
    "dev"
  ];

  # Uses a hacky python setup run by cmake, which is hard to get running
  doCheck = false;

  meta = with lib; {
    description = "Common orbital optimisation algorithms for quantum chemistry";
    license = [ licenses.mpl20 ];
    homepage = "https://github.com/susilehtola/OpenOrbitalOptimizer";
    platforms = platforms.linux;
    maintainers = [ maintainers.sheepforce ];
  };
}
