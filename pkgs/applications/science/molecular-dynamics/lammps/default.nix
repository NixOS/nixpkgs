{ lib
, stdenv
, fetchFromGitHub
, libpng
, gzip
, fftw
, blas
, lapack
, withMPI ? false
, mpi
, cmake
# Available list of packages can be found near here:
# https://github.com/lammps/lammps/blob/develop/cmake/CMakeLists.txt#L222
, packages ? {
  ASPHERE = true;
  BODY = true;
  CLASS2 = true;
  COLLOID = true;
  COMPRESS = true;
  CORESHELL = true;
  DIPOLE = true;
  GRANULAR = true;
  KSPACE = true;
  MANYBODY = true;
  MC = true;
  MISC = true;
  MOLECULE = true;
  OPT = true;
  PERI = true;
  QEQ = true;
  REPLICA = true;
  RIGID = true;
  SHOCK = true;
  ML-SNAP = true;
  SRD = true;
  REAXFF = true;
}
}:

stdenv.mkDerivation rec {
  # LAMMPS has weird versioning converted to ISO 8601 format
  version = "23Jun2022_update4";
  pname = "lammps";

  src = fetchFromGitHub {
    owner = "lammps";
    repo = "lammps";
    rev = "stable_${version}";
    hash = "sha256-zGztc+iUFNIa0KKtfpAhwitInvMmXeTHp1XsOLibfzM=";
  };
  preConfigure = ''
    cd cmake
  '';
  nativeBuildInputs = [
    cmake
  ];

  passthru = {
    inherit mpi;
    inherit packages;
  };
  cmakeFlags = [
  ] ++ (builtins.map (p: "-DPKG_${p}=ON") (builtins.attrNames (lib.filterAttrs (n: v: v) packages)));

  buildInputs = [
    fftw
    libpng
    blas
    lapack
    gzip
  ] ++ lib.optionals withMPI [
    mpi
  ];

  # For backwards compatibility
  postInstall = ''
    ln -s $out/bin/lmp $out/bin/lmp_serial
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
    # compiling lammps with 64 bit support blas and lapack might cause runtime
    # segfaults. In anycase both blas and lapack should have the same #bits
    # support.
    broken = (blas.isILP64 && lapack.isILP64);
    maintainers = [ maintainers.costrouc maintainers.doronbehar ];
  };
}
