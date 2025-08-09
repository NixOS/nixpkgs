{
  lib,
  stdenv,
  fetchFromGitHub,

  pythonSupport ? false,
  python3Packages,

  # nativeBuildInputs
  cmake,
  pkg-config,

  # propagatedBuildInputs
  assimp,
  blas,
  boost,
  bullet,
  eigen,
  fcl,
  fmt,
  libglut,
  nlopt,
  imgui,
  ipopt,
  lapack,
  libGL,
  libGLU,
  ode,
  openscenegraph,
  pagmo2,
  tinyxml-2,
  urdfdom,

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

  # disable failing tests. CMAKE_CTEST_ARGUMENTS does not work.
  patches = [ ./disable-failing-tests.patch ];

  postPatch = ''
    # https://github.com/dartsim/dart/pull/1904, merged upstream
    substituteInPlace tests/benchmark/CMakeLists.txt \
      --replace-fail \
        "FetchContent_MakeAvailable(benchmark)" \
        "find_package(benchmark REQUIRED)"

    # https://github.com/dartsim/dart/pull/1907, merged upstream
    substituteInPlace python/CMakeLists.txt \
      --replace-fail \
        "FetchContent_MakeAvailable(pybind11)" \
        "find_package(pybind11 CONFIG REQUIRED)"

    # fix use of absolute CMake paths in .pc
    substituteInPlace CMakeLists.txt \
      --replace-fail \
        "$""{CMAKE_INSTALL_PREFIX}/$""{CMAKE_INSTALL_LIBDIR}" \
        "$""{CMAKE_INSTALL_LIBDIR}"
    substituteInPlace cmake/dart.pc.in \
      --replace-fail \
        "libdir=$""{prefix}/" \
        "libdir=" \
      --replace-fail \
        "includedir=$""{prefix}/" \
        "includedir="

    # install python bindings
    substituteInPlace python/dartpy/CMakeLists.txt \
      --replace-fail \
        "EXCLUDE_FROM_ALL" \
        ""
    echo "install(TARGETS $""{pybind_module} DESTINATION ${python3Packages.python.sitePackages})" \
      >> python/dartpy/CMakeLists.txt
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ]
  ++ lib.optionals pythonSupport [
    python3Packages.python
    python3Packages.pybind11
  ];

  propagatedBuildInputs = [
    blas
    boost
    assimp
    bullet
    eigen
    fcl
    fmt
    libglut
    gbenchmark
    nlopt
    # requires imgui_impl_opengl2.h
    (imgui.override { IMGUI_BUILD_OPENGL2_BINDING = true; })
    ipopt
    lapack
    libGL
    libGLU
    ode
    openscenegraph
    pagmo2
    tinyxml-2
    urdfdom
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
  # build unit tests
  preCheck = "make tests";
  pythonImportsCheck = [ "dartpy" ];

  cmakeFlags = [
    (lib.cmakeBool "DART_BUILD_DARTPY" pythonSupport)
    (lib.cmakeBool "DART_USE_SYSTEM_IMGUI" true)
    (lib.cmakeBool "DART_USE_SYSTEM_GOOGLEBENCHMARK" true)
    (lib.cmakeBool "DART_USE_SYSTEM_GOOGLETEST" true)
  ];

  meta = {
    description = "DART: Dynamic Animation and Robotics Toolkit";
    homepage = "https://github.com/dartsim/dart";
    changelog = "https://github.com/dartsim/dart/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ nim65s ];
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };
})
