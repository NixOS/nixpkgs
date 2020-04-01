{ stdenv, fetchurl
, gfortran, fftw, openblas
, mpi ? null
}:

stdenv.mkDerivation rec {
  version = "6.5";
  pname = "quantum-espresso";

  src = fetchurl {
    url = "https://gitlab.com/QEF/q-e/-/archive/qe-${version}/q-e-qe-${version}.tar.gz";
    sha256 = "00nnsq1vq579xsmkvwrgs6bdqdcbdlsmcp4yfynnvs40ca52m2r5";
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
    homepage = "https://www.quantum-espresso.org/";
    license = licenses.gpl2;
    platforms = [ "x86_64-linux" ];
    maintainers = [ maintainers.costrouc ];
  };
}
