{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
  gfortran,
  mpi,
  python3Packages,
  ctestCheckHook,
  mpiCheckPhaseHook,
  mpiSupport ? true,
  pythonSupport ? false,
  fortranSupport ? false,

  # passthru.tests
  testers,
  catalyst,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "catalyst";
  version = "2.0.0";

  src = fetchFromGitLab {
    domain = "gitlab.kitware.com";
    owner = "paraview";
    repo = "catalyst";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uPb7vgJpKquZVmSMxeWDVMiNkUdYv3oVVKu7t4+zkbs=";
  };

  nativeBuildInputs = [
    cmake
  ]
  ++ lib.optionals pythonSupport [
    python3Packages.python
    python3Packages.pythonImportsCheckHook
  ]
  ++ lib.optionals fortranSupport [
    gfortran
  ];

  propagatedBuildInputs =
    # create meta package providing dist-info for python3Pacakges.catalyst that common cmake build does not do
    lib.optional pythonSupport (
      python3Packages.mkPythonMetaPackage {
        inherit (finalAttrs) pname version meta;
        dependencies =
          with python3Packages;
          [
            numpy
          ]
          ++ lib.optional mpiSupport (mpi4py.override { inherit mpi; });
      }
    )
    ++ lib.optional mpiSupport mpi;

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_INSTALL_BINDIR" "bin")
    (lib.cmakeFeature "CMAKE_INSTALL_LIBDIR" "lib")
    (lib.cmakeFeature "CMAKE_INSTALL_INCLUDEDIR" "include")
    (lib.cmakeBool "CATALYST_USE_MPI" mpiSupport)
    (lib.cmakeBool "CATALYST_WRAP_PYTHON" pythonSupport)
    (lib.cmakeBool "CATALYST_WRAP_FORTRAN" fortranSupport)
    (lib.cmakeBool "CATALYST_BUILD_TESTING" finalAttrs.finalPackage.doCheck)
  ];

  doCheck = true;

  preCheck = lib.optionalString stdenv.hostPlatform.isDarwin ''
    export DYLD_LIBRARY_PATH=$PWD/lib:$DYLD_LIBRARY_PATH
  '';

  __darwinAllowLocalNetworking = mpiSupport;

  nativeCheckInputs = [ ctestCheckHook ] ++ lib.optional mpiSupport mpiCheckPhaseHook;

  disabledTests = lib.optionals fortranSupport [
    # unexpected fortran binding symbol *__iso_c_binding_C_ptr
    "catalyst-abi-nm"
  ];

  pythonImportsCheck = [ "catalyst" ];

  passthru.tests = {
    cmake-config = testers.hasCmakeConfigModules {
      moduleNames = [ "catalyst" ];
      package = finalAttrs.finalPackage;
    };
    serial = catalyst.override { mpiSupport = false; };
    fortran = catalyst.override { fortranSupport = true; };
  };

  meta = {
    description = "In situ visualization and analysis library";
    homepage = "https://kitware.github.io/paraview-catalyst";
    downloadPage = "https://gitlab.kitware.com/paraview/catalyst";
    license = with lib.licenses; [
      bsd3
      # vendored conduit
      bsd3Lbnl
    ];
    maintainers = with lib.maintainers; [ qbisi ];
    platforms = lib.platforms.unix;
  };
})
