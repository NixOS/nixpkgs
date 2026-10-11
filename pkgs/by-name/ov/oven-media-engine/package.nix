{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  srt,
  pkg-config,
  openssl,
  zlib,
  libvpx,
  libaom,
  libopus,
  libuuid,
  srtp,
  jemalloc,
  pcre2,
  hiredis,
  spdlog,
  whisper-cpp,
  ffmpeg_7,
}:

stdenv.mkDerivation rec {
  pname = "oven-media-engine";
  version = "0.21.0";

  src = fetchFromGitHub {
    owner = "OvenMediaLabs";
    repo = "OvenMediaEngine";
    rev = "v${version}";
    sha256 = "sha256-T/ec3Ac9Kwu2GjdszfbXlGroSuDeOuiz/zxoPA3HBlo=";
  };

  patches = [
    ./compat.patch
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DOME_USE_CLANG=OFF"
    "-DOME_SKIP_DEPENDENCY_CHECK=ON"
    "-DOME_BUILD_TESTS=OFF"
    "-DOME_HWACCEL_NVIDIA=OFF"
    "-DOME_HWACCEL_XMA=OFF"
  ];

  enableParallelBuilding = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    openssl
    srt
    zlib
    ffmpeg_7
    libvpx
    libaom
    libopus
    srtp
    jemalloc
    pcre2
    libuuid
    hiredis
    spdlog
    whisper-cpp
  ];

  installPhase = ''
    runHook preInstall

    install -Dm0755 bin/OvenMediaEngine $out/bin/OvenMediaEngine
    install -Dm0644 ../misc/conf_examples/Origin.xml $out/share/examples/origin_conf/Server.xml
    install -Dm0644 ../misc/conf_examples/Logger.xml $out/share/examples/origin_conf/Logger.xml
    install -Dm0644 ../misc/conf_examples/Edge.xml $out/share/examples/edge_conf/Server.xml
    install -Dm0644 ../misc/conf_examples/Logger.xml $out/share/examples/edge_conf/Logger.xml

    runHook postInstall
  '';

  meta = {
    description = "Open-source streaming video service with sub-second latency";
    mainProgram = "OvenMediaEngine";
    homepage = "https://ovenmediaengine.com";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      lukegb
      findus
    ];
    platforms = lib.platforms.linux;
  };
}
