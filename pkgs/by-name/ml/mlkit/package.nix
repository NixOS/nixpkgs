{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  mlton,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mlkit";
  version = "4.7.18";

  src = fetchFromGitHub {
    owner = "melsman";
    repo = "mlkit";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-OACdbHwg3sEAVw+Fje0tWVHh7Xy6C/WdOQHfexOezlo=";
  };

  nativeBuildInputs = [
    autoreconfHook
    mlton
  ];

  buildFlags = [
    "mlkit"
    "mlkit_libs"
  ];

  doCheck = true;

  # MLKit intentionally has some of these in its test suite.
  # Since the test suite is available in `$out/share/mlkit/test`, we must disable this check.
  dontCheckForBrokenSymlinks = true;

  checkPhase = ''
    runHook preCheck
    echo ==== Running MLKit test suite: test ====
    make -C test_dev test
    echo ==== Running MLKit test suite: test_prof ====
    make -C test_dev test_prof
    runHook postCheck
  '';

  meta = {
    description = "Standard ML Compiler and Toolkit";
    homepage = "https://elsman.com/mlkit/";
    changelog = "https://github.com/melsman/mlkit/blob/v${finalAttrs.version}/NEWS.md";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ athas ];
  };
})
