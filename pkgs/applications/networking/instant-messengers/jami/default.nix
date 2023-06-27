{ stdenv
, lib
, pkg-config
, fetchFromGitLab
, gitUpdater
, ffmpeg_5

  # for daemon
, autoreconfHook
, perl # for pod2man
, alsa-lib
, asio
, dbus
, dbus_cplusplus
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
, msgpack-cxx
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
  version = "20230323.0";

  src = fetchFromGitLab {
    domain = "git.jami.net";
    owner = "savoirfairelinux";
    repo = "jami-client-qt";
    rev = "stable/${version}";
    hash = "sha256-X8iIT8UtI2Vq0Ne5e2ahSPN4g7QLZGnq3SZV/NY+1pY=";
    fetchSubmodules = true;
  };

  pjsip-jami = pjsip.overrideAttrs (old:
    let
      patch-src = src + "/daemon/contrib/src/pjproject/";
    in
    rec {
      version = "3b78ef1c48732d238ba284cdccb04dc6de79c54f";

      src = fetchFromGitHub {
        owner = "savoirfairelinux";
        repo = "pjproject";
        rev = version;
        hash = "sha256-hrm5tDM2jknU/gWMeO6/FhqOvay8bajFid39OiEtAAQ=";
      };

      patches = (map (x: patch-src + x) (readLinesToList ./config/pjsip_patches));

      configureFlags = (readLinesToList ./config/pjsip_args_common)
        ++ lib.optionals stdenv.isLinux (readLinesToList ./config/pjsip_args_linux);
    });

  opendht-jami = opendht.override {
    enableProxyServerAndClient = true;
    enablePushNotifications = true;
  };

  daemon = stdenv.mkDerivation {
    pname = "jami-daemon";
    inherit src version meta;
    sourceRoot = "source/daemon";

    patches = [ ./0001-fix-annotations-in-bin-dbus-cx.ring.Ring.CallManager.patch ];

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
      ffmpeg_5
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
      msgpack-cxx
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
    ffmpeg_5
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
