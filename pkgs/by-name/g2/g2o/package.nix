{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  eigen,
  suitesparse,
  blas,
  lapack,
  libGLU,
  libsForQt5,
  spdlog,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "g2o";
  version = "20241228";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "RainerKuemmerle";
    repo = "g2o";
    tag = "${finalAttrs.version}_git";
    hash = "sha256-MW1IO1P2e3KgurOW5ZfHlxK0m5sF0JhdLmvQNEHWEtI=";
  };

  patches = [
    # Removes a reference to gcc that is only used in a debug message
    ./remove-compiler-reference.patch

    # Fix invalid fmt format string (compile-time error with fmt 12)
    # https://github.com/RainerKuemmerle/g2o/pull/899
    (fetchpatch {
      name = "fix-fmt-format-string.patch";
      url = "https://github.com/RainerKuemmerle/g2o/commit/18b1894778a7a758a8fb1d4db49f45661ea4ea38.patch";
      hash = "sha256-sS9dYNB1RCTLVc5dnO/fDpcUD2i3ag8Gl/nDwUP43yw=";
    })
  ];

  outputs = [
    "out"
    "dev"
  ];
  separateDebugInfo = true;

  nativeBuildInputs = [
    cmake
    libsForQt5.wrapQtAppsHook
  ];
  buildInputs = [
    eigen
    suitesparse
    blas
    lapack
    libGLU
    libsForQt5.qtbase
    libsForQt5.libqglviewer
  ];
  propagatedBuildInputs = [ spdlog ];

  dontWrapQtApps = true;

  cmakeFlags = [
    # Detection script is broken
    (lib.cmakeFeature "QGLVIEWER_INCLUDE_DIR" "${libsForQt5.libqglviewer}/include/QGLViewer")
    (lib.cmakeBool "G2O_BUILD_EXAMPLES" false)
  ]
  ++ lib.optionals stdenv.hostPlatform.isx86_64 [
    (lib.cmakeBool "DO_SSE_AUTODETECT" false)
    (lib.cmakeBool "DISABLE_SSE3" (!stdenv.hostPlatform.sse3Support))
    (lib.cmakeBool "DISABLE_SSE4_1" (!stdenv.hostPlatform.sse4_1Support))
    (lib.cmakeBool "DISABLE_SSE4_2" (!stdenv.hostPlatform.sse4_2Support))
    (lib.cmakeBool "DISABLE_SSE4_A" (!stdenv.hostPlatform.sse4_aSupport))
  ];

  meta = {
    description = "General Framework for Graph Optimization";
    homepage = "https://github.com/RainerKuemmerle/g2o";
    license = with lib.licenses; [
      bsd3
      lgpl3
      gpl3
    ];
    maintainers = with lib.maintainers; [ lopsided98 ];
    platforms = lib.platforms.all;
    # fatal error: 'qglviewer.h' file not found
    broken = stdenv.hostPlatform.isDarwin;
  };
})
