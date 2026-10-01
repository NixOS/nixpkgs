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

stdenv.mkDerivation rec {
  pname = "g2o";
  version = "20241228";

  src = fetchFromGitHub {
    owner = "RainerKuemmerle";
    repo = "g2o";
    rev = "${version}_git";
    hash = "sha256-MW1IO1P2e3KgurOW5ZfHlxK0m5sF0JhdLmvQNEHWEtI=";
  };

  patches = [
    # Removes a reference to gcc that is only used in a debug message
    ./remove-compiler-reference.patch
    # Fix format string argument mismatch rejected at compile time by fmt 12
    (fetchpatch {
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
    "-DQGLVIEWER_INCLUDE_DIR=${libsForQt5.libqglviewer}/include/QGLViewer"
    "-DG2O_BUILD_EXAMPLES=OFF"
  ]
  ++ lib.optionals stdenv.hostPlatform.isx86_64 [
    "-DDO_SSE_AUTODETECT=OFF"
    "-DDISABLE_SSE3=${if stdenv.hostPlatform.sse3Support then "OFF" else "ON"}"
    "-DDISABLE_SSE4_1=${if stdenv.hostPlatform.sse4_1Support then "OFF" else "ON"}"
    "-DDISABLE_SSE4_2=${if stdenv.hostPlatform.sse4_2Support then "OFF" else "ON"}"
    "-DDISABLE_SSE4_A=${if stdenv.hostPlatform.sse4_aSupport then "OFF" else "ON"}"
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
}
