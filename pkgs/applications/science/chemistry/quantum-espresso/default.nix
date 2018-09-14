{ stdenv, fetchurl
, gfortran, fftw, openblas
, mpi ? null
}:

stdenv.mkDerivation rec {
  version = "6.3";
  name = "quantum-espresso-${version}";

  src = fetchurl {
    url = "https://gitlab.com/QEF/q-e/-/archive/qe-${version}/q-e-qe-${version}.tar.gz";
    sha256 = "1738z3nhkzcrgnhnfg1r4lipbwvcrcprwhzjbjysnylmzbzwhrs0";
  };

  passthru = {
    inherit mpi;
  };

  preConfigure = ''
    patchShebangs configure
  '';

  # remove after 6.3 version:
  # makefile needs to ignore install directory easier than applying patch
  preInstall = ''
    printf "\n.PHONY: install\n" >> Makefile
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
