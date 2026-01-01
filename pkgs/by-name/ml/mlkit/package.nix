{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  mlton,
}:

stdenv.mkDerivation rec {
  pname = "mlkit";
<<<<<<< HEAD
  version = "4.7.17";
=======
  version = "4.7.14";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "melsman";
    repo = "mlkit";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-1MLxBK/XYk4flBac34D2y6MJMuuxT6wT+Yo1WFaiYI4=";
=======
    sha256 = "sha256-0nAQHBcQgGdcWd4SFhDon7I0zi5U+YRTdGvG78tri6A=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
    changelog = "https://github.com/melsman/mlkit/blob/v${version}/NEWS.md";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ athas ];
  };
}
