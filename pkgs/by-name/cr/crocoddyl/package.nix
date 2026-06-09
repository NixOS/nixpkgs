{
  blas,
  cmake,
  doxygen,
  example-robot-data,
  fetchFromGitHub,
  ffmpeg,
  ipopt,
  lapack,
  llvmPackages,
  lib,
  pinocchio,
  pkg-config,
  stdenv,

  withMultithread ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "crocoddyl";
  version = "3.2.1";

  src = fetchFromGitHub {
    owner = "loco-3d";
    repo = "crocoddyl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7L4S9DQ470pTXARBuerahO9LD1LQfYOZGrYAZalMPUs=";
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

  buildInputs = lib.optionals (stdenv.hostPlatform.isDarwin && withMultithread) [
    llvmPackages.openmp
  ];

  checkInputs = [
    ffmpeg
  ];

  cmakeFlags = [
    (lib.cmakeBool "INSTALL_DOCUMENTATION" true)
    (lib.cmakeBool "BUILD_EXAMPLES" false)
    (lib.cmakeBool "BUILD_PYTHON_INTERFACE" false)
    (lib.cmakeBool "BUILD_WITH_MULTITHREADS" withMultithread)
  ];

  passthru = { inherit withMultithread; };

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
