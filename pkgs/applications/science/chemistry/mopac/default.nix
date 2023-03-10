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
  version = "22.0.6";

  src = fetchFromGitHub {
    owner = "openmopac";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-j4AP3tki+Ep9Pv+pDg8TwCiJvpF2j5npW3Kpat+7gGg=";
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
