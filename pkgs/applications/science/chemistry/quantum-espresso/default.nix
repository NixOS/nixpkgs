{ lib, stdenv, fetchurl
, gfortran, fftw, blas, lapack
, useMpi ? false
, mpi
}:

stdenv.mkDerivation rec {
  version = "6.6";
  pname = "quantum-espresso";

  src = fetchurl {
    url = "https://gitlab.com/QEF/q-e/-/archive/qe-${version}/q-e-qe-${version}.tar.gz";
    sha256 = "0b3718bwdqfyssyz25jknijar79qh5cf1bbizv9faliz135mcilj";
  };

  passthru = {
    inherit mpi;
  };

  preConfigure = ''
    patchShebangs configure
  '';

  buildInputs = [ fftw blas lapack gfortran ]
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
