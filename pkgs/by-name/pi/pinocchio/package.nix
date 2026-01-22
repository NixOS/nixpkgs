{
  boost,
  casadi,
  casadiSupport ? true,
  cmake,
  collisionSupport ? true,
  console-bridge,
  ctestCheckHook,
  doxygen,
  eigen,
  example-robot-data,
  fetchFromGitHub,
  fetchpatch,
  coal,
  jrl-cmakemodules,
  lib,
  pkg-config,
  stdenv,
  urdfdom,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pinocchio";
  version = "3.8.0";

  src = fetchFromGitHub {
    owner = "stack-of-tasks";
    repo = "pinocchio";
    rev = "v${finalAttrs.version}";
    hash = "sha256-2oMP653fJ7Msk+IB8whRk2L8xkAmRdDeMLPJyyD99OQ=";
  };

  outputs = [
    "out"
    "doc"
  ];

  patches = [
    # ref. https://github.com/stack-of-tasks/pinocchio/pull/2771
    (fetchpatch {
      name = "fix-viser-path.patch";
      url = "https://github.com/stack-of-tasks/pinocchio/commit/36a04bddb6980a7bcd28ebcc55d4e442f7920d87.patch";
      hash = "sha256-9oENiMmRqJLU4ZiyGojm7suqdwTDGfk56aS2kcZiGaI=";
    })
  ];

  postPatch = ''
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
  ];

  propagatedBuildInputs = [
    boost
    coal
    console-bridge
    eigen
    jrl-cmakemodules
    urdfdom
  ]
  ++ lib.optionals collisionSupport [ coal ]
  ++ lib.optionals casadiSupport [ casadi ];

  nativeCheckInputs = [
    ctestCheckHook
  ];

  checkInputs = [
    example-robot-data
  ];

  disabledTests =
    lib.optionals stdenv.hostPlatform.isDarwin [
      # Disable test that fails on darwin
      # https://github.com/stack-of-tasks/pinocchio/blob/42306ed023b301aafef91e2e76cb070c5e9c3f7d/flake.nix#L24C1-L27C17
      "pinocchio-example-py-casadi-quadrotor-ocp"
    ]
    ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
      # test failure, ref https://github.com/stack-of-tasks/pinocchio/issues/2277
      "test-cpp-algorithm-utils-force"
    ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_PYTHON_INTERFACE" false)
    (lib.cmakeBool "BUILD_WITH_CASADI_SUPPORT" casadiSupport)
    (lib.cmakeBool "BUILD_WITH_COLLISION_SUPPORT" collisionSupport)
    (lib.cmakeBool "INSTALL_DOCUMENTATION" true)
  ];

  doCheck = true;

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
