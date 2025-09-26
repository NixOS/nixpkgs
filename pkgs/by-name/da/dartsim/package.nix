{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,

  pythonSupport ? false,
  python3Packages,

  # nativeBuildInputs
  cmake,
  doxygen,
  pkg-config,

  # propagatedBuildInputs
  assimp,
  blas,
  boost,
  bullet,
  eigen,
  fcl,
  flann,
  fmt,
  libglut,
  imgui,
  ipopt,
  lapack,
  libGL,
  libGLU,
  libccd,
  nlopt,
  ode,
  openscenegraph,
  pagmo2,
  tinyxml-2,
  urdfdom,
  urdfdom-headers,

  # checkInputs
  gbenchmark,
  gtest,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dartsim";
  version = "6.15.0";

  src = fetchFromGitHub {
    owner = "dartsim";
    repo = "dart";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ik6FwrN5Ta1LinrXpZZc7AmzdFPoLjG07/zo1IZdmgI=";
  };

  patches = [
    # disable failing tests. CMAKE_CTEST_ARGUMENTS does not work.
    ./disable-failing-tests.patch
    # Fix use of system gbenchmark, merged upstream
    # ref. https://github.com/dartsim/dart/pull/1904
    (fetchpatch {
      url = "https://github.com/dartsim/dart/commit/c18c48a1b0beff6660b9923e8a6f8f09a86a6039.patch";
      hash = "sha256-i8Ga0FGVQ3OMprEoGEwVy0j139wjnmR6ABxr/3syhzw=";
    })
    # Fix use of system pybind11, merged upstream
    # ref. https://github.com/dartsim/dart/pull/1907
    (fetchpatch {
      url = "https://github.com/dartsim/dart/commit/940c425c19e50a9ded2629422db54785802143af.patch";
      hash = "sha256-T3992uD0Z36tTxlcFaikVaLt08N9EP4gOHP0Y2AFBzQ=";
    })
    # fix use of absolute CMake paths in .pc, merged upstream
    # ref. https://github.com/dartsim/dart/pull/2006
    (fetchpatch {
      url = "https://github.com/dartsim/dart/commit/6f3d6086780a311ef6e1928697f56a4d845ae028.patch";
      hash = "sha256-sfbTm9C74fl7lVnGPZ1h3cvKXILHhkeNYxd/BpSQvg8=";
    })
  ];

  # Install python bindings
  postPatch = ''
    echo "install(TARGETS $""{pybind_module} DESTINATION ${python3Packages.python.sitePackages})" \
      >> python/dartpy/CMakeLists.txt
  '';

  buildFlags = [
    # build unit tests
    "tests"
  ]
  ++ lib.optionals pythonSupport [
    "dartpy"
  ];

  nativeBuildInputs = [
    cmake
    doxygen
    pkg-config
  ]
  ++ lib.optionals pythonSupport [
    python3Packages.python
    python3Packages.pybind11
  ];

  propagatedBuildInputs = [
    assimp
    blas
    boost
    bullet
    eigen
    fcl
    flann
    fmt
    libglut
    # requires imgui_impl_opengl2.h
    (imgui.override { IMGUI_BUILD_OPENGL2_BINDING = true; })
    ipopt
    lapack
    libGL
    libGLU
    libccd
    nlopt
    ode
    openscenegraph
    pagmo2
    tinyxml-2
    urdfdom
    urdfdom-headers
  ]
  ++ lib.optionals pythonSupport [
    python3Packages.numpy
  ];

  checkInputs = [
    gbenchmark
    gtest
  ];

  nativeCheckInputs = lib.optionals pythonSupport [
    python3Packages.pytest
    python3Packages.pythonImportsCheckHook
  ];

  doCheck = true;

  pythonImportsCheck = [ "dartpy" ];

  cmakeFlags = [
    (lib.cmakeBool "DART_VERBOSE" true)
    (lib.cmakeBool "DART_BUILD_DARTPY" pythonSupport)
    (lib.cmakeBool "DART_USE_SYSTEM_GOOGLEBENCHMARK" true)
    (lib.cmakeBool "DART_USE_SYSTEM_GOOGLETEST" true)
    (lib.cmakeBool "DART_USE_SYSTEM_IMGUI" true)
    (lib.cmakeBool "DART_USE_SYSTEM_PYBIND11" true)
  ];

  meta = {
    description = "DART: Dynamic Animation and Robotics Toolkit";
    homepage = "https://github.com/dartsim/dart";
    changelog = "https://github.com/dartsim/dart/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ nim65s ];
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };
})
