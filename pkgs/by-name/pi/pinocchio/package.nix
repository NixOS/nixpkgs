{
  boost,
  casadi,
  casadiSupport ? true,
  cmake,
  collisionSupport ? true,
  console-bridge,
  doxygen,
  eigen,
  example-robot-data,
  fetchFromGitHub,
  hpp-fcl,
  jrl-cmakemodules,
  lib,
  pkg-config,
  pythonSupport ? false,
  python3Packages,
  stdenv,
  urdfdom,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pinocchio";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "stack-of-tasks";
    repo = "pinocchio";
    rev = "v${finalAttrs.version}";
    hash = "sha256-8V+n1TwFojXKOVkGG8k9aXVadt2NBFlZKba93L+NRNU=";
  };

  outputs = [
    "out"
    "doc"
  ];

  # test failure, ref https://github.com/stack-of-tasks/pinocchio/issues/2277
  prePatch = lib.optionalString (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) ''
    substituteInPlace unittest/algorithm/utils/CMakeLists.txt \
      --replace-fail "add_pinocchio_unit_test(force)" ""
  '';

  postPatch = ''
    # example-robot-data models are used in checks.
    # Upstream provide them as git submodule, but we can use our own version instead.
    test -d models/example-robot-data && rmdir models/example-robot-data
    ln -s ${example-robot-data.src} models/example-robot-data

    # allow package:// uri use in examples
    export ROS_PACKAGE_PATH=${example-robot-data}/share

    # silence matplotlib warning
    export MPLCONFIGDIR=$(mktemp -d)
  '';

  # CMAKE_BUILD_TYPE defaults to Release in this package,
  # which enable -O3, which break some tests
  # ref. https://github.com/stack-of-tasks/pinocchio/issues/2304#issuecomment-2231018300
  postConfigure = ''
    substituteInPlace CMakeCache.txt --replace-fail '-O3' '-O2'
  '';

  strictDeps = true;

  nativeBuildInputs =
    [
      cmake
      doxygen
      pkg-config
    ]
    ++ lib.optionals pythonSupport [
      python3Packages.python
      python3Packages.pythonImportsCheckHook
    ];

  propagatedBuildInputs =
    [
      console-bridge
      jrl-cmakemodules
      urdfdom
    ]
    ++ lib.optionals (!pythonSupport) [
      boost
      eigen
    ]
    ++ lib.optionals (!pythonSupport && collisionSupport) [ hpp-fcl ]
    ++ lib.optionals pythonSupport [
      python3Packages.boost
      python3Packages.eigenpy
    ]
    ++ lib.optionals (pythonSupport && collisionSupport) [ python3Packages.hpp-fcl ]
    ++ lib.optionals (!pythonSupport && casadiSupport) [ casadi ]
    ++ lib.optionals (pythonSupport && casadiSupport) [ python3Packages.casadi ];

  checkInputs = lib.optionals (pythonSupport && casadiSupport) [ python3Packages.matplotlib ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_PYTHON_INTERFACE" pythonSupport)
    (lib.cmakeBool "BUILD_WITH_LIBPYTHON" pythonSupport)
    (lib.cmakeBool "BUILD_WITH_CASADI_SUPPORT" casadiSupport)
    (lib.cmakeBool "BUILD_WITH_COLLISION_SUPPORT" collisionSupport)
    (lib.cmakeBool "INSTALL_DOCUMENTATION" true)
  ];

  doCheck = true;
  pythonImportsCheck = [ "pinocchio" ];

  meta = {
    description = "Fast and flexible implementation of Rigid Body Dynamics algorithms and their analytical derivatives";
    homepage = "https://github.com/stack-of-tasks/pinocchio";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [
      nim65s
      wegank
    ];
    platforms = lib.platforms.unix;
  };
})
