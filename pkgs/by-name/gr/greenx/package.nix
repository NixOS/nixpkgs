{
  stdenv,
  lib,
  fetchFromGitHub,
  gfortran,
  cmake,
  pkg-config,
  blas,
  lapack,
}:

stdenv.mkDerivation rec {
  pname = "greenx";
  version = "2.2";

  src = fetchFromGitHub {
    owner = "nomad-coe";
    repo = "greenx";
    rev = "v${version}";
    hash = "sha256-otIs2Y79KoEL4ut8YQe7Y27LpmpId8h/X8B6GIg8l+E=";
  };

  nativeBuildInputs = [
    gfortran
    pkg-config
    cmake
  ];

  buildInputs = [
    blas
    lapack
  ];

  # Uses a hacky python setup run by cmake, which is hard to get running
  doCheck = false;

  preCheck = ''
    export OMP_NUM_THREADS=2
  '';

  meta = with lib; {
    description = "Library for Green’s function based electronic structure theory calculations";
    license = [ licenses.asl20 ];
    homepage = "https://github.com/nomad-coe/greenX";
    platforms = platforms.linux;
    maintainers = [ maintainers.sheepforce ];
  };
}
