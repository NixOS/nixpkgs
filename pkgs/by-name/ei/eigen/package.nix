{
  lib,

  stdenv,
  fetchFromGitLab,
  fetchpatch,

  # nativeBuildInputs
  cmake,

  # nativeCheckInputs
  ctestCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "eigen";
  version = "3.4.1";

  src = fetchFromGitLab {
    owner = "libeigen";
    repo = "eigen";
    tag = finalAttrs.version;
    hash = "sha256-NSq1tUfy2thz5gtsyASsKeYE4vMf71aSG4uXfrX86rk=";
  };

  patches = [
    # Fix CUDA-enabled CHOLMOD headers being included inside extern "C".
    # https://gitlab.com/libeigen/eigen/-/merge_requests/1561
    (fetchpatch {
      name = "eigen-cholmod-cuda.patch";
      url = "https://gitlab.com/libeigen/eigen/-/commit/0b3df4a6e622e7ffbd17240ee6f245db27aadb12.patch";
      hash = "sha256-JSJyPwWESZPfVJSWJXX9RIqS0eyS7hpH4SoXZMgfJcQ=";
    })
    # fix bug1213 test
    # ref https://gitlab.com/libeigen/eigen/-/merge_requests/2005 merged upstream
    (fetchpatch {
      url = "https://gitlab.com/libeigen/eigen/-/commit/3e1367a3b5efcdc8ce716db77a322cedeb5e01b4.patch";
      hash = "sha256-oykUbzaZeVW1A8nBoiMtJvh68Zpu7PDFtAfAjtTQoC0=";
    })
  ];

  prePatch = ''
    # Match the include indentation used by the upstream CHOLMOD patch.
    substituteInPlace Eigen/CholmodSupport \
      --replace-fail '  #include <cholmod.h>' '#include <cholmod.h>'
  '';

  nativeBuildInputs = [
    cmake
  ];

  nativeCheckInputs = [
    ctestCheckHook
  ];

  strictDeps = true;

  cmakeFlags = [
    (lib.cmakeBool "EIGEN_LEAVE_TEST_IN_ALL_TARGET" true) # Build tests in parallel
  ];

  # too many flaky tests
  doCheck = false;

  __structuredAttrs = true;

  meta = {
    homepage = "https://eigen.tuxfamily.org";
    description = "C++ template library for linear algebra: vectors, matrices, and related algorithms";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [
      raskin
    ];
    platforms = lib.platforms.unix;
  };
})
