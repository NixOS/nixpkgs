{ lib
, bash
, stdenv
, writeText
, fetchFromGitHub
, libpng
, gzip
, fftw
, openblas
, mpiSupport ? false, mpi ? null
}:

assert mpiSupport -> mpi != null;

stdenv.mkDerivation rec {
  # LAMMPS has weird versioning converted to ISO 8601 format
  version = "patch_2Aug2018";
  name = "lammps-${version}";

  lammps_packages = "asphere body class2 colloid compress coreshell dipole granular kspace manybody mc misc molecule opt peri qeq replica rigid shock snap srd user-reaxc";
  lammps_includes = "-DLAMMPS_EXCEPTIONS -DLAMMPS_GZIP -DLAMMPS_MEMALIGN=64";

  src = fetchFromGitHub {
    owner = "lammps";
    repo = "lammps";
    rev = "${version}";
    sha256 = "1ph9pr7s11wgmspmnhxa55bh1pq2cyl8iimfi62lbpbpl9pr1ilc";
  };

  passthru = {
    inherit mpi;
  };

  buildInputs = [ fftw libpng openblas gzip bash ]
  ++ (stdenv.lib.optionals mpiSupport [ mpi ]);

  # Must do manual build due to LAMMPS requiring a seperate build for
  # the libraries and executable
  builder = writeText "builder.sh" ''
    source $stdenv/setup

    mkdir lammps
    cp -r $src/lib $src/src lammps
    chmod -R 755 lammps/src/
    cd lammps/src
    for pack in ${lammps_packages}; do make "yes-$pack" SHELL=$SHELL; done
    make mode=exe ${if mpiSupport then "mpi" else "serial"} SHELL=$SHELL LMP_INC="${lammps_includes}" FFT_PATH=-DFFT_FFTW3 FFT_LIB=-lfftw3 JPG_LIB=-lpng
    make mode=shlib ${if mpiSupport then "mpi" else "serial"} SHELL=$SHELL LMP_INC="${lammps_includes}" FFT_PATH=-DFFT_FFTW3 FFT_LIB=-lfftw3 JPG_LIB=-lpng

    mkdir -p $out/bin
    cp -v lmp_* $out/bin/

    mkdir -p $out/include
    cp -v *.h $out/include/

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
    maintainers = with lib.maintainers; [ costrouc ];
  };
}
