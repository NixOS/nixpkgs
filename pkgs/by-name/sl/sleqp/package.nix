{
  blas,
  check,
  cmake,
  doxygen,
  fetchFromGitHub,
  highs,
  lapack,
  lib,
  pkg-config,
  pythonSupport ? false,
  python3Packages,
  suitesparse,
  stdenv,
  trlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sleqp";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "chrhansk";
    repo = "sleqp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ycO7s13LT/Gi01XFjTeZQCN+TiAVlp2zXjrlI7vfgTk=";
  };

  postPatch = ''
    substituteInPlace bindings/python/cmake/python_install.cmake.in \
      --replace-fail "--no-deps" "--no-deps --no-cache-dir --no-build-isolation --prefix $out"
  '';

  nativeBuildInputs = [
    doxygen
    cmake
    pkg-config
  ];
  buildInputs =
    [
      blas
      check
      highs
      lapack
      suitesparse
      trlib
    ]
    ++ lib.optionals pythonSupport [
      python3Packages.cython
      python3Packages.numpy
      python3Packages.pip
      python3Packages.pytest
      python3Packages.setuptools
      python3Packages.scipy
      python3Packages.tox
      python3Packages.wheel
    ];

  cmakeFlags = [
    (lib.cmakeBool "SLEQP_ENABLE_PYTHON" pythonSupport)
    "-DSLEQP_LPS=HiGHS"
  ];

  meta = {
    description = "An active set-based NLP solver";
    homepage = "https://github.com/chrhansk/sleqp";
    changelog = "https://github.com/chrhansk/sleqp/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ nim65s ];
  };
})
