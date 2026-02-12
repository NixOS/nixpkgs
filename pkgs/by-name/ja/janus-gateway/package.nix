{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  gengetopt,
  glib,
  libconfig,
  libnice,
  jansson,
  boringssl,
  zlib,
  srtp,
  libuv,
  libmicrohttpd,
  curl,
  libwebsockets,
  sofia_sip,
  libogg,
  libopus,
  usrsctp,
  ffmpeg,
}:

let
  libwebsockets_janus = libwebsockets.overrideAttrs (_: {
    configureFlags = [
      "-DLWS_MAX_SMP=1"
      "-DLWS_WITHOUT_EXTENSIONS=0"
    ];
  });
in

stdenv.mkDerivation (finalAttrs: {
  pname = "janus-gateway";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "meetecho";
    repo = "janus-gateway";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-Kt36rnBwmrf2/xDD4FR/T4Qlq4wx/Lq8fId6EgjBxkA=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    gengetopt
  ];

  buildInputs = [
    glib
    libconfig
    libnice
    jansson
    boringssl
    zlib
    srtp
    libuv
    libmicrohttpd
    curl
    libwebsockets_janus
    sofia_sip
    libogg
    libopus
    usrsctp
    ffmpeg
  ];

  enableParallelBuilding = true;

  configureFlags = [
    "--enable-boringssl=${lib.getDev boringssl}"
    "--enable-libsrtp2"
    "--enable-turn-rest-api"
    "--enable-json-logger"
    "--enable-gelf-event-handler"
    "--enable-post-processing"
  ];

  makeFlags = [
    "BORINGSSL_LIBS=-L${lib.getLib boringssl}/lib"
    # Linking with CXX because boringssl static libraries depend on C++ stdlib.
    # Upstream issue: https://www.github.com/meetecho/janus-gateway/issues/3456
    "CCLD=${stdenv.cc.targetPrefix}c++"
  ];

  outputs = [
    "out"
    "dev"
    "doc"
    "man"
  ];

  postInstall = ''
    moveToOutput share/janus "$doc"
    moveToOutput etc "$doc"
  '';

  meta = {
    description = "General purpose WebRTC server";
    homepage = "https://janus.conf.meetecho.com/";
    changelog = "https://github.com/meetecho/janus-gateway/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ fpletz ];
  };
})
