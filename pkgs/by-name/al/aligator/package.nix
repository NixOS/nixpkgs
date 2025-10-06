{
  lib,
  fetchFromGitHub,
  fetchpatch,
  fontconfig,
  llvmPackages,
  nix-update-script,
  stdenv,

  # nativeBuildInputs
  doxygen,
  cmake,
  graphviz,
  pkg-config,

  # buildInputs
  fmt,

  # propagatedBuildInputs
  suitesparse,
  crocoddyl,
  pinocchio,

  # checkInputs
  gbenchmark,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "aligator";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "Simple-Robotics";
    repo = "aligator";
    tag = "v${finalAttrs.version}";
    hash = "sha256-x9vOj5Dy2SaQOLBCM13wZ/4SxgBz+99K/UxJqhKTg3c=";
  };

  patches = [
    # ref. https://github.com/Simple-Robotics/aligator/pull/344 merged upstream
    (fetchpatch {
      name = "fix-compat-with-crocoddyl-v310.patch";
      url = "https://github.com/Simple-Robotics/aligator/commit/be6acbd9f558dc313c16bd8dc2d639eb0ec00f7e.patch";
      hash = "sha256-D2yvvnj4CcV2lJgaAh6oQShmEnXPd3NxTWMjtNIkN8U=";
    })
    # ref. https://github.com/Simple-Robotics/aligator/pull/347 merged upstream
    (fetchpatch {
      name = "build-standalone-python-interface.patch";
      url = "https://github.com/Simple-Robotics/aligator/commit/b0dd8a7f1c9b104a94bc4bd9764ae3d93ab02926.patch";
      hash = "sha256-Oeh29UUiaz0r94r+NnYrDUbZu/yNybCdyi+Gv7uiE54=";
    })
  ];

  outputs = [
    "doc"
    "out"
  ];

  strictDeps = true;

  nativeBuildInputs = [
    doxygen
    cmake
    graphviz
    pkg-config
  ];

  buildInputs = [
    fmt
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    llvmPackages.openmp
  ];

  propagatedBuildInputs = [
    crocoddyl
    pinocchio
    suitesparse
  ];

  checkInputs = [
    gbenchmark
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_PYTHON_INTERFACE" false)
    (lib.cmakeBool "BUILD_WITH_PINOCCHIO_SUPPORT" true)
    (lib.cmakeBool "BUILD_CROCODDYL_COMPAT" true)
    (lib.cmakeBool "BUILD_WITH_OPENMP_SUPPORT" true)
    (lib.cmakeBool "BUILD_WITH_CHOLMOD_SUPPORT" true)
    (lib.cmakeBool "GENERATE_PYTHON_STUBS" false) # this need git at configure time
  ];

  # Fontconfig error: Cannot load default config file: No such file: (null)
  env.FONTCONFIG_FILE = "${fontconfig.out}/etc/fonts/fonts.conf";

  preBuild = ''
    # silence matplotlib warning
    export MPLCONFIGDIR=$(mktemp -d)

    # Fontconfig error: No writable cache directories
    export XDG_CACHE_HOME=$(mktemp -d)
  '';

  doCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Versatile and efficient framework for constrained trajectory optimization";
    homepage = "https://github.com/Simple-Robotics/aligator";
    changelog = "https://github.com/Simple-Robotics/aligator/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ nim65s ];
    platforms = lib.platforms.unix;
  };
})
