{ stdenv
, fetchurl
, cmake
, singlePrec ? true
, mpiEnabled ? false
, fftw
, openmpi
, perl
}:

stdenv.mkDerivation {
  name = "gromacs-2020.1";

  src = fetchurl {
    url = "ftp://ftp.gromacs.org/pub/gromacs/gromacs-2020.1.tar.gz";
    sha256 = "1kwrk3i1dxp8abhqqsl049lh361n4910h0415g052f8shdc6arp1";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ fftw perl ]
  ++ (stdenv.lib.optionals mpiEnabled [ openmpi ]);

  cmakeFlags = (
    if singlePrec then [
      "-DGMX_DOUBLE=OFF"
    ] else [
      "-DGMX_DOUBLE=ON"
      "-DGMX_DEFAULT_SUFFIX=OFF"
    ]
  ) ++ (
    if mpiEnabled then [
      "-DGMX_MPI:BOOL=TRUE"
      "-DGMX_CPU_ACCELERATION:STRING=SSE4.1"
      "-DGMX_OPENMP:BOOL=TRUE"
      "-DGMX_THREAD_MPI:BOOL=FALSE"
    ] else [
      "-DGMX_MPI:BOOL=FALSE"
    ]
  );

  meta = with stdenv.lib; {
    homepage = "http://www.gromacs.org";
    license = licenses.gpl2;
    description = "Molecular dynamics software package";
    longDescription = ''
      GROMACS is a versatile package to perform molecular dynamics,
      i.e. simulate the Newtonian equations of motion for systems
      with hundreds to millions of particles.

      It is primarily designed for biochemical molecules like
      proteins, lipids and nucleic acids that have a lot of
      complicated bonded interactions, but since GROMACS is
      extremely fast at calculating the nonbonded interactions (that
      usually dominate simulations) many groups are also using it
      for research on non-biological systems, e.g. polymers.

      GROMACS supports all the usual algorithms you expect from a
      modern molecular dynamics implementation, (check the online
      reference or manual for details), but there are also quite a
      few features that make it stand out from the competition.

      See: http://www.gromacs.org/About_Gromacs for details.
    '';
    platforms = platforms.unix;
  };
}
