{ stdenv, fetchurl
, gfortran, fftw, openblas
, mpi ? null
}:

stdenv.mkDerivation rec {
  version = "6.4";
  name = "quantum-espresso-${version}";

  src = fetchurl {
    url = "https://gitlab.com/QEF/q-e/-/archive/qe-${version}/q-e-qe-${version}.tar.gz";
    sha256 = "1zjblzf0xzwmhmpjm56xvv8wsv5jmp5a204irzyicmd77p86c4vq";
  };

  passthru = {
    inherit mpi;
  };

  preConfigure = ''
    patchShebangs configure
  '';

  buildInputs = [ fftw openblas gfortran ]
    ++ (stdenv.lib.optionals (mpi != null) [ mpi ]);

configureFlags = if (mpi != null) then [ "LD=${mpi}/bin/mpif90" ] else [ "LD=${gfortran}/bin/gfortran" ];

  makeFlags = [ "all" ];

  meta = with stdenv.lib; {
    description = "Electronic-structure calculations and materials modeling at the nanoscale";
    longDescription = ''
        Quantum ESPRESSO is an integrated suite of Open-Source computer codes for
        electronic-structure calculations and materials modeling at the
        nanoscale. It is based on density-functional theory, plane waves, and
        pseudopotentials.
      '';
    homepage = https://www.quantum-espresso.org/;
    license = licenses.gpl2;
    platforms = [ "x86_64-linux" ];
    maintainers = [ maintainers.costrouc ];
  };
}
