{
  lib,
  stdenv,
  fetchFromGitHub,
  gfortran,
  mpi,
  git,
  cmake,
  python3Packages,
  blas,
  lapack,
  mumps_par,
  hypre,
  suitesparse,
  catch2,
  mpiCheckPhaseHook,
  avxSupport ? python3Packages.netgen-mesher.avxSupport,
  avx2Support ? python3Packages.netgen-mesher.avx2Support,
  avx512Support ? python3Packages.netgen-mesher.avx512Support,
  advSimdSupport ? false,
}:
assert advSimdSupport -> stdenv.hostPlatform.isAarch64;
let
  ngscxxInclude = toString [
    "-I${python3Packages.pybind11}/include"
    "-I${python3Packages.netgen-mesher}/include"
    "-I${python3Packages.netgen-mesher}/include/include"
  ];
  ngsldFlags = toString [
    "-L${python3Packages.netgen-mesher}/lib"
    "-L${mumps_par}/lib"
    "-L${suitesparse}/lib"
  ];
  archFlags = toString (
    lib.optional avxSupport "-mavx"
    ++ lib.optional avx2Support "-mavx2"
    ++ lib.optional avx512Support "-mavx512"
    ++ lib.optional advSimdSupport "-march=armv8.3-a+simd"
    # disalbe some compiler warning for aarch64 specified target
    # https://gcc.gnu.org/gcc-10/changes.html
    ++ lib.optional (stdenv.hostPlatform.isAarch64 && stdenv.hostPlatform.isLinux) "-Wno-psabi"
  );
in
stdenv.mkDerivation (finalAttrs: {
  pname = "ngsolve";
  version = "6.2.2501";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ngsolve";
    repo = "ngsolve";
    tag = "v${finalAttrs.version}";
    hash = "sha256-COba5y18i8PRcm3nmQDEB+H+2cbdA32wqMtxzCPOdO8=";
  };

  patches = [
    ./fix-hypre.patch
    ./use-local-catch2.patch

    # looks for a shared mumps library
    ./fix-findMumps.patch
  ];

  postPatch = ''
    substituteInPlace cmake/generate_version_file.cmake \
      --replace-fail "Git REQUIRED" "Git"
    echo "v${finalAttrs.version}-0" > version.txt

    echo -e "\nfrom mpi4py import MPI" >> tests/pytest/conftest.py

    substituteInPlace py_tutorials/mixed.py tests/pytest/test_periodic.py \
      --replace-fail "fes.FreeDofs()" "fes.FreeDofs(),inverse='umfpack'"

    substituteInPlace python/CMakeLists.txt \
      --replace-fail ''\'''${CMAKE_INSTALL_PREFIX}/''${NGSOLVE_INSTALL_DIR_PYTHON}' \
                     ''\'''${CMAKE_INSTALL_PREFIX}/''${NGSOLVE_INSTALL_DIR_PYTHON}:$ENV{PYTHONPATH}'
  '';

  nativeBuildInputs = [
    cmake
    gfortran
    python3Packages.pybind11-stubgen
  ];

  cmakeFlags = [
    (lib.cmakeFeature "ngscxx_includes" ngscxxInclude)
    (lib.cmakeFeature "ngsld_flags" ngsldFlags)
    (lib.cmakeFeature "CMAKE_CXX_FLAGS" archFlags)
    (lib.cmakeFeature "NETGEN_DIR" "${python3Packages.netgen-mesher}")
    (lib.cmakeFeature "CATCH_INCLUDE_DIR" "${catch2}/include/catch2")
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
    (lib.cmakeBool "USE_MPI" true)
    (lib.cmakeBool "USE_HYPRE" true)
    (lib.cmakeBool "USE_MUMPS" true)
    (lib.cmakeBool "USE_SUPERBUILD" false)
    (lib.cmakeBool "BUILD_STUB_FILES" true)
    (lib.cmakeBool "BUILD_TESTING" finalAttrs.finalPackage.doInstallCheck)
    (lib.cmakeBool "ENABLE_UNIT_TESTS" finalAttrs.finalPackage.doInstallCheck)
  ];

  buildInputs = [
    blas
    lapack
    hypre
    mumps_par
    suitesparse
    mpi
  ];

  propagatedBuildInputs = with python3Packages; [
    scipy
    netgen-mesher
  ];

  doInstallCheck = true;

  installCheckTarget = "test";

  # Test on ngscxx/ngsld that they can compile/link without NIX_CFLAGS_COMPILE/NIX_LDFLAGS
  preInstallCheck = ''
    unset NIX_CFLAGS_COMPILE
    unset NIX_LDFLAGS
    export PYTHONPATH=$out/${python3Packages.python.sitePackages}:$PYTHONPATH
    export PATH=$out/bin:$PATH
  '';

  nativeInstallCheckInputs = [
    catch2
    python3Packages.pytest
    mpiCheckPhaseHook
  ];

  meta = {
    homepage = "https://ngsolve.org";
    description = "Multi-purpose finite element library";
    license = lib.licenses.lgpl21Only;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    maintainers = with lib.maintainers; [ qbisi ];
  };
})
