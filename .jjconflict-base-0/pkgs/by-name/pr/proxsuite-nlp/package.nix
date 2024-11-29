{
  cmake,
  doxygen,
  eigenrand,
  example-robot-data,
  fetchFromGitHub,
  fmt,
  fontconfig,
  graphviz,
  lib,
  stdenv,
  pinocchio,
  pkg-config,
  proxsuite,
  python3Packages,
  pythonSupport ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "proxsuite-nlp";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "Simple-Robotics";
    repo = "proxsuite-nlp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-JWMvPIxmZ5vSVS3nSlhFyNu8hLSVTc7Hdvd4YmE/pI8=";
  };

  outputs = [
    "out"
    "doc"
  ];

  nativeBuildInputs = [
    cmake
    doxygen
    graphviz
    pkg-config
  ] ++ lib.optional pythonSupport python3Packages.pythonImportsCheckHook;
  checkInputs = [ eigenrand ] ++ lib.optional pythonSupport python3Packages.pytest;
  propagatedBuildInputs =
    [
      example-robot-data
      fmt
    ]
    ++ lib.optionals pythonSupport [
      python3Packages.pinocchio
      python3Packages.proxsuite
    ]
    ++ lib.optionals (!pythonSupport) [
      pinocchio
      proxsuite
    ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_PYTHON_INTERFACE" pythonSupport)
    (lib.cmakeBool "BUILD_WITH_PINOCCHIO_SUPPORT" true)
    (lib.cmakeBool "BUILD_WITH_PROXSUITE_SUPPORT" true)
  ];

  # Fontconfig error: Cannot load default config file: No such file: (null)
  env.FONTCONFIG_FILE = "${fontconfig.out}/etc/fonts/fonts.conf";

  # Fontconfig error: No writable cache directories
  preBuild = "export XDG_CACHE_HOME=$(mktemp -d)";

  doCheck = true;
  pythonImportsCheck = [ "proxsuite_nlp" ];

  meta = {
    description = "Primal-dual augmented Lagrangian solver for nonlinear programming on manifolds";
    homepage = "https://github.com/Simple-Robotics/proxsuite-nlp";
    changelog = "https://github.com/Simple-Robotics/proxsuite-nlp/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ nim65s ];
    platforms = lib.platforms.unix;
  };
})
