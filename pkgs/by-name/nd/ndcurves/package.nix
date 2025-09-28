{
  cmake,
  doxygen,
  fetchFromGitHub,
  jrl-cmakemodules,
  lib,
  pinocchio,
  pkg-config,
  python3Packages,
  pythonSupport ? false,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ndcurves";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "loco-3d";
    repo = "ndcurves";
    rev = "v${finalAttrs.version}";
    hash = "sha256-dDH2XpnlBlhG5Q8N9Aljxvf/K9jFuiAx0lyBIcXNOZE=";
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
    jrl-cmakemodules
  ]
  ++ lib.optionals pythonSupport [
    python3Packages.eigenpy
    python3Packages.pinocchio
  ]
  ++ lib.optional (!pythonSupport) pinocchio;

  cmakeFlags = [
    (lib.cmakeBool "BUILD_PYTHON_INTERFACE" pythonSupport)
    (lib.cmakeBool "CURVES_WITH_PINOCCHIO_SUPPORT" true)
  ]
  ++ lib.optional stdenv.hostPlatform.isAarch64 (
    lib.cmakeFeature "CMAKE_CTEST_ARGUMENTS" "--exclude-regex;'curves_tests|python-curves'"
  )
  ++ lib.optional (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) (
    lib.cmakeFeature "CMAKE_CTEST_ARGUMENTS" "--exclude-regex;'test-so3-smooth'"
  );

  doCheck = true;

  pythonImportsCheck = [ "ndcurves" ];

  meta = {
    description = "Library for creating smooth cubic splines";
    homepage = "https://github.com/loco-3d/ndcurves";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.nim65s ];
    platforms = lib.platforms.unix;
  };
})
