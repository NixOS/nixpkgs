{
  lib,
  stdenv,
  fetchFromGitHub,
  perl,
  cmake,
  ninja,
  gfortran,
  pkg-config,
  python3Packages,
  mpi,
  catalyst,
  bzip2,
  c-blosc2,
  hdf5,
  libfabric,
  libpng,
  libsodium,
  pugixml,
  sqlite,
  zeromq,
  zfp,
  zlib,
  ucx,
  libffi,
  yaml-cpp,
  nlohmann_json,
  openssl,
  gtest,
  ctestCheckHook,
  mpiCheckPhaseHook,
  testers,
  mpiSupport ? true,
  pythonSupport ? false,
  withExamples ? false,
}:
let
  adios2Packages = {
    hdf5 = hdf5.override {
      inherit mpi mpiSupport;
      cppSupport = !mpiSupport;
    };
    catalyst = catalyst.override {
      inherit
        mpi
        mpiSupport
        python3Packages
        pythonSupport
        ;
    };
    mpi4py = python3Packages.mpi4py.override { inherit mpi; };
  };
in
stdenv.mkDerivation (finalAttrs: {
  version = "2.12.1";
  pname = "adios2";

  src = fetchFromGitHub {
    owner = "ornladios";
    repo = "adios2";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3jMvVYYO93/Pu7RW2x5mzTRMrZ3oC3IwGrUz2tSqJxQ=";
  };

  postPatch = ''
    chmod +x cmake/install/post/adios2-config.pre.sh.in
    patchShebangs cmake/install/post/{generate-adios2-config,adios2-config.pre}.sh.in
  '';

  nativeBuildInputs = [
    perl
    cmake
    ninja
    gfortran
    pkg-config
  ]
  ++ lib.optionals pythonSupport [
    python3Packages.python
    python3Packages.nanobind
    python3Packages.pythonImportsCheckHook
  ];

  buildInputs = [
    bzip2
    c-blosc2
    adios2Packages.catalyst
    adios2Packages.hdf5
    libfabric
    libpng
    libsodium
    pugixml
    sqlite
    zeromq
    zlib
    yaml-cpp
    nlohmann_json
    openssl

    # Todo: add these optional dependencies in nixpkgs.
    # sz
    # mgard
  ]
  ++ lib.optional (lib.meta.availableOn stdenv.hostPlatform ucx) ucx
  ++ lib.optional (stdenv.hostPlatform.isLoongArch64) libffi
  ++ lib.optional (lib.meta.availableOn stdenv.hostPlatform zfp) zfp;

  propagatedBuildInputs =
    lib.optional mpiSupport mpi
    # create meta package providing dist-info for python3Packages.adios2
    ++ lib.optional pythonSupport (
      python3Packages.mkPythonMetaPackage {
        inherit (finalAttrs) pname version meta;
        dependencies = [
          python3Packages.numpy
        ]
        ++ lib.optional mpiSupport adios2Packages.mpi4py;
      }
    );

  cmakeFlags = [
    # adios2 builtin modules
    (lib.cmakeBool "ADIOS2_USE_DataMan" true)
    (lib.cmakeBool "ADIOS2_USE_MHS" true)
    (lib.cmakeBool "ADIOS2_USE_SST" mpiSupport)

    # declare thirdparty dependencies explicitly
    (lib.cmakeBool "ADIOS2_USE_EXTERNAL_DEPENDENCIES" true)
    (lib.cmakeBool "ADIOS2_USE_EXTERNAL_PERFSTUBS" false)
    (lib.cmakeBool "ADIOS2_USE_Blosc2" true)
    (lib.cmakeBool "ADIOS2_USE_BZip2" true)
    (lib.cmakeBool "ADIOS2_USE_ZFP" (lib.meta.availableOn stdenv.hostPlatform zfp))
    (lib.cmakeBool "ADIOS2_USE_SZ" false)
    (lib.cmakeBool "ADIOS2_USE_LIBPRESSIO" false)
    (lib.cmakeBool "ADIOS2_USE_MGARD" false)
    (lib.cmakeBool "ADIOS2_USE_PNG" true)
    (lib.cmakeBool "ADIOS2_USE_CUDA" false)
    (lib.cmakeBool "ADIOS2_USE_Kokkos" false)
    (lib.cmakeBool "ADIOS2_USE_MPI" mpiSupport)
    (lib.cmakeBool "ADIOS2_USE_DAOS" false)
    (lib.cmakeBool "ADIOS2_USE_DataSpaces" false)
    (lib.cmakeBool "ADIOS2_USE_ZeroMQ" true)
    (lib.cmakeBool "ADIOS2_USE_HDF5" true)
    (lib.cmakeBool "ADIOS2_USE_HDF5_VOL" true)
    (lib.cmakeBool "ADIOS2_USE_IME" false)
    (lib.cmakeBool "ADIOS2_USE_Python" pythonSupport)
    (lib.cmakeBool "ADIOS2_USE_Fortran" true)
    (lib.cmakeBool "ADIOS2_USE_UCX" (lib.meta.availableOn stdenv.hostPlatform ucx))
    (lib.cmakeBool "ADIOS2_USE_Sodium" true)
    (lib.cmakeBool "ADIOS2_USE_Catalyst" true)
    (lib.cmakeBool "ADIOS2_USE_OpenSSL" true)
    (lib.cmakeBool "ADIOS2_USE_Campaign" true)
    (lib.cmakeBool "ADIOS2_USE_AWSSDK" false)

    (lib.cmakeBool "BUILD_TESTING" finalAttrs.finalPackage.doCheck)
    # higher MPIEXEC_MAX_NUMPROCS>8 might cause tests failure in
    #   - Engine.BP.BPJoinedArray.MultiBlock.BP4.MPI
    #   - Engine.BP.BPJoinedArray.MultiBlock.BP5.MPI
    #   - Bindings.Fortran.BPWriteReadHeatMap6D.MPI
    # due to insufficiently robust data generation and comparison for larger MPI sizes.
    (lib.cmakeFeature "MPIEXEC_MAX_NUMPROCS" "4")

    # Enable support for Little/Big Endian Interoperability
    (lib.cmakeBool "ADIOS2_USE_Endian_Reverse" true)

    # force use of "-fallow-argument-mismatch"
    (lib.cmakeBool "ADIOS2_USE_Fortran_flag_argument_mismatch" true)

    (lib.cmakeBool "ADIOS2_BUILD_EXAMPLES" withExamples)
    (lib.cmakeFeature "CMAKE_INSTALL_BINDIR" "bin")
    (lib.cmakeFeature "CMAKE_INSTALL_LIBDIR" "lib")
    (lib.cmakeFeature "CMAKE_INSTALL_INCLUDEDIR" "include")
    (lib.cmakeFeature "CMAKE_INSTALL_PYTHONDIR" python3Packages.python.sitePackages)
  ]
  ++ lib.optional pythonSupport (
    lib.cmakeFeature "nanobind_DIR" "${python3Packages.nanobind}/${python3Packages.python.sitePackages}/nanobind/cmake"
  );

  # python binding libraries should be linked against installed libraries
  preInstall = lib.optionalString pythonSupport ''
    export adios2_DIR=$out/lib/cmake/adios2
  '';

  # Tests are time-consuming and moved to passthru.tests.withCheck.
  doCheck = false;
  dontUseNinjaCheck = true;

  enableParallelChecking = false;

  __darwinAllowLocalNetworking = finalAttrs.finalPackage.doCheck && mpiSupport;

  nativeCheckInputs = [
    python3Packages.python
    gtest
    ctestCheckHook
    mpiCheckPhaseHook
  ];

  pythonImportsCheck = [ "adios2" ];

  passthru.tests = {
    cmake-config = testers.hasCmakeConfigModules {
      moduleNames = [ "adios2" ];
      package = finalAttrs.finalPackage;
    };
  }
  // lib.optionalAttrs stdenv.hostPlatform.isLinux {
    withCheck = finalAttrs.finalPackage.overrideAttrs {
      doCheck = true;
    };
  };

  meta = {
    homepage = "https://adios2.readthedocs.io/en/latest/";
    description = "Adaptable Input/Output System version 2";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ qbisi ];
  };
})
