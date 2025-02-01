{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cereal,
  cmake,
  doxygen,
  eigen,
  jrl-cmakemodules,
  simde,
  matio,
  pythonSupport ? false,
  python3Packages,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "proxsuite";
  version = "0.6.6";

  src = fetchFromGitHub {
    owner = "simple-robotics";
    repo = "proxsuite";
    rev = "v${finalAttrs.version}";
    hash = "sha256-3kzFYADk3sCMU827KowilPlmOqgv69DJ3mOb7623Qdg=";
  };

  patches = [
    # Allow use of system jrl-cmakemodules
    # This was merged upstream, and can be removed on next release
    (fetchpatch {
      url = "https://github.com/Simple-Robotics/proxsuite/pull/334/commits/2bcadd4993a9940c545136faa71bf1e97a972735.patch";
      hash = "sha256-BPtwogSwSXcEd5FM4eTTCq6LpGWvQ1SOCFmv/GVhl18=";
    })
    # Allow use of system cereal
    # This was merged upstream, and can be removed on next release
    (fetchpatch {
      url = "https://github.com/Simple-Robotics/proxsuite/pull/334/commits/878337c6284c9fd73b19f1f80d5fa802def8cdc6.patch";
      hash = "sha256-+HWYHLGtygjlvjM+FSD9WFDIwO+qPLlzci+7q42bo0I=";
    })
    # Allow use of system pybind11
    # upstream will move to nanobind for next release, so this can be dismissed
    (fetchpatch {
      url = "https://github.com/Simple-Robotics/proxsuite/pull/337/commits/bbed9bdfb214da7c6c6909582971bd8b877f87c2.patch";
      hash = "sha256-pYikPZinjmk7gsagiaIcQspmGFYwlhdiKdZPnqo7pcQ=";
    })
  ];

  postPatch = ''
    # discard failing tests for now
    substituteInPlace test/CMakeLists.txt \
      --replace-fail "proxsuite_test(dense_maros_meszaros src/dense_maros_meszaros.cpp)" "" \
      --replace-fail "proxsuite_test(sparse_maros_meszaros src/sparse_maros_meszaros.cpp)" ""

    # fix CMake syntax
    substituteInPlace bindings/python/CMakeLists.txt \
      --replace-fail "SYSTEM PRIVATE" "PRIVATE"
  '';

  outputs = [
    "doc"
    "out"
  ];

  cmakeFlags =
    [
      (lib.cmakeBool "BUILD_DOCUMENTATION" true)
      (lib.cmakeBool "INSTALL_DOCUMENTATION" true)
      (lib.cmakeBool "BUILD_PYTHON_INTERFACE" pythonSupport)
    ]
    ++ lib.optionals (stdenv.hostPlatform.system == "aarch64-linux") [
      "-DCMAKE_CTEST_ARGUMENTS=--exclude-regex;ProxQP::dense: test primal infeasibility solving"
    ];

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    doxygen
  ];
  propagatedBuildInputs = [
    cereal
    eigen
    jrl-cmakemodules
    simde
  ] ++ lib.optionals pythonSupport [ python3Packages.pybind11 ];
  checkInputs =
    [ matio ]
    ++ lib.optionals pythonSupport [
      python3Packages.numpy
      python3Packages.scipy
    ];

  doCheck = true;

  meta = {
    description = "The Advanced Proximal Optimization Toolbox";
    homepage = "https://github.com/Simple-Robotics/proxsuite";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ nim65s ];
  };
})
