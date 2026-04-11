{
  blas,
  cmake,
  doxygen,
  example-robot-data,
  fetchFromGitHub,
  ffmpeg,
  ipopt,
  lapack,
  lib,
  pinocchio,
  pkg-config,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "crocoddyl";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "loco-3d";
    repo = "crocoddyl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EYvakM81Ot/AtXElJbcQNo7IydBtRgy+8a0cY06CzQ8=";
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

  checkInputs = [
    ffmpeg
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

  meta = {
    description = "Crocoddyl optimal control library";
    homepage = "https://github.com/loco-3d/crocoddyl";
    changelog = "https://github.com/loco-3d/crocoddyl/blob/devel/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      nim65s
      wegank
    ];
    platforms = lib.platforms.unix;
  };
})
