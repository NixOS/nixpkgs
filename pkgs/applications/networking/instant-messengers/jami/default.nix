{ stdenv
, lib
, pkg-config
, fetchFromGitLab
, gitUpdater
, ffmpeg_6

  # for daemon
, autoreconfHook
, perl # for pod2man
, alsa-lib
, asio
, dbus
, sdbus-cpp
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
, openssl
, restinio
, secp256k1
, speex
, udev
, webrtc-audio-processing
, zlib

  # for client
, cmake
, networkmanager # for libnm
, python3
, qttools # for translations
, wrapQtAppsHook
, libnotify
, qt5compat
, qtbase
, qtdeclarative
, qrencode
, qtmultimedia
, qtnetworkauth
, qtpositioning
, qtsvg
, qtwebengine
, qtwebchannel
, withWebengine ? true

  # for pjsip
, fetchFromGitHub
, pjsip

  # for opendht
, opendht
}:

let
  readLinesToList = with builtins; file: filter (s: isString s && stringLength s > 0) (split "\n" (readFile file));
in
stdenv.mkDerivation rec {
  pname = "jami";
  version = "20230922.0";

  src = fetchFromGitLab {
    domain = "git.jami.net";
    owner = "savoirfairelinux";
    repo = "jami-client-qt";
    rev = "stable/${version}";
    hash = "sha256-kSgT6kw8j6BUZY5bEuvs02l9o5YA+KwI515Mn8M2sPc=";
    fetchSubmodules = true;
  };

  pjsip-jami = pjsip.overrideAttrs (old:
    let
      patch-src = src + "/daemon/contrib/src/pjproject/";
    in
    rec {
      version = "97f45c2040c2b0cf6f3349a365b0e900a2267333";

      src = fetchFromGitHub {
        owner = "savoirfairelinux";
        repo = "pjproject";
        rev = version;
        hash = "sha256-QeD2o6uz9r5vc3Scs1oRKYZ+aNH+01TSxLBj71ssfj4=";
      };

      patches = (map (x: patch-src + x) (readLinesToList ./config/pjsip_patches));

      configureFlags = (readLinesToList ./config/pjsip_args_common)
        ++ lib.optionals stdenv.isLinux (readLinesToList ./config/pjsip_args_linux);
    });

  opendht-jami = opendht.override {
    enableProxyServerAndClient = true;
    enablePushNotifications = true;
  };

  dhtnet = stdenv.mkDerivation {
    pname = "dhtnet";
    version = "unstable-2023-09-18";

    src = fetchFromGitLab {
      domain = "git.jami.net";
      owner = "savoirfairelinux";
      repo = "dhtnet";
      rev = "2f3539bc19cf770cd23912c7eebe63e8d2f80515";
      hash = "sha256-jDqYVZed047QcaTH+U4jGC8RNT07hH+rZ3I1Lemg05Y=";
    };

    nativeBuildInputs = [
      cmake
      pkg-config
    ];

    buildInputs = [
      asio
      fmt
      gnutls
      http-parser
      jsoncpp
      libupnp
      msgpack
      opendht-jami
      openssl
      pjsip-jami
      restinio
    ];

    cmakeFlags = [
      "-DBUILD_SHARED_LIBS=Off"
      "-DBUILD_BENCHMARKS=Off"
      "-DBUILD_TOOLS=Off"
      "-DBUILD_TESTING=Off"
    ];

    meta = with lib; {
      description = "Lightweight Peer-to-Peer Communication Library";
      license = licenses.gpl3Only;
      platforms = platforms.linux;
      maintainers = [ maintainers.linsui ];
    };
  };

  daemon = stdenv.mkDerivation {
    pname = "jami-daemon";
    inherit src version meta;
    sourceRoot = "${src.name}/daemon";

    nativeBuildInputs = [
      autoreconfHook
      pkg-config
      perl
    ];

    buildInputs = [
      alsa-lib
      asio
      dbus
      dhtnet
      sdbus-cpp
      fmt
      ffmpeg_6
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

    enableParallelBuilding = true;
  };

  preConfigure = ''
    echo 'const char VERSION_STRING[] = "${version}";' > src/app/version.h
  '';

  nativeBuildInputs = [
    wrapQtAppsHook
    pkg-config
    cmake
    python3
    qttools
  ];

  buildInputs = [
    daemon
    ffmpeg_6
    libnotify
    networkmanager
    qtbase
    qt5compat
    qrencode
    qtnetworkauth
    qtdeclarative
    qtmultimedia
    qtpositioning
    qtsvg
    qtwebchannel
  ] ++ lib.optionals withWebengine [
    qtwebengine
  ];

  cmakeFlags = [
    "-DLIBJAMI_INCLUDE_DIR=${daemon}/include/jami"
    "-DLIBJAMI_XML_INTERFACES_DIR=${daemon}/share/dbus-1/interfaces"
  ] ++ lib.optionals (!withWebengine) [
    "-DWITH_WEBENGINE=false"
  ];

  qtWrapperArgs = [
    # With wayland the titlebar is not themed and the wmclass is wrong.
    "--set-default QT_QPA_PLATFORM xcb"
  ];

  postInstall = ''
    # Make the jamid d-bus services available
    ln -s ${daemon}/share/dbus-1 $out/share
  '';

  passthru.updateScript = gitUpdater {
    rev-prefix = "stable/";
  };

  meta = with lib; {
    homepage = "https://jami.net/";
    description = "The free and universal communication platform that respects the privacy and freedoms of its users";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.linsui ];
  };
}
