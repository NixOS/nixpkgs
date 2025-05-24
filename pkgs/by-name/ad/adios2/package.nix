{
  lib,
  stdenv,
  fetchFromGitHub,
  perl,
  cmake,
  ninja,
  gfortran,
  pkg-config,
  python3,
  python3Packages,
  mpi,
  bzip2,
  c-blosc2,
  hdf5-mpi,
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
  pythonSupport ? false,
  withExamples ? false,
}:
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
      python3
      python3Packages.pybind11
    ];

  buildInputs =
    [
      mpi
      bzip2
      c-blosc2
      (hdf5-mpi.override { inherit mpi; })
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

      # Todo: add these optional dependcies in nixpkgs.
      # sz
      # mgard
      # catalyst
    ]
    ++ lib.optional (lib.meta.availableOn stdenv.hostPlatform ucx) ucx
    # openmp required by zfp
    ++ lib.optional stdenv.cc.isClang llvmPackages.openmp;

  propagatedBuildInputs = lib.optionals pythonSupport [
    (python3Packages.mpi4py.override { inherit mpi; })
    python3Packages.numpy
  ];

  cmakeFlags = [
    (lib.cmakeBool "ADIOS2_USE_HDF5" true)
    (lib.cmakeBool "ADIOS2_USE_HDF5_VOL" true)
    (lib.cmakeBool "BUILD_TESTING" false)
    (lib.cmakeBool "ADIOS2_BUILD_EXAMPLES" withExamples)
    (lib.cmakeBool "ADIOS2_USE_EXTERNAL_DEPENDENCIES" true)
    (lib.cmakeFeature "CMAKE_INSTALL_BINDIR" "bin")
    (lib.cmakeFeature "CMAKE_INSTALL_LIBDIR" "lib")
    (lib.cmakeFeature "CMAKE_INSTALL_INCLUDEDIR" "include")
    (lib.cmakeFeature "CMAKE_INSTALL_PYTHONDIR" python3.sitePackages)
  ];

  # equired for finding the generated adios2-config.cmake file
  env.adios2_DIR = "${placeholder "out"}/lib/cmake/adios2";

  # Ctest takes too much time, so we only perform some smoke Python tests.
  doInstallCheck = pythonSupport;

  preCheck =
    ''
      export PYTHONPATH=$out/${python3.sitePackages}:$PYTHONPATH
    ''
    + lib.optionalString (stdenv.hostPlatform.system == "aarch64-linux") ''
      rm ../testing/adios2/python/TestBPWriteTypesHighLevelAPI.py
    '';

  pytestFlagsArray = [
    "../testing/adios2/python/Test*.py"
  ];

  pythonImportsCheck = [ "adios2" ];

  nativeInstallCheckInputs = lib.optionals pythonSupport [
    python3Packages.pythonImportsCheckHook
    python3Packages.pytestCheckHook
  ];

  meta = {
    homepage = "https://adios2.readthedocs.io/en/latest/";
    description = "The Adaptable Input/Output System version 2";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ qbisi ];
  };
})
