{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  cmake,
  pkg-config,
  gfortran,
  blas,
  lapack,
  mpi,
  llvmPackages,
  mpiCheckPhaseHook,
  runCommandCC,
  isILP64 ? false,
  mpiSupport ? true,
  precision ? "double",
  testers,
  hypre,
}:

assert lib.elem precision [
  "single"
  "double"
  "long-double"
];

stdenv.mkDerivation (finalAttrs: {
  pname = "hypre";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "hypre-space";
    repo = "hypre";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zu9YWfBT2WJxPg6JHrXjZWRM9Ai1p28EpvAx6xfdPsY=";
  };

  outputs = [
    "out"
    "dev"
  ];

  patches = [
    (fetchpatch2 {
      url = "https://raw.githubusercontent.com/spack/spack-packages/eb4b23847f0079d0c9c8de99aaa32557ad4c9194/repos/builtin/packages/hypre/hypre-precision-fix.patch?full_index=1";
      hash = "sha256-Ni5xlfFmok884x5Hctf9VOsAgZp8ICG7QNVGTdVKPzE=";
    })
  ];

  postPatch = ''
    # The relative `include` resolves to $out/include in the exported targets,
    # but headers are installed to $dev/include.
    substituteInPlace src/CMakeLists.txt src/config/cmake/HYPRE_CMakeUtilities.cmake \
      --replace-fail '$<INSTALL_INTERFACE:include>' '$<INSTALL_INTERFACE:''${CMAKE_INSTALL_INCLUDEDIR}>'
  ''
  # fix sequence check
  + lib.optionalString (!mpiSupport) ''
    substituteInPlace src/test/CMakeLists.txt \
      --replace-fail ''\'''${MPIEXEC_EXECUTABLE} ''${MPIEXEC_NUMPROC_FLAG} 1' ""
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    gfortran
  ];

  propagatedBuildInputs = [
    (blas.override { inherit isILP64; })
    (lapack.override { inherit isILP64; })
  ]
  ++ lib.optional mpiSupport mpi
  ++ lib.optional stdenv.cc.isClang llvmPackages.openmp;

  cmakeDir = "../src";

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
    (lib.cmakeBool "BLA_PREFER_PKGCONFIG" true)
    (lib.cmakeBool "HYPRE_ENABLE_HYPRE_BLAS" false)
    (lib.cmakeBool "HYPRE_ENABLE_HYPRE_LAPACK" false)
    (lib.cmakeBool "HYPRE_ENABLE_FORTRAN" true)
    (lib.cmakeBool "HYPRE_ENABLE_BIGINT" isILP64)
    (lib.cmakeBool "HYPRE_ENABLE_SINGLE" (precision == "single"))
    (lib.cmakeBool "HYPRE_ENABLE_LONG_DOUBLE" (precision == "long-double"))
    (lib.cmakeBool "HYPRE_ENABLE_OPENMP" true)
    (lib.cmakeBool "HYPRE_ENABLE_MPI" mpiSupport)
    (lib.cmakeBool "HYPRE_BUILD_TESTS" finalAttrs.finalPackage.doCheck)
  ];

  __darwinAllowLocalNetworking = mpiSupport;

  nativeCheckInputs = lib.optional mpiSupport mpiCheckPhaseHook;

  doCheck = true;

  postInstall = lib.optionalString finalAttrs.finalPackage.doCheck ''
    rm -rf $out/bin
  '';

  passthru = {
    tests = {
      cmake-config = testers.hasCmakeConfigModules {
        moduleNames = [ "HYPRE" ];
        package = finalAttrs.finalPackage;
      };
      # find_package alone doesn't validate the imported target's include
      # directories, so link against HYPRE::HYPRE as well.
      cmake-link =
        runCommandCC "hypre-cmake-link-test"
          {
            nativeBuildInputs = [ cmake ];
            buildInputs = [ finalAttrs.finalPackage ];
          }
          ''
            cat > CMakeLists.txt <<EOF
            cmake_minimum_required(VERSION 3.21)
            project(HypreLinkTest C)
            find_package(HYPRE REQUIRED CONFIG)
            add_executable(test main.c)
            target_link_libraries(test PRIVATE HYPRE::HYPRE)
            EOF

            cat > main.c <<EOF
            #include <stdio.h>
            #include "HYPRE_utilities.h"
            int main(void) {
              char *version;
              HYPRE_Version(&version);
              printf("%s\n", version);
              return 0;
            }
            EOF

            cmake -B build
            cmake --build build
            build/test | tee $out
            grep -F ${finalAttrs.version} $out
          '';
      ilp64 = hypre.override { isILP64 = true; };
      single = hypre.override { precision = "single"; };
      serial = hypre.override { mpiSupport = false; };
    };
  };

  meta = {
    description = "Parallel solvers for sparse linear systems featuring multigrid methods";
    homepage = "https://computing.llnl.gov/projects/hypre-scalable-linear-solvers-multigrid-methods";
    platforms = lib.platforms.unix;
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [
      mkez
      qbisi
    ];
  };
})
