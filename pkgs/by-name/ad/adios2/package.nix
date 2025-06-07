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
  yaml-cpp,
  nlohmann_json,
  llvmPackages,
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
    mpi4py = python3Packages.mpi4py.override { inherit mpi; };
  };
in
stdenv.mkDerivation (finalAttrs: {
  version = "2.10.2";
  pname = "adios2";

  src = fetchFromGitHub {
    owner = "ornladios";
    repo = "adios2";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NVyw7xoPutXeUS87jjVv1YxJnwNGZAT4QfkBLzvQbwg=";
  };

  postPatch =
    ''
      patchShebangs cmake/install/post/generate-adios2-config.sh.in
    ''
    # Dynamic cast to nullptr on darwin platform, switch to unsafe reinterpret cast.
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      substituteInPlace bindings/Python/py11{Attribute,Engine,Variable}.cpp \
        --replace-fail "dynamic_cast" "reinterpret_cast"
    '';

  nativeBuildInputs =
    [
      perl
      cmake
      ninja
      gfortran
      pkg-config
    ]
    ++ lib.optionals pythonSupport [
      python3Packages.python
      python3Packages.pybind11
      python3Packages.pythonImportsCheckHook
    ];

  buildInputs =
    [
      bzip2
      c-blosc2
      adios2Packages.hdf5
      libfabric
      libpng
      libsodium
      pugixml
      sqlite
      zeromq
      zfp
      zlib
      yaml-cpp
      nlohmann_json

      # Todo: add these optional dependencies in nixpkgs.
      # sz
      # mgard
      # catalyst
    ]
    ++ lib.optional (lib.meta.availableOn stdenv.hostPlatform ucx) ucx
    # openmp required by zfp
    ++ lib.optional stdenv.cc.isClang llvmPackages.openmp;

  propagatedBuildInputs =
    lib.optional mpiSupport mpi
    ++ lib.optional pythonSupport python3Packages.numpy
    ++ lib.optional (mpiSupport && pythonSupport) adios2Packages.mpi4py;

  cmakeFlags = [
    # adios2 builtin modules
    (lib.cmakeBool "ADIOS2_USE_DataMan" true)
    (lib.cmakeBool "ADIOS2_USE_MHS" true)
    (lib.cmakeBool "ADIOS2_USE_SST" mpiSupport)

    # declare thirdparty dependencies explicitly
    (lib.cmakeBool "ADIOS2_USE_EXTERNAL_DEPENDENCIES" true)
    (lib.cmakeBool "ADIOS2_USE_Blosc2" true)
    (lib.cmakeBool "ADIOS2_USE_BZip2" true)
    (lib.cmakeBool "ADIOS2_USE_ZFP" true)
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
    (lib.cmakeBool "ADIOS2_USE_Catalyst" false)
    (lib.cmakeBool "ADIOS2_USE_Campaign" true)
    (lib.cmakeBool "ADIOS2_USE_AWSSDK" false)

    # Enable support for Little/Big Endian Interoperability
    (lib.cmakeBool "ADIOS2_USE_Endian_Reverse" true)

    (lib.cmakeBool "BUILD_TESTING" false)
    (lib.cmakeBool "ADIOS2_BUILD_EXAMPLES" withExamples)
    (lib.cmakeFeature "CMAKE_INSTALL_BINDIR" "bin")
    (lib.cmakeFeature "CMAKE_INSTALL_LIBDIR" "lib")
    (lib.cmakeFeature "CMAKE_INSTALL_INCLUDEDIR" "include")
    (lib.cmakeFeature "CMAKE_INSTALL_PYTHONDIR" python3Packages.python.sitePackages)
  ];

  # required for finding the generated adios2-config.cmake file
  preInstall = ''
    export adios2_DIR=$out/lib/cmake/adios2
  '';

  # Ctest takes too much time, so we only perform some smoke Python tests.
  doInstallCheck = pythonSupport;

  preCheck =
    ''
      export PYTHONPATH=$out/${python3Packages.python.sitePackages}:$PYTHONPATH
    ''
    + lib.optionalString (stdenv.hostPlatform.system == "aarch64-linux") ''
      rm ../testing/adios2/python/TestBPWriteTypesHighLevelAPI.py
    '';

  pytestFlagsArray = [
    "../testing/adios2/python/Test*.py"
  ];

  pythonImportsCheck = [ "adios2" ];

  nativeInstallCheckInputs = lib.optionals pythonSupport [
    python3Packages.pytestCheckHook
  ];

  passthru.tests.cmake-config = testers.hasCmakeConfigModules {
    moduleNames = [ "adios2" ];
    package = finalAttrs.finalPackage;
  };

  meta = {
    homepage = "https://adios2.readthedocs.io/en/latest/";
    description = "Adaptable Input/Output System version 2";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ qbisi ];
  };
})
