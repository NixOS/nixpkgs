{
  lib,
  stdenv,
  fetchFromGitHub,
  replaceVars,
  makeWrapper,
  gfortran,
  mpi,
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
  );
  wrapPythonPath = "$out/${python3Packages.python.sitePackages}:${
    python3Packages.makePythonPath (
      with python3Packages;
      [
        scipy
        netgen-mesher
      ]
    )
  }";
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
    # Add neccessary python path for standalone gui app netgen.
    (replaceVars ./tcl-script-add-python-path.patch {
      WRAP_PYTHONPATH = wrapPythonPath;
    })
    # looks for a shared mumps library
    ./fix-find-mumps.patch
  ];

  postPatch = ''
    sed -i "2i #include <paralleldofs.hpp>" comp/hypre_precond.hpp

    substituteInPlace cmake/generate_version_file.cmake \
      --replace-fail "Git REQUIRED" "Git"
    echo "v${finalAttrs.version}-0" > version.txt

    echo -e "add_custom_target(project_catch)" > cmake/external_projects/catch.cmake

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
    makeWrapper
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

  propagatedUserEnvPkgs = [ python3Packages.netgen-mesher ];

  # Ngsolve.tcl is a tcl script to be sourced by netgen and share not be binary wrapped.
  # It should not be placed in bin directory as python-env will wrap every executable in bin.
  # We move it into $out/libexec and netgen will look for ngsolve.tcl in dir/../libexec for each dir in $PATH.
  postFixup = ''
    mkdir $out/libexec
    mv $out/bin/ngsolve.tcl $out/libexec
    wrapProgram  $out/bin/ngspy --set PYTHONPATH "${wrapPythonPath}:\$PYTHONPATH"
  '';

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
    python3Packages.pythonImportsCheckHook
    mpiCheckPhaseHook
  ];

  pythonImportsCheck = [ "ngsolve" ];

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
