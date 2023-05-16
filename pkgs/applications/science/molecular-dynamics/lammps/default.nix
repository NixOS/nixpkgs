<<<<<<< HEAD
{ lib
, stdenv
, fetchFromGitHub
, libpng
, gzip
, fftw
, blas
, lapack
, cmake
, cudaPackages
, pkg-config
# Available list of packages can be found near here:
#
# - https://github.com/lammps/lammps/blob/develop/cmake/CMakeLists.txt#L222
# - https://docs.lammps.org/Build_extras.html
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
# Extra cmakeFlags to add as "-D${attr}=${value}"
, extraCmakeFlags ? {}
# Extra `buildInputs` - meant for packages that require more inputs
, extraBuildInputs ? []
}:

stdenv.mkDerivation rec {
  # LAMMPS has weird versioning converted to ISO 8601 format
  version = "2Aug2023";
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pname = "lammps";

  src = fetchFromGitHub {
    owner = "lammps";
    repo = "lammps";
<<<<<<< HEAD
    rev = "stable_${version}";
    hash = "sha256-6T4YAa4iN3pJpODGPW+faR16xxyYYdkHLavtiPUbZ4o=";
  };
  preConfigure = ''
    cd cmake
  '';
  nativeBuildInputs = [
    cmake
    pkg-config
    # Although not always needed, it is needed if cmakeFlags include
    # GPU_API=cuda, and it doesn't users that don't enable the GPU package.
    cudaPackages.autoAddOpenGLRunpathHook
  ];

  passthru = {
    # Remove these at some point - perhaps after release 23.11. See discussion at:
    # https://github.com/NixOS/nixpkgs/pull/238771#discussion_r1235459961
    mpi = throw "`lammps-mpi.passthru.mpi` was removed in favor of `extraBuildInputs`";
    inherit packages;
    inherit extraCmakeFlags;
    inherit extraBuildInputs;
  };
  cmakeFlags = [
  ]
  ++ (builtins.map (p: "-DPKG_${p}=ON") (builtins.attrNames (lib.filterAttrs (n: v: v) packages)))
  ++ (lib.mapAttrsToList (n: v: "-D${n}=${v}") extraCmakeFlags)
  ;

  buildInputs = [
    fftw
    libpng
    blas
    lapack
    gzip
  ] ++ extraBuildInputs
  ;

  postInstall = ''
    # For backwards compatibility
    ln -s $out/bin/lmp $out/bin/lmp_serial
    # Install vim and neovim plugin
    install -Dm644 ../../tools/vim/lammps.vim $out/share/vim-plugins/lammps/syntax/lammps.vim
    install -Dm644 ../../tools/vim/filetype.vim $out/share/vim-plugins/lammps/ftdetect/lammps.vim
    mkdir -p $out/share/nvim
    ln -s $out/share/vim-plugins/lammps $out/share/nvim/site
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    # compiling lammps with 64 bit support blas and lapack might cause runtime
    # segfaults. In anycase both blas and lapack should have the same #bits
    # support.
    broken = (blas.isILP64 && lapack.isILP64);
    maintainers = [ maintainers.costrouc maintainers.doronbehar ];
    mainProgram = "lmp";
=======
    maintainers = [ maintainers.costrouc ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
