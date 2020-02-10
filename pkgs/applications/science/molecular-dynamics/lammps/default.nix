{ stdenv, fetchFromGitHub
, libpng, gzip, fftw, openblas
, cmake, pkgconfig, python2
, mpi ? null
}:
let
  packages = [
    "asphere" "body" "class2" "colloid" "compress" "coreshell" "dipole"
    "granular" "kspace" "manybody" "mc" "meam" "misc" "molecule" "mpiio" "opt"
    "peri" "poems" "qeq" "replica" "rigid" "shock" "snap" "srd" "user-atc"
    "user-fep" "user-manifold" "user-misc" "user-molfile" "user-reaxc"
    "kokkos" "python"
  ];

  lammps_includes = [
    "-DLAMMPS_EXCEPTIONS=yes"
    "-DLAMMPS_GZIP=yes"
    "-DLAMMPS_MEMALIGN=64"
    "-DBUILD_LIB=yes"
  ];

  withMPI = (mpi != null);

in
stdenv.mkDerivation rec {
  # LAMMPS has weird versioning converted to ISO 8601 format
  version = "stable_7Aug2019";
  pname = "lammps";

  src = fetchFromGitHub {
    owner = "lammps";
    repo = "lammps";
    rev = version;
    sha256 = "0yddiyizmqip87jvg76pqa8g3nk4sm0xwzryp9bq276q20l6mamj";
  };

  passthru = {
    inherit mpi;
    inherit packages;
  };

  patchPhase = ''
    substituteInPlace "cmake/CMakeLists.txt" --replace \
      "$ENV{HOME}/.local" \
      "$out"
  '';

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ fftw libpng openblas gzip python2 ]
    ++ (stdenv.lib.optionals withMPI [ mpi ]);

  cmakeFlags = with stdenv;
  map (pkg: "-DPKG_${lib.toUpper pkg}=yes") packages
  ++ lib.optionals withMPI [ "-DBUILD_MPI=yes" ]
  ++ lammps_includes;

  cmakeDir = "../cmake";

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Classical Molecular Dynamics simulation code";
    longDescription = ''
      LAMMPS is a classical molecular dynamics simulation code designed to
      run efficiently on parallel computers. It was developed at Sandia
      National Laboratories, a US Department of Energy facility, with
      funding from the DOE. It is an open-source code, distributed freely
      under the terms of the GNU Public License (GPL).
      '';
    homepage = http://lammps.sandia.gov;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.costrouc ];
  };
}
