{ stdenv
, lib
, gfortran
, fetchFromGitHub
, cmake
, blas
, lapack
, python3Packages
}:

assert blas.isILP64 == lapack.isILP64;

stdenv.mkDerivation rec {
  pname = "mopac";
  version = "23.0.2";

  src = fetchFromGitHub {
    owner = "openmopac";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-FHJ8R8s82qSt4l6IawODkHhk2jitcxjUXCgZOU9iXDM=";
  };

  nativeBuildInputs = [ gfortran cmake ];

  buildInputs = [ blas lapack ];

  checkInputs = with python3Packages; [ python numpy ];

  doCheck = true;

  preCheck = ''
    export OMP_NUM_THREADS=2
  '';

  meta = with lib; {
    description = "Semiempirical quantum chemistry";
    homepage = "https://github.com/openmopac/mopac";
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ sheepforce markuskowa ];
  };
}
