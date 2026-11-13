{
  lib,
  stdenv,
  fetchFromGitLab,
  fetchFromGitHub,
  git,
  cmake,
  gfortran,
  pkg-config,
  fftw,
  blas,
  lapack,
  scalapack,
  hdf5,
  libmbd,
  libxc,
  enableMpi ? true,
  mpi,
}:

assert !blas.isILP64;
assert !lapack.isILP64;

let
  # "rev"s must exactly match the git submodule commits in the QE repo
  gitSubmodules = {
    devxlib = fetchFromGitLab {
      group = "max-centre";
      owner = "components";
      repo = "devicexlib";
      rev = "a6b89ef77b1ceda48e967921f1f5488d2df9226d";
      hash = "sha256-p3fRplVG4YSN6ILNlOwf+aSEhpTJPXqiS1+wnzWVA2U=";
    };

    pw2qmcpack = fetchFromGitHub {
      owner = "QMCPACK";
      repo = "pw2qmcpack";
      rev = "f72ab25fa4ea755c1b4b230ae8074b47d5509c70";
      hash = "sha256-K1Z90xexsUvk4SdEb8FGryRal0GAFoLz3j1h/RT2nYw=";
    };
    # not from nixpkgs as QE links to version 3.1 of wannier90
    wannier90 = fetchFromGitHub {
      owner = "wannier-developers";
      repo = "wannier90";
      rev = "1d6b187374a2d50b509e5e79e2cab01a79ff7ce1";
      hash = "sha256-+Mq7lM6WuwAnK/2FlDz9gNRIg2sRazQRezb3BfD0veY=";
    };
  };

in
stdenv.mkDerivation rec {
  version = "7.6";
  pname = "quantum-espresso";

  src = fetchFromGitLab {
    owner = "QEF";
    repo = "q-e";
    rev = "qe-${version}";
    hash = "sha256-Qt2BG1R+5ZJ9Zciqi1mol1hIT7vGrA8+eKXC3XcmOF4=";
  };

  # add git submodules manually and fix pkg-config file
  prePatch = ''
    chmod -R +rwx external/

    substituteInPlace external/devxlib.cmake \
      --replace-fail "qe_git_submodule_update(external/devxlib)" ""
    substituteInPlace external/wannier90.cmake \
      --replace-fail "qe_git_submodule_update(external/wannier90)" ""
    substituteInPlace external/CMakeLists.txt \
      --replace-fail "qe_git_submodule_update(external/pw2qmcpack)" "" \
      --replace-fail "qe_git_submodule_update(external/d3q)" "" \
      --replace-fail "qe_git_submodule_update(external/qe-gipaw)" ""

    ${toString (
      builtins.attrValues (
        builtins.mapAttrs (name: val: ''
          cp -r ${val}/* external/${name}/.
          chmod -R +rwx external/${name}
        '') gitSubmodules
      )
    )}

    substituteInPlace cmake/quantum_espresso.pc.in \
      --replace-fail 'libdir="''${prefix}/@CMAKE_INSTALL_LIBDIR@"' 'libdir="@CMAKE_INSTALL_FULL_LIBDIR@"' \
      --replace-fail 'includedir="''${prefix}/@CMAKE_INSTALL_INCLUDEDIR@/qe"' 'includedir="@CMAKE_INSTALL_FULL_INCLUDEDIR@/qe"' \
      --replace-fail 'moduledir="''${prefix}/@QE_INSTALL_Fortran_MODULES@/qe"' 'moduledir="@CMAKE_INSTALL_FULL_INCLUDEDIR@/qe"'
  '';

  patches = [
    # adds missing libraries during compilation of test executables
    ./testCmakeLinkTarget.patch
  ];

  passthru = { inherit mpi; };

  nativeBuildInputs = [
    cmake
    gfortran
    git
    pkg-config
  ];

  buildInputs = [
    fftw
    blas
    lapack
    libmbd
    libxc
    hdf5
  ]
  ++ lib.optional enableMpi scalapack;

  propagatedBuildInputs = lib.optional enableMpi mpi;
  propagatedUserEnvPkgs = lib.optional enableMpi mpi;

  cmakeFlags = [
    (lib.strings.cmakeBool "BUILD_SHARED_LIBS" true)
    (lib.strings.cmakeFeature "MBD_ROOT" "${libmbd}")
    (lib.strings.cmakeBool "QE_ENABLE_OPENMP" true)
    (lib.strings.cmakeBool "QE_ENABLE_LIBXCP" true)
    (lib.strings.cmakeBool "QE_ENABLE_HDF5" true)
    (lib.strings.cmakeFeature "QE_ENABLE_PLUGINS" "pw2qmcpack")
    (lib.strings.cmakeBool "QE_ENABLE_MPI" enableMpi)
    (lib.strings.cmakeBool "QE_ENABLE_MPI_MODULE" enableMpi)
    (lib.strings.cmakeBool "QE_ENABLE_SCALAPACK" enableMpi)
  ];

  meta = {
    description = "Electronic-structure calculations and materials modeling at the nanoscale";
    longDescription = ''
      Quantum ESPRESSO is an integrated suite of Open-Source computer codes for
      electronic-structure calculations and materials modeling at the
      nanoscale. It is based on density-functional theory, plane waves, and
      pseudopotentials.
    '';
    homepage = "https://www.quantum-espresso.org/";
    license = lib.licenses.gpl2;
    platforms = [
      "x86_64-linux"
    ];
    maintainers = [ lib.maintainers.costrouc ];
  };
}
