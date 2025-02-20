{
  blas,
  cmake,
  doxygen,
  example-robot-data,
  fetchFromGitHub,
  ipopt,
  lapack,
  lib,
  pinocchio,
  pkg-config,
  pythonSupport ? false,
  python3Packages,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "crocoddyl";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "loco-3d";
    repo = "crocoddyl";
    rev = "v${finalAttrs.version}";
    hash = "sha256-j3TL5TpIdTkTO32Fuu+LyiieiXoOMvShi/LbBL5YYzA=";
  };

  outputs = [
    "out"
    "doc"
  ];

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
      blas
      ipopt
      lapack
    ]
    ++ lib.optionals (!pythonSupport) [
      example-robot-data
      pinocchio
    ]
    ++ lib.optionals pythonSupport [
      python3Packages.example-robot-data
      python3Packages.pinocchio
      python3Packages.scipy
    ];

  cmakeFlags =
    [
      (lib.cmakeBool "INSTALL_DOCUMENTATION" true)
      (lib.cmakeBool "BUILD_EXAMPLES" pythonSupport)
      (lib.cmakeBool "BUILD_PYTHON_INTERFACE" pythonSupport)
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # ref. https://github.com/stack-of-tasks/pinocchio/issues/2563
      # remove this for crocoddyl >= 3.0.0
      (lib.cmakeFeature "CMAKE_CTEST_ARGUMENTS" "--exclude-regex;test_pybinds_*")
    ];

  prePatch = ''
    substituteInPlace \
      examples/CMakeLists.txt \
      examples/log/check_logfiles.sh \
      --replace-fail /bin/bash ${stdenv.shell}
  '';

  doCheck = true;
  pythonImportsCheck = [ "crocoddyl" ];
  checkInputs = lib.optionals pythonSupport [ python3Packages.scipy ];

  meta = with lib; {
    description = "Crocoddyl optimal control library";
    homepage = "https://github.com/loco-3d/crocoddyl";
    license = licenses.bsd3;
    maintainers = with maintainers; [
      nim65s
      wegank
    ];
    platforms = platforms.unix;
  };
})
