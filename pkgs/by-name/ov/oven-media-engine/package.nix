{
  lib,
  stdenv,
  fetchFromGitHub,
  callPackage,
  ffmpeg-ome ? callPackage ./ffmpeg-ome-minimal.nix { },
  srt,
  bc,
  pkg-config,
  perl,
  openssl,
  zlib,
  libvpx,
  libopus,
  libuuid,
  srtp,
  jemalloc,
  pcre2,
  hiredis,
  spdlog,
  whisper-cpp,
}:

stdenv.mkDerivation rec {
  pname = "oven-media-engine";
  version = "0.20.5";

  src = fetchFromGitHub {
    owner = "AirenSoft";
    repo = "OvenMediaEngine";
    rev = "v${version}";
    sha256 = "sha256-GIjQ8lTZ0jEcZkhvx7lQ8sbHJ9KbJT77FsNt2Ca997Y=";
  };

  patches = [
    ./compat.patch
  ];

  makeFlags = [
    "release"
    "CONFIG_LIBRARY_PATHS="
    "CONFIG_PKG_PATHS="
    "GLOBAL_CC=$(CC)"
    "GLOBAL_CXX=$(CXX)"
    "GLOBAL_LD=$(CXX)"
    "SHELL=${stdenv.shell}"
  ];
  enableParallelBuilding = true;

  nativeBuildInputs = [
    bc
    pkg-config
    perl
  ];
  buildInputs = [
    openssl
    srt
    zlib
    ffmpeg-ome
    libvpx
    libopus
    srtp
    jemalloc
    pcre2
    libuuid
    hiredis
    spdlog
    whisper-cpp
  ];

  preBuild = ''
    cd src

    patchShebangs core/colorg++
    patchShebangs core/colorgcc
    patchShebangs projects/main/update_git_info.sh

    sed -i -e '/^CC =/d' -e '/^CXX =/d' -e '/^AR =/d' projects/third_party/pugixml-1.9/scripts/pugixml.make
  '';

  installPhase = ''
    install -Dm0755 bin/RELEASE/OvenMediaEngine $out/bin/OvenMediaEngine
    install -Dm0644 ../misc/conf_examples/Origin.xml $out/share/examples/origin_conf/Server.xml
    install -Dm0644 ../misc/conf_examples/Logger.xml $out/share/examples/origin_conf/Logger.xml
    install -Dm0644 ../misc/conf_examples/Edge.xml $out/share/examples/edge_conf/Server.xml
    install -Dm0644 ../misc/conf_examples/Logger.xml $out/share/examples/edge_conf/Logger.xml
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
