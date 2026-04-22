{
  stdenv,
  lib,
  pkg-config,
  fetchFromGitLab,
  fetchpatch,
  gitUpdater,
  ffmpeg_6,
  ninja,

  # for daemon
  alsa-lib,
  asio,
  dbus,
  sdbus-cpp_2,
  fmt,
  gmp,
  gnutls,
  llhttp,
  jsoncpp,
  libarchive,
  libgit2,
  libjack2,
  libnatpmp,
  libpulseaudio,
  libupnp,
  msgpack-cxx,
  openssl,
  restinio,
  secp256k1,
  simdutf,
  speex,
  udev,
  webrtc-audio-processing_0_3,
  yaml-cpp,
  zlib,

  # for dhtnet
  expected-lite,

  # for client
  cmake,
  git,
  networkmanager, # for libnm
  python3,
  libnotify,
  md4c,
  html-tidy,
  hunspell,
  qrencode,
  qt6Packages,
  wrapGAppsHook3,
  zxing-cpp,
  withWebengine ? true,

  # for pjsip
  fetchFromGitHub,
  pjsip,

  # for opendht
  opendht,
}:

stdenv.mkDerivation rec {
  pname = "jami";
  version = "20260420.0";

  src = fetchFromGitLab {
    domain = "git.jami.net";
    owner = "savoirfairelinux";
    repo = "jami-client-qt";
    rev = "stable/${version}";
    hash = "sha256-oZEV2Hm+O/KNY/zY1+arh1tBJMLixrowif8P8sy/rkA=";
    fetchSubmodules = true;
  };

  patches = [
    (fetchpatch {
      url = "https://gitlab.archlinux.org/archlinux/packaging/packages/jami-qt/-/raw/1adf56fb39f13f27ef727672755eff9f233c0656/fix-link.patch";
      hash = "sha256-VsQbOPHyNFcRhpae+9UCaUJdHH8bMGf3ZIAW3RKiu6k=";
    })
    (fetchpatch {
      url = "https://gitlab.archlinux.org/archlinux/packaging/packages/jami-qt/-/raw/1adf56fb39f13f27ef727672755eff9f233c0656/zxing-cpp-3.patch";
      hash = "sha256-fTGrsdeC3kN277DvSuKyR5fMZhtBmk1nsL2BbeHYjTY=";
    })
  ];

  pjsip-jami = pjsip.overrideAttrs (old: {
    version = "sfl-2.15-unstable-2026-03-26";

    src = fetchFromGitHub {
      owner = "savoirfairelinux";
      repo = "pjproject";
      rev = "00ce02ff8c0c16d3570f7c33659c56b8b4dfebb9";
      hash = "sha256-YieYWE/dNGJ9pEYnFmWo4yMqaVFoxfZFksaTHWjMApc=";
    };

    configureFlags = [
      "--disable-sound"
      "--enable-video"
      "--enable-ext-sound"
      "--disable-android-mediacodec"
      "--disable-speex-aec"
      "--disable-g711-codec"
      "--disable-l16-codec"
      "--disable-gsm-codec"
      "--disable-g722-codec"
      "--disable-g7221-codec"
      "--disable-speex-codec"
      "--disable-ilbc-codec"
      "--disable-opencore-amr"
      "--disable-silk"
      "--disable-sdl"
      "--disable-ffmpeg"
      "--disable-v4l2"
      "--disable-openh264"
      "--disable-resample"
      "--disable-libwebrtc"
      "--with-gnutls=yes"
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ "--enable-epoll" ];

    buildInputs = old.buildInputs ++ [ gnutls ];
  });

  opendht-jami = opendht.override {
    enableProxyServerAndClient = true;
    enablePushNotifications = true;
  };

  dhtnet = stdenv.mkDerivation {
    pname = "dhtnet";
    version = "unstable-2026-03-18";

    src = fetchFromGitLab {
      domain = "git.jami.net";
      owner = "savoirfairelinux";
      repo = "dhtnet";
      rev = "4de1c17991b8f1d28e8704af20dcaf0be00d5cee";
      hash = "sha256-a/CxRibSXiiXEGNCVvcD4tpyRhy9o4oG22yoJ35Bync=";
    };

    postPatch = ''
      substituteInPlace dependencies/build.py \
        --replace-fail \
        "wget https://raw.githubusercontent.com/martinmoene/expected-lite/master/include/nonstd/expected.hpp -O" \
        "cp ${expected-lite}/include/nonstd/expected.hpp"
    '';

    nativeBuildInputs = [
      cmake
      pkg-config
    ];

    buildInputs = [
      asio
      fmt
      gnutls
      llhttp
      jsoncpp
      libupnp
      msgpack-cxx
      opendht-jami
      openssl
      pjsip-jami
      python3
      restinio
    ];

    cmakeFlags = [
      "-DBUILD_SHARED_LIBS=Off"
      "-DBUILD_BENCHMARKS=Off"
      "-DBUILD_TOOLS=Off"
      "-DBUILD_TESTING=Off"
      "-DBUILD_DEPENDENCIES=Off"
      "-DBUILD_EXAMPLE=Off"
    ];

    meta = {
      description = "Lightweight Peer-to-Peer Communication Library";
      license = lib.licenses.gpl3Only;
      platforms = lib.platforms.linux;
      maintainers = [ lib.maintainers.linsui ];
    };
  };

  qwindowkit-src = fetchFromGitHub {
    owner = "atraczyk";
    repo = "qwindowkit";
    rev = "c5c7da2163dfcba144e09a905ee98f920d9d94e7";
    hash = "sha256-G7vX1zPrs+rKCrXNNZ5Lt7agK3hag13c4s61h53ExPE=";
    fetchSubmodules = true;
  };

  postPatch = ''
    sed -i -e '/GIT_REPOSITORY/,+1c SOURCE_DIR ''${CMAKE_CURRENT_SOURCE_DIR}/qwindowkit' extras/build/cmake/contrib_tools.cmake
    cp -R --no-preserve=mode,ownership ${qwindowkit-src} qwindowkit
    sed -i -e '/cmake_minimum_required/i include(FindPkgConfig)' src/libclient/CMakeLists.txt
  '';

  preConfigure = ''
    echo 'const char VERSION_STRING[] = "${version}";' > src/app/version.h
  '';

  dontWrapGApps = true;

  nativeBuildInputs = [
    wrapGAppsHook3
    qt6Packages.wrapQtAppsHook
    pkg-config
    cmake
    git
    python3
    qt6Packages.qttools # for translations
    ninja
  ];

  buildInputs = [
    alsa-lib
    asio
    dbus
    dhtnet
    sdbus-cpp_2
    fmt
    ffmpeg_6
    gmp
    gnutls
    html-tidy
    hunspell
    jsoncpp
    llhttp
    libjack2
    libnotify
    libarchive
    libgit2
    libnatpmp
    libpulseaudio
    libupnp
    md4c
    msgpack-cxx
    networkmanager
    opendht-jami
    openssl
    pjsip-jami
    qrencode
    restinio
    secp256k1
    simdutf
    speex
    udev
    webrtc-audio-processing_0_3
    yaml-cpp
    zlib
    zxing-cpp
  ]
  ++ (
    with qt6Packages;
    [
      qtbase
      qt5compat
      qtnetworkauth
      qtdeclarative
      qthttpserver
      qtmultimedia
      qtpositioning
      qtsvg
      qtwebchannel
    ]
    ++ lib.optionals withWebengine [ qtwebengine ]
  );

  cmakeFlags = [
    (lib.cmakeBool "DWITH_WEBENGINE" withWebengine)
  ];

  env.NIX_LDFLAGS = "-lz -lupnp -lixml";
  qtWrapperArgs = [
    # With wayland the titlebar is not themed and the wmclass is wrong.
    "--set-default QT_QPA_PLATFORM xcb"
  ];

  preFixup = ''
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  passthru = {
    updateScript = gitUpdater { rev-prefix = "stable/"; };
    inherit pjsip dhtnet;
  };

  meta = {
    homepage = "https://jami.net/";
    description = "Free and universal communication platform that respects the privacy and freedoms of its users";
    mainProgram = "jami";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.linsui ];
  };
}
