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
  coal,
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
  version = "3.7.0";

  src = fetchFromGitHub {
    owner = "stack-of-tasks";
    repo = "pinocchio";
    rev = "v${finalAttrs.version}";
    hash = "sha256-MykHbHSXY/eJ1+8v0hptiXeVmglU9/wImimiuByw0tE=";
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

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    doxygen
    pkg-config
  ]
  ++ lib.optionals pythonSupport [
    python3Packages.python
    python3Packages.pythonImportsCheckHook
  ];

  propagatedBuildInputs = [
    console-bridge
    jrl-cmakemodules
    urdfdom
  ]
  ++ lib.optionals (!pythonSupport) [
    boost
    eigen
  ]
  ++ lib.optionals (!pythonSupport && collisionSupport) [ coal ]
  ++ lib.optionals pythonSupport [
    python3Packages.boost
    python3Packages.eigenpy
  ]
  ++ lib.optionals (pythonSupport && collisionSupport) [ python3Packages.coal ]
  ++ lib.optionals (!pythonSupport && casadiSupport) [ casadi ]
  ++ lib.optionals (pythonSupport && casadiSupport) [ python3Packages.casadi ];

  checkInputs = lib.optionals (pythonSupport && casadiSupport) [ python3Packages.matplotlib ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_PYTHON_INTERFACE" pythonSupport)
    (lib.cmakeBool "BUILD_WITH_LIBPYTHON" pythonSupport)
    (lib.cmakeBool "BUILD_WITH_CASADI_SUPPORT" casadiSupport)
    (lib.cmakeBool "BUILD_WITH_COLLISION_SUPPORT" collisionSupport)
    (lib.cmakeBool "INSTALL_DOCUMENTATION" true)
    # Disable test that fails on darwin
    # https://github.com/stack-of-tasks/pinocchio/blob/42306ed023b301aafef91e2e76cb070c5e9c3f7d/flake.nix#L24C1-L27C17
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    (lib.cmakeFeature "CMAKE_CTEST_ARGUMENTS" "--exclude-regex;pinocchio-example-py-casadi-quadrotor-ocp")
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
