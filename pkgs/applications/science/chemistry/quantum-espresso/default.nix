{ lib
, stdenv
, fetchFromGitLab
, fetchFromGitHub
, git
, cmake
, gnum4
, gfortran
, pkg-config
, fftw
, blas
, lapack
, scalapack
, wannier90
, hdf5
, libmbd
, libxc
, enableMpi ? true
, mpi
}:

assert ! blas.isILP64;
assert ! lapack.isILP64;

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
  };

in
stdenv.mkDerivation rec {
  version = "7.2";
  pname = "quantum-espresso";

  src = fetchFromGitLab {
    owner = "QEF";
    repo = "q-e";
    rev = "qe-${version}";
    hash = "sha256-0q0QWX4BVjVHjcbKOBpjbBADuL+2S5LAALyrxmjVs4c=";
  };

  # add git submodules manually and fix pkg-config file
  prePatch = ''
    chmod -R +rwx external/

    substituteInPlace external/devxlib.cmake \
      --replace "qe_git_submodule_update(external/devxlib)" ""
    substituteInPlace external/CMakeLists.txt \
      --replace "qe_git_submodule_update(external/pw2qmcpack)" "" \
      --replace "qe_git_submodule_update(external/d3q)" "" \
      --replace "qe_git_submodule_update(external/qe-gipaw)" ""

    ${builtins.toString (builtins.attrValues
      (builtins.mapAttrs
        (name: val: ''
          cp -r ${val}/* external/${name}/.
          chmod -R +rwx external/${name}
        '')
        gitSubmodules
      )
    )}

    substituteInPlace cmake/quantum_espresso.pc.in \
      --replace 'libdir="''${prefix}/@CMAKE_INSTALL_LIBDIR@"' 'libdir="@CMAKE_INSTALL_FULL_LIBDIR@"'
  '';

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
    wannier90
    libmbd
    libxc
    hdf5
  ] ++ lib.optional enableMpi scalapack;

  propagatedBuildInputs = lib.optional enableMpi mpi;
  propagatedUserEnvPkgs = lib.optional enableMpi mpi;

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DWANNIER90_ROOT=${wannier90}"
    "-DMBD_ROOT=${libmbd}"
    "-DQE_ENABLE_OPENMP=ON"
    "-DQE_ENABLE_LIBXC=ON"
    "-DQE_ENABLE_HDF5=ON"
    "-DQE_ENABLE_PLUGINS=pw2qmcpack"
  ] ++ lib.optionals enableMpi [
    "-DQE_ENABLE_MPI=ON"
    "-DQE_ENABLE_MPI_MODULE=ON"
    "-DQE_ENABLE_SCALAPACK=ON"
  ];

  meta = with lib; {
    description = "Electronic-structure calculations and materials modeling at the nanoscale";
    longDescription = ''
      Quantum ESPRESSO is an integrated suite of Open-Source computer codes for
      electronic-structure calculations and materials modeling at the
      nanoscale. It is based on density-functional theory, plane waves, and
      pseudopotentials.
    '';
    homepage = "https://www.quantum-espresso.org/";
    license = licenses.gpl2;
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
    maintainers = [ maintainers.costrouc ];
  };
}
