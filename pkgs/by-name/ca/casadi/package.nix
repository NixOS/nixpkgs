{
  #alpaqa,
  blas,
  blasfeo,
  bonmin,
  bzip2,
  cbc,
  clp,
  cmake,
  cplex,
  fatrop,
  fetchFromGitHub,
  fetchpatch,
  gurobi,
  highs,
  hpipm,
  lib,
  ipopt,
  lapack,
  llvmPackages_17, # llvm/Support/Host.h required by casadi 3.6.5 and not available in llvm 18
  mumps,
  osqp,
  pkg-config,
  pythonSupport ? false,
  python3Packages,
  proxsuite,
  stdenv,
  sleqp,
  suitesparse,
  #sundials,
  superscs,
  spral,
  swig,
  tinyxml-2,
  withUnfree ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "casadi";
  version = "3.6.6";

  src = fetchFromGitHub {
    owner = "casadi";
    repo = "casadi";
    rev = finalAttrs.version;
    hash = "sha256-T4aaBS918NbUEwWkSx0URi0W9uhCB8IFmzRcOR7T8Og=";
  };

  patches = [
    (fetchpatch {
      name = "add-FindSPRAL.cmake.patch";
      url = "https://github.com/casadi/casadi/pull/3792/commits/28bc1b03e67ae06dea0c8557057020f5651be7ad.patch";
      hash = "sha256-t0+RnXoFakmoX93MhN08RWAbCg6Nerh42LicBBgAkRQ=";
    })
  ];

  postPatch =
    ''
      # fix case of fatropConfig.cmake & hpipmConfig.cmake
      substituteInPlace CMakeLists.txt --replace-fail \
        "FATROP HPIPM" \
        "fatrop hpipm"

      # nix provide lib/clang headers in libclang, not in llvm.
      substituteInPlace casadi/interfaces/clang/CMakeLists.txt --replace-fail \
        '$'{CLANG_LLVM_LIB_DIR} \
        ${llvmPackages_17.libclang.lib}/lib

      # fix fatrop includes
      substituteInPlace casadi/interfaces/fatrop/fatrop_conic_interface.hpp --replace-fail \
        "<ocp/" \
        "<fatrop/ocp/"

      # fix mumps lib name. No idea where this comes from.
      substituteInPlace cmake/FindMUMPS.cmake --replace-fail \
        "mumps_seq" \
        "mumps"

      # help casadi find its own libs
      substituteInPlace casadi/core/casadi_os.cpp --replace-fail \
        "std::vector<std::string> search_paths;" \
        "std::vector<std::string> search_paths;
         search_paths.push_back(\"$out/lib\");"
    ''
    + lib.optionalString pythonSupport ''
      # fix including Python.h issue
      substituteInPlace swig/python/CMakeLists.txt --replace-fail \
        "add_library(_casadi MODULE \''${PYTHON_FILE})" \
        "add_library(_casadi MODULE \''${PYTHON_FILE})
         target_include_directories(_casadi SYSTEM PRIVATE
           ${python3Packages.python}/include/python3.${python3Packages.python.sourceVersion.minor})"

      # I have no clue. without this, it tries to install a non existent file.
      # maybe a run without SWIG_IMPORT is required before a run with SWIG_IMPORT.
      # but we need SWIG_IMPORT at some point for something else TODO
      substituteInPlace swig/python/CMakeLists.txt --replace-fail \
        "if (SWIG_IMPORT)" \
        "if (NOT SWIG_IMPORT)"
    ''
    + lib.optionalString stdenv.isDarwin ''
      # this is only printing stuff, and is not defined on all CPU
      substituteInPlace casadi/interfaces/hpipm/hpipm_runtime.hpp --replace-fail \
        "d_print_exp_tran_mat" \
        "//d_print_exp_tran_mat"

      # fix missing symbols
      substituteInPlace cmake/FindCLANG.cmake --replace-fail \
        "clangBasic)" \
        "clangBasic clangASTMatchers clangSupport)"
    '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs =
    [
      #alpaqa
      blas
      blasfeo
      bzip2
      bonmin
      cbc
      clp
      fatrop
      highs
      hpipm
      ipopt
      lapack
      llvmPackages_17.clang
      llvmPackages_17.libclang
      llvmPackages_17.llvm
      mumps
      osqp
      proxsuite
      sleqp
      suitesparse
      #sundials
      superscs
      spral
      swig
      tinyxml-2
    ]
    ++ lib.optionals withUnfree [
      cplex
      gurobi
    ]
    ++ lib.optionals pythonSupport [
      python3Packages.numpy
      python3Packages.python
    ]
    ++ lib.optionals stdenv.isDarwin [ llvmPackages_17.openmp ];

  cmakeFlags = [
    (lib.cmakeBool "WITH_PYTHON" pythonSupport)
    (lib.cmakeBool "WITH_PYTHON3" pythonSupport)
    # We don't mind always setting this cmake variable, it will be read only if
    # pythonSupport is enabled.
    "-DPYTHON_PREFIX=${placeholder "out"}/${python3Packages.python.sitePackages}"
    (lib.cmakeBool "WITH_JSON" false)
    (lib.cmakeBool "WITH_INSTALL_INTERNAL_HEADERS" true)
    (lib.cmakeBool "INSTALL_INTERNAL_HEADERS" true)
    (lib.cmakeBool "ENABLE_EXPORT_ALL" true)
    (lib.cmakeBool "SWIG_EXPORT" true)
    (lib.cmakeBool "SWIG_IMPORT" false)
    (lib.cmakeBool "WITH_OPENMP" true)
    (lib.cmakeBool "WITH_THREAD" true)
    (lib.cmakeBool "WITH_OPENCL" false)
    (lib.cmakeBool "WITH_BUILD_SUNDIALS" true) # ref. https://github.com/casadi/casadi/issues/2125
    (lib.cmakeBool "WITH_SUNDIALS" true)
    (lib.cmakeBool "WITH_BUILD_CSPARSE" false)
    (lib.cmakeBool "WITH_CSPARSE" true)
    (lib.cmakeBool "WITH_BLASFEO" true)
    (lib.cmakeBool "WITH_HPIPM" true)
    (lib.cmakeBool "WITH_FATROP" false) # invalid new-expression of abstract class type 'casadi::CasadiStructuredQP'
    (lib.cmakeBool "WITH_BUILD_FATROP" false)
    (lib.cmakeBool "WITH_SUPERSCS" false) # packaging too chaotic
    (lib.cmakeBool "WITH_BUILD_OSQP" false)
    (lib.cmakeBool "WITH_OSQP" true)
    (lib.cmakeBool "WITH_PROXQP" true)
    (lib.cmakeBool "WITH_BUILD_TINYXML" false)
    (lib.cmakeBool "WITH_TINYXML" true)
    (lib.cmakeBool "WITH_BUILD_DSDP" true) # not sure where this come from
    (lib.cmakeBool "WITH_DSDP" true)
    (lib.cmakeBool "WITH_CLANG" true)
    (lib.cmakeBool "WITH_LAPACK" true)
    (lib.cmakeBool "WITH_QPOASES" true)
    (lib.cmakeBool "WITH_BLOCKSQP" true)
    (lib.cmakeBool "WITH_SLEQP" true)
    (lib.cmakeBool "WITH_IPOPT" true)
    (lib.cmakeBool "WITH_KNITRO" withUnfree)
    (lib.cmakeBool "WITH_SNOPT" withUnfree)
    (lib.cmakeBool "WITH_WORHP" withUnfree)
    (lib.cmakeBool "WITH_CPLEX" withUnfree)
    (lib.cmakeBool "WITH_GUROBI" withUnfree)
    (lib.cmakeBool "WITH_BONMIN" true)
    (lib.cmakeBool "WITH_CBC" true)
    (lib.cmakeBool "WITH_CLP" true)
    (lib.cmakeBool "WITH_MUMPS" true)
    (lib.cmakeBool "WITH_SPRAL" true)
    (lib.cmakeBool "WITH_HSL" withUnfree)
    (lib.cmakeBool "WITH_HIGHS" true)
    #(lib.cmakeBool "WITH_ALPAQA" true)  # this requires casadi...
  ];

  doCheck = true;

  meta = {
    description = "CasADi is a symbolic framework for numeric optimization implementing automatic differentiation in forward and reverse modes on sparse matrix-valued computational graphs. It supports self-contained C-code generation and interfaces state-of-the-art codes such as SUNDIALS, IPOPT etc. It can be used from C++, Python or Matlab/Octave";
    homepage = "https://github.com/casadi/casadi";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ nim65s ];
    platforms = lib.platforms.all;
  };
})
