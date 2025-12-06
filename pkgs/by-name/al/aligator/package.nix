{
  lib,
  fetchFromGitHub,
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
  catch2,
  gbenchmark,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "aligator";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "Simple-Robotics";
    repo = "aligator";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OyCJa2iTkCxVLooSKdVgBd0y7rHObo4vFcc56t48TSY=";
  };

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
    catch2
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
