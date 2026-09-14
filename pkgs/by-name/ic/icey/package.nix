{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  openssl,
  ffmpeg,
  libuv,
  llhttp,
  minizip,
  nlohmann_json,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "icey";
  version = "2.4.5";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "nilstate";
    repo = "icey";
    tag = finalAttrs.version;
    hash = "sha256-QCO2pG2/3fES1gpxUE7DWcd/HV5JpBPRBTWtJM55oto=";
  };

  outputs = [
    "out"
    "dev"
  ];

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    ffmpeg
    libuv
    llhttp
    minizip
    nlohmann_json
    openssl
    zlib
  ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DUSE_SYSTEM_DEPS=ON"
    "-DBUILD_TESTS=OFF"
    "-DBUILD_SAMPLES=OFF"
    "-DBUILD_APPLICATIONS=OFF"
    "-DBUILD_FUZZERS=OFF"
    "-DBUILD_BENCHMARKS=OFF"
    "-DBUILD_PERF=OFF"
    "-DBUILD_ALPHA=OFF"
    "-DCMAKE_DISABLE_FIND_PACKAGE_Doxygen=TRUE"
    "-DENABLE_NATIVE_ARCH=OFF"
    "-DWITH_FFMPEG=ON"
    "-DWITH_LIBDATACHANNEL=OFF"
    "-DBUILD_MODULE_webrtc=OFF"
    "-DWITH_OPENCV=OFF"
  ];

  postInstall = ''
    if [ -d "$out/include" ]; then
      moveToOutput include "$dev"
    fi
    if [ -d "$out/lib/cmake" ]; then
      moveToOutput lib/cmake "$dev"
    fi
    if [ -d "$out/lib/pkgconfig" ]; then
      moveToOutput lib/pkgconfig "$dev"
    fi
    shopt -s nullglob
    for archive in "$out"/lib/*.a; do
      moveToOutput "''${archive#$out/}" "$dev"
    done
  '';

  meta = {
    description = "C++20 real-time media stack and libwebrtc alternative";
    homepage = "https://0state.com/icey/";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ auscaster ];
    platforms = lib.platforms.linux;
  };
})
