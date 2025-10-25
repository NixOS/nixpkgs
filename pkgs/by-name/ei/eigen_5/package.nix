{
  lib,

  stdenv,
  fetchFromGitLab,
  fetchpatch,
  nix-update-script,

  # nativeBuildInputs
  doxygen,
  cmake,
  graphviz,

  # nativeCheckInputs
  ctestCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "eigen";
  version = "5.0.0";

  src = fetchFromGitLab {
    owner = "libeigen";
    repo = "eigen";
    tag = finalAttrs.version;
    hash = "sha256-L1KUFZsaibC/FD6abTXrT3pvaFhbYnw+GaWsxM2gaxM=";
  };

  patches = [
    # fix geo_homogeneous test
    # ref https://gitlab.com/libeigen/eigen/-/merge_requests/2003 merged upstream
    (fetchpatch {
      url = "https://gitlab.com/libeigen/eigen/-/commit/5a75d3ee5c3562d7574dd61cf2d79d83631aeead.patch";
      hash = "sha256-KkPtCEv8z5AJ2mkZD7wVh0xEzf855IOXxVzwhUa3Nk4=";
    })
    # fix bug1213 test
    # ref https://gitlab.com/libeigen/eigen/-/merge_requests/2005 merged upstream
    (fetchpatch {
      url = "https://gitlab.com/libeigen/eigen/-/commit/3e1367a3b5efcdc8ce716db77a322cedeb5e01b4.patch";
      hash = "sha256-oykUbzaZeVW1A8nBoiMtJvh68Zpu7PDFtAfAjtTQoC0=";
    })
  ];

  outputs = [
    "out"
    "doc"
  ];

  nativeBuildInputs = [
    doxygen
    cmake
    graphviz
  ];

  nativeCheckInputs = [
    ctestCheckHook
  ];

  cmakeFlags = [
    (lib.cmakeBool "EIGEN_LEAVE_TEST_IN_ALL_TARGET" true) # Build tests in parallel
  ];

  # doesn't build for now,
  # ref. https://gitlab.com/libeigen/eigen/-/issues/2976
  # postInstall = ''
  #   cmake --build . -t install-doc
  # '';

  doCheck = true;

  disabledTests = [
    # https://gitlab.com/libeigen/eigen/-/issues/2977
    "basicstuff_8"

    # flaky
    "matrix_power_11"
    "product_small_10"
    "polynomialsolver_9"
    "qr_colpivoting_1"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://eigen.tuxfamily.org";
    description = "C++ template library for linear algebra: vectors, matrices, and related algorithms";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [
      sander
      raskin
      pbsds
    ];
    platforms = lib.platforms.unix;
  };
})
