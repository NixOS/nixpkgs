{ lib, stdenv, fetchFromGitHub
, libpng, gzip, fftw, blas, lapack
, withMPI ? false
, mpi
}:
let packages = [
     "asphere" "body" "class2" "colloid" "compress" "coreshell"
     "dipole" "granular" "kspace" "manybody" "mc" "misc" "molecule"
     "opt" "peri" "qeq" "replica" "rigid" "shock" "snap" "srd" "user-reaxc"
    ];
    lammps_includes = "-DLAMMPS_EXCEPTIONS -DLAMMPS_GZIP -DLAMMPS_MEMALIGN=64";
in
stdenv.mkDerivation rec {
  # LAMMPS has weird versioning converted to ISO 8601 format
  version = "stable_29Oct2020";
  pname = "lammps";

  src = fetchFromGitHub {
    owner = "lammps";
    repo = "lammps";
    rev = version;
    sha256 = "1rmi9r5wj2z49wg43xyhqn9sm37n95cyli3g7vrqk3ww35mmh21q";
  };

  passthru = {
    inherit mpi;
    inherit packages;
  };

  buildInputs = [ fftw libpng blas lapack gzip ]
    ++ (lib.optionals withMPI [ mpi ]);

  configurePhase = ''
    cd src
    for pack in ${lib.concatStringsSep " " packages}; do make "yes-$pack" SHELL=$SHELL; done
  '';

  # Must do manual build due to LAMMPS requiring a separate build for
  # the libraries and executable. Also non-typical make script
  buildPhase = ''
    make mode=exe ${if withMPI then "mpi" else "serial"} SHELL=$SHELL LMP_INC="${lammps_includes}" FFT_PATH=-DFFT_FFTW3 FFT_LIB=-lfftw3 JPG_LIB=-lpng
    make mode=shlib ${if withMPI then "mpi" else "serial"} SHELL=$SHELL LMP_INC="${lammps_includes}" FFT_PATH=-DFFT_FFTW3 FFT_LIB=-lfftw3 JPG_LIB=-lpng
  '';

  installPhase = ''
    mkdir -p $out/bin $out/include $out/lib

    cp -v lmp_* $out/bin/
    cp -v *.h $out/include/
    cp -v liblammps* $out/lib/
  '';

  meta = with lib; {
    description = "Classical Molecular Dynamics simulation code";
    longDescription = ''
      LAMMPS is a classical molecular dynamics simulation code designed to
      run efficiently on parallel computers. It was developed at Sandia
      National Laboratories, a US Department of Energy facility, with
      funding from the DOE. It is an open-source code, distributed freely
      under the terms of the GNU Public License (GPL).
      '';
    homepage = "https://lammps.sandia.gov";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.costrouc ];
  };
}
