{ stdenv
, lib
, pkg-config
, fetchFromGitLab
, fetchpatch
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
  version = "20230619.1";

  src = fetchFromGitLab {
    domain = "git.jami.net";
    owner = "savoirfairelinux";
    repo = "jami-client-qt";
    rev = "stable/${version}";
    hash = "sha256-gOl4GtGmEvhM8xtlyFvTwXrUsbocUKULnVy9cnCNAM0=";
    fetchSubmodules = true;
  };

  pjsip-jami = pjsip.overrideAttrs (old:
    let
      patch-src = src + "/daemon/contrib/src/pjproject/";
    in
    rec {
      version = "e4b83585a0bdf1523e808a4fc1946ec82ac733d0";

      src = fetchFromGitHub {
        owner = "savoirfairelinux";
        repo = "pjproject";
        rev = version;
        hash = "sha256-QeD2o6uz9r5vc3Scs1oRKYZ+aNH+01TSxLBj71ssfj4=";
      };

      patches = (map (x: patch-src + x) (readLinesToList ./config/pjsip_patches)) ++ [
        (fetchpatch {
          name = "CVE-2023-27585.patch";
          url = "https://github.com/pjsip/pjproject/commit/d1c5e4da5bae7f220bc30719888bb389c905c0c5.patch";
          hash = "sha256-+yyKKTKG2FnfyLWnc4S80vYtDzmiu9yRmuqb5eIulPg=";
        })
      ];

      patchFlags = [ "-p1" "-l" ];

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

    nativeBuildInputs = [
      autoreconfHook
      pkg-config
      perl
    ];

    buildInputs = [
      alsa-lib
      asio
      dbus
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

  postPatch = ''
    substituteInPlace src/app/commoncomponents/ModalTextEdit.qml \
      --replace 'required property string placeholderText' 'property string placeholderText: ""'
  '';

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
