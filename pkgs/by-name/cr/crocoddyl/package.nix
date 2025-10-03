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
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "loco-3d";
    repo = "crocoddyl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-m7UiCa8ydjsAIhsFiShTi3/JaKgq2TCQ1XYAMyTNg1U=";
  };

  outputs = [
    "out"
    "doc"
  ];

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

  cmakeFlags = [
    (lib.cmakeBool "INSTALL_DOCUMENTATION" true)
    (lib.cmakeBool "BUILD_EXAMPLES" pythonSupport)
    (lib.cmakeBool "BUILD_PYTHON_INTERFACE" pythonSupport)
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
