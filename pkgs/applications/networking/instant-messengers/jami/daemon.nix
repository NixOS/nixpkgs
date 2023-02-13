{ src
, version
, jami-meta
, stdenv
, autoreconfHook
, pkg-config
, perl # for pod2man
, alsa-lib
, asio
, dbus
, dbus_cplusplus
, ffmpeg-jami
, fmt
, gmp
, gnutls
, http-parser
, jack
, jsoncpp
, libarchive
, libgit2
, libnatpmp
, libpulseaudio
, libupnp
, yaml-cpp
, msgpack
, opendht-jami
, openssl
, pjsip-jami
, restinio
, secp256k1
, speex
, udev
, webrtc-audio-processing
, zlib
}:

stdenv.mkDerivation {
  pname = "jami-daemon";
  inherit src version;
  sourceRoot = "source/daemon";

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    perl
  ];

  buildInputs = [
    alsa-lib
    asio
    dbus
    dbus_cplusplus
    fmt
    ffmpeg-jami
    gmp
    gnutls
    http-parser
    jack
    jsoncpp
    libarchive
    libgit2
    libnatpmp
    libpulseaudio
    libupnp
    yaml-cpp
    msgpack
    opendht-jami
    openssl
    pjsip-jami
    restinio
    secp256k1
    speex
    udev
    webrtc-audio-processing
    zlib
  ];

  doCheck = false; # The tests fail to compile due to missing headers.

  enableParallelBuilding = true;

  passthru = {
    updateScript = ./update.sh;
  };

  meta = jami-meta // {
    description = "The daemon" + jami-meta.description;
  };
}
