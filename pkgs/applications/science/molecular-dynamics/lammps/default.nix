{ stdenv, writeText, fetchurl,
  libpng, fftw,
  mpiSupport ? false, mpi ? null
}:

assert mpiSupport -> mpi != null;

stdenv.mkDerivation rec {
  # LAMMPS has weird versioning converted to ISO 8601 format
  version = "2016-02-16";
  name = "lammps-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/lammps/lammps-16Feb16.tar.gz";
    sha256 = "1yzfbkxma3xa1288rnn66h4w0smbmjkwq1fx1y60pjiw0prmk105";
  };

  passthru = {
    inherit mpi;
  };

  buildInputs = [ fftw libpng ]
  ++ (stdenv.lib.optionals mpiSupport [ mpi ]);

  # Must do manual build due to LAMMPS requiring a seperate build for
  # the libraries and executable
  builder = writeText "builder.sh" ''
    source $stdenv/setup

    tar xzf $src
    cd lammps-*/src
    make mode=exe ${if mpiSupport then "mpi" else "serial"} SHELL=$SHELL LMP_INC="-DLAMMPS_GZIP -DLAMMPS_PNG" FFT_PATH=-DFFT_FFTW3 FFT_LIB=-lfftw3 JPG_LIB=-lpng
    make mode=shlib ${if mpiSupport then "mpi" else "serial"} SHELL=$SHELL LMP_INC="-DLAMMPS_GZIP -DLAMMPS_PNG" FFT_PATH=-DFFT_FFTW3 FFT_LIB=-lfftw3 JPG_LIB=-lpng

    mkdir -p $out/bin
    cp -v lmp_* $out/bin/lammps

    mkdir -p $out/lib
    cp -v liblammps* $out/lib/
  '';

  meta = {
    description = "Classical Molecular Dynamics simulation code";
    longDescription = ''
      LAMMPS is a classical molecular dynamics simulation code designed to
      run efficiently on parallel computers. It was developed at Sandia
      National Laboratories, a US Department of Energy facility, with
      funding from the DOE. It is an open-source code, distributed freely
      under the terms of the GNU Public License (GPL).
      '';
    homepage = http://lammps.sandia.gov;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}
