{
  lib,

  fetchFromGitHub,
  nix-update-script,
  stdenv,

  # buildInputs
  jrl-cmakemodules,

  # propagatedBuildInputs
  boost,
  casadi,
  coal,
  console-bridge,
  cppad,
  cppadcodegen,
  eigen,
  urdfdom,

  # nativeCheckInputs
  ctestCheckHook,

  # checkInputs = [
  example-robot-data,

  autodiffSupport ? true,
  casadiSupport ? true,
  codegenSupport ? true,
  collisionSupport ? true,
}:

assert codegenSupport -> autodiffSupport;

stdenv.mkDerivation (finalAttrs: {
  pname = "pinocchio";
  version = "4.1.0";

  src = fetchFromGitHub {
    owner = "stack-of-tasks";
    repo = "pinocchio";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wWuW58okWARbF/nonybw3DbGY4hrHDiEsdjiF6RoaVc=";
  };

  outputs = [
    "out"
    "doc"
  ];

  postPatch = ''
    # silence matplotlib warning
    export MPLCONFIGDIR=$(mktemp -d)

    # error: invalid use of incomplete type 'struct Eigen::internal::traits<double>'
    # ref. https://github.com/stack-of-tasks/pinocchio/pull/2880
    substituteInPlace unittest/cppad/basic.cpp \
      --replace-fail \
        "ad_Y = ad_X.array().min(Scalar(0.));" \
        "ad_Y = ad_X.array().min(CppAD::AD<double>(0.));" \
      --replace-fail \
        "ad_Y = ad_X.array().max(Scalar(0.));" \
        "ad_Y = ad_X.array().max(CppAD::AD<double>(0.));"
  '';

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = jrl-cmakemodules.docsNativeBuildInputs;

  buildInputs = [
    jrl-cmakemodules
  ];

  propagatedBuildInputs = [
    boost
    coal
    console-bridge
    eigen
    urdfdom
  ]
  ++ lib.optionals autodiffSupport [ cppad ]
  ++ lib.optionals casadiSupport [ casadi ]
  ++ lib.optionals codegenSupport [ cppadcodegen ]
  ++ lib.optionals collisionSupport [ coal ];

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

  cmakeFlags = jrl-cmakemodules.docsCmakeFlags ++ [
    (lib.cmakeBool "BUILD_PYTHON_INTERFACE" false)
    (lib.cmakeBool "BUILD_TESTING" finalAttrs.finalPackage.doCheck)
    (lib.cmakeBool "BUILD_WITH_AUTODIFF_SUPPORT" autodiffSupport)
    (lib.cmakeBool "BUILD_WITH_CASADI_SUPPORT" casadiSupport)
    (lib.cmakeBool "BUILD_WITH_CODEGEN_SUPPORT" codegenSupport)
    (lib.cmakeBool "BUILD_WITH_COLLISION_SUPPORT" collisionSupport)
    (lib.cmakeBool "INSTALL_DOCUMENTATION" true)
  ];

  doCheck = true;

  passthru = {
    inherit
      autodiffSupport
      casadiSupport
      codegenSupport
      collisionSupport
      ;
    updateScript = nix-update-script { };
  };

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
