{
  lib,

  fetchFromGitHub,
  nix-update-script,
  stdenv,

  # nativeBuildInputs
  cmake,
  doxygen,
  pkg-config,

  # propagatedBuildInputs
  boost,
  casadi,
  coal,
  console-bridge,
  eigen,
  jrl-cmakemodules,
  urdfdom,

  # nativeCheckInputs
  ctestCheckHook,

  # checkInputs = [
  example-robot-data,

  casadiSupport ? true,
  collisionSupport ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pinocchio";
  version = "3.9.0";

  src = fetchFromGitHub {
    owner = "stack-of-tasks";
    repo = "pinocchio";
    rev = "v${finalAttrs.version}";
    hash = "sha256-k2lT1I0wb3N/o95ol2oO6HSYHf4wKJ0SFEg8JNxZmpI=";
  };

  outputs = [
    "out"
    "doc"
  ];

  postPatch = ''
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

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fast and flexible implementation of Rigid Body Dynamics algorithms and their analytical derivatives";
    homepage = "https://github.com/stack-of-tasks/pinocchio";
    changelog = "https://github.com/stack-of-tasks/pinocchio/blob/devel/CHANGELOG.md";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [
      nim65s
      wegank
    ];
    platforms = lib.platforms.unix;
  };
})
