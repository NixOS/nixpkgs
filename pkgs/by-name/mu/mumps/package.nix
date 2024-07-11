{
  stdenv,
  lib,
  fetchzip,
  fetchFromGitHub,
  cmake,
  gfortran,
  liblapack,
  mpi,
  scalapack,
}:
let
  mumps-src = fetchzip {
    url = "https://mumps-solver.org/MUMPS_5.7.2.tar.gz";
    sha256 = "sha256-8El59ljlxryQF1HsbWzUxquRNuGg7QlKDZ47RyuX/R4=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  name = "mumps";
  version = "5.7.2.0";

  src = fetchFromGitHub {
    owner = "scivision";
    repo = "mumps";
    rev = "v${finalAttrs.version}";
    hash = "sha256-IoVByeXHjxx2a0+rvJqTFl4nngo8XLc1vp//LO4khqk=";
  };

  nativeBuildInputs = [
    cmake
    gfortran
  ];

  buildInputs = [
    liblapack
    mpi
    scalapack
  ];

  patches = [ ./dont-download.diff ];

  cmakeFlags = [ "-DBUILD_SHARED_LIBS=on" ];

  preConfigure = ''
    mkdir -p mumps
    cp -r ${mumps-src}/* mumps
    chmod -R u+w mumps
  '';

  meta = with lib; {
    description = "Parallel sparse direct solver";
    homepage = "http://mumps-solver.org/";
    platforms = platforms.unix;
    license = licenses.cecill-c;
    maintainers = with maintainers; [ mkez ];
  };
})
