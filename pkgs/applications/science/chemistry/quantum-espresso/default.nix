{ lib
, stdenv
, fetchFromGitLab
, gfortran
, fftw
, blas
, lapack
, useMpi ? false
, mpi
}:

stdenv.mkDerivation rec {
  version = "6.6";
  pname = "quantum-espresso";

  src = fetchFromGitLab {
    owner = "QEF";
    repo = "q-e";
    rev = "qe-${version}";
    sha256 = "1mkfmw0fq1dabplzdn6v1abhw0ds55gzlvbx3a9brv493whk21yp";
  };

  passthru = {
    inherit mpi;
  };

  preConfigure = ''
    patchShebangs configure
  '';

  nativeBuildInputs = [ gfortran ];

  buildInputs = [ fftw blas lapack ]
    ++ (lib.optionals useMpi [ mpi ]);

  configureFlags = if useMpi then [ "LD=${mpi}/bin/mpif90" ] else [ "LD=${gfortran}/bin/gfortran" ];

  makeFlags = [ "all" ];

  meta = with lib; {
    description = "Electronic-structure calculations and materials modeling at the nanoscale";
    longDescription = ''
      Quantum ESPRESSO is an integrated suite of Open-Source computer codes for
      electronic-structure calculations and materials modeling at the
      nanoscale. It is based on density-functional theory, plane waves, and
      pseudopotentials.
    '';
    homepage = "https://www.quantum-espresso.org/";
    license = licenses.gpl2;
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
    maintainers = [ maintainers.costrouc ];
  };
}
