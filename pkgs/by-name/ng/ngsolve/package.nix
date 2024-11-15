{
  lib,
  stdenv,
  fetchFromGitHub,
  gfortran,
  mpi,
  git,
  cmake,
  python3,
  blas,
  lapack,
  mumps_par,
  hypre,
  suitesparse,
  catch2,
  mpiCheckPhaseHook,
  avxSupport ? python3.pkgs.netgen.avxSupport,
  avx2Support ? python3.pkgs.netgen.avx2Support,
  avx512Support ? python3.pkgs.netgen.avx512Support,
  advSimdSupport ? false,
}:
assert advSimdSupport -> stdenv.hostPlatform.isAarch64;
stdenv.mkDerivation (finalAttrs: {
  pname = "ngsolve";
  version = "6.2.2405";

  src = fetchFromGitHub {
    owner = "ngsolve";
    repo = "ngsolve";
    rev = "v${finalAttrs.version}";
    hash = "sha256-9q7iik7TiwIfTqJ9flFxO1mfY0y4NV4ZPGsCh4RCmvc=";
  };

  patches = [
    # fix solver in test_quasiperiodic to umfpack
    ./fix-pytest-inverse-solver.patch
    # ngsolve looks for mumps built with parmetis
    # since parmetis is unfree we make parmetis an optional dependency
    ./make-parmetis-optional.patch
  ];

  postPatch = ''
    echo "v${finalAttrs.version}-0" > version.txt
    # create dummy catch2 target and use system catch2
    echo "add_custom_target(project_catch)" > cmake/external_projects/catch.cmake
    # mumps solver require mpi init
    echo -e "\nfrom mpi4py import MPI" >> tests/pytest/conftest.py
  '';

  nativeBuildInputs = [
    # dummy dependency to pass the cmake requirement
    # get version via version.txt rather than git describe
    git
    cmake
    gfortran
    python3.pkgs.pybind11-stubgen
  ];

  ngscxxInclude = toString [
    "-I${python3.pkgs.pybind11}/include"
    "-I${python3.pkgs.netgen}/include"
    "-I${python3.pkgs.netgen}/include/include"
    # these path already included in ngscxx
    # "-I${mumps}/include"
    # "-I${suitesparse}/include"
  ];

  ngsldFlags = toString [
    "-L${python3.pkgs.netgen}/lib"
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

  # append flags to ngscxx/ngsld so that they can compile/link without NIX_CFLAGS_COMPILE/NIX_LDFLAGS
  preConfigure = ''
    cmakeFlagsArray+=(
      -Dngscxx_includes="$ngscxxInclude"
      -Dngsld_flags="$ngsldFlags"
      -DCMAKE_CXX_FLAGS="$archFlags"
    )
  '';

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
    (lib.cmakeFeature "NETGEN_DIR" "${python3.pkgs.netgen}")
    (lib.cmakeFeature "CATCH_INCLUDE_DIR" "${catch2}/include/catch2")
    (lib.cmakeBool "USE_MPI" true)
    (lib.cmakeBool "USE_HYPRE" true)
    (lib.cmakeBool "USE_MUMPS" true)
    (lib.cmakeBool "USE_SUPERBUILD" false)
    (lib.cmakeBool "BUILD_STUB_FILES" false)
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

  propagatedBuildInputs = with python3.pkgs; [
    scipy
    netgen
  ];

  doInstallCheck = true;

  installCheckTarget = "test";

  postInstall = ''
    export PYTHONPATH=$out/${python3.sitePackages}:$PYTHONPATH
    pybind11-stubgen ngsolve -o $out/${python3.sitePackages}
  '';

  preInstallCheck = ''
    unset NIX_CFLAGS_COMPILE
    unset NIX_LDFLAGS
    export PATH=$out/bin:$PATH
  '';

  nativeInstallCheckInputs = [
    catch2
    python3.pkgs.pytest
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
