{
  lib,
  stdenv,
  fetchFromGitHub,

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

  # nativeCheckInputs
  ctestCheckHook,

  # checkInputs
  gbenchmark,
  gtest,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dartsim";
  version = "6.20.3";

  src = fetchFromGitHub {
    owner = "dartsim";
    repo = "dart";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hOFJEV3cWo83QrBIMSYY27Mb0WCsQj7bBNa2B2TW0ME=";
  };

  buildFlags =
    lib.optional finalAttrs.finalPackage.doCheck "tests" ++ lib.optional pythonSupport "dartpy";

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

  nativeCheckInputs = [
    ctestCheckHook
  ]
  ++ lib.optionals pythonSupport [
    python3Packages.pytest
    python3Packages.pythonImportsCheckHook
  ];

  disabledTests = [
    "test_Collision"
    "test_ForceDependentSlip"
    "test_SoftFootSimbiconModel"
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-Wno-error=deprecated-literal-operator";

  doCheck = true;

  pythonImportsCheck = [ "dartpy" ];

  cmakeFlags = [
    (lib.cmakeBool "DART_VERBOSE" true)
    (lib.cmakeBool "DART_BUILD_DARTPY" pythonSupport)
    (lib.cmakeBool "DART_BUILD_EXAMPLES" false)
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
