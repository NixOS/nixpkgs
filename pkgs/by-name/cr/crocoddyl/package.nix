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
  ];

  propagatedBuildInputs = [
    blas
    ipopt
    lapack
    example-robot-data
    pinocchio
  ];

  cmakeFlags = [
    (lib.cmakeBool "INSTALL_DOCUMENTATION" true)
    (lib.cmakeBool "BUILD_EXAMPLES" false)
    (lib.cmakeBool "BUILD_PYTHON_INTERFACE" false)
  ];

  prePatch = ''
    substituteInPlace \
      examples/CMakeLists.txt \
      examples/log/check_logfiles.sh \
      --replace-fail /bin/bash ${stdenv.shell}
  '';

  doCheck = true;

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
