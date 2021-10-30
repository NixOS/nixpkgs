{ src
, version
, jami-meta
, stdenv
, lib
, autoreconfHook
, pkg-config
, perl # for pod2man
, ffmpeg
, pjsip
, alsa-lib
, asio
, dbus
, dbus_cplusplus
, fmt
, gmp
, libarchive
, libgit2
, libnatpmp
, secp256k1
, openssl
, opendht
, speex
, webrtc-audio-processing
, jsoncpp
, gnutls
, zlib
, libyamlcpp
, libpulseaudio
, jack
, udev
, libupnp
, msgpack
, restinio
, http-parser
}:

let
  readLinesToList = with builtins; file: filter (s: isString s && stringLength s > 0) (split "\n" (readFile file));

  ffmpeg-jami = ffmpeg.overrideAttrs (old:
    let
      patch-src = src + "/daemon/contrib/src/ffmpeg/";
    in
    {
      patches = old.patches ++ (map (x: patch-src + x) (readLinesToList ./config/ffmpeg_patches));
      configureFlags = old.configureFlags
        ++ (readLinesToList ./config/ffmpeg_args_common)
        ++ lib.optionals stdenv.isLinux (readLinesToList ./config/ffmpeg_args_linux)
        ++ lib.optionals (stdenv.isx86_32 || stdenv.isx86_64) (readLinesToList ./config/ffmpeg_args_x86);
      outputs = [ "out" "doc" ];
    });

  pjsip-jami = pjsip.overrideAttrs (old:
    let
      patch-src = src + "/daemon/contrib/src/pjproject/";
    in
    {
      patches = old.patches ++ (map (x: patch-src + x) (readLinesToList ./config/pjsip_patches));
    });

  opendht-jami = opendht.override {
    enableProxyServerAndClient = true;
    enablePushNotifications = true;
  };

in stdenv.mkDerivation {
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
    libarchive
    libgit2
    libnatpmp
    opendht-jami
    pjsip-jami
    secp256k1
    openssl
    speex
    webrtc-audio-processing
    zlib
    libyamlcpp
    jsoncpp
    libpulseaudio
    jack
    opendht
    libupnp
    udev
    msgpack
    restinio
    http-parser
  ];

  doCheck = false; # The tests fail to compile due to missing headers.

  enableParallelBuilding = true;

  passthru = {
    updateScript = ./update.sh;
    ffmpeg = ffmpeg-jami;
    pjsip = pjsip-jami;
    opendht = opendht-jami;
  };

  meta = jami-meta // {
    description = "The daemon" + jami-meta.description;
  };
}
