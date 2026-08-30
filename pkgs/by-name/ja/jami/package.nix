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
  version = "20260811.0";

  src = fetchFromGitLab {
    domain = "git.jami.net";
    owner = "savoirfairelinux";
    repo = "jami-client-qt";
    rev = "stable/${version}";
    hash = "sha256-6MywBm2kT1VJmgHEGKifcrHxG08s53fqfPYSfsFxgFk=";
    fetchSubmodules = true;
  };

  patches = [
    (fetchpatch {
      url = "https://gitlab.archlinux.org/archlinux/packaging/packages/jami-qt/-/raw/20260717.0-2/zxing-cpp-3.patch";
      hash = "sha256-fTGrsdeC3kN277DvSuKyR5fMZhtBmk1nsL2BbeHYjTY=";
    })
    (fetchpatch {
      # Fix for Qt 6.11
      url = "https://git.jami.net/savoirfairelinux/jami-client-qt/-/commit/b97eb85af48b36008a9d619077965d6284660031.patch";
      hash = "sha256-2gY4cqWg5FY6Q6j6V/x3IMWN3AP8RThjZdxYI+ktLI4=";
      revert = true;
    })
  ];

  pjsip-jami = pjsip.overrideAttrs (old: {
    version = "sfl-2.15-unstable-2025-09-18";

    src = fetchFromGitHub {
      owner = "savoirfairelinux";
      repo = "pjproject";
      rev = "3a92a7ee340dbc1f4730fcaf32acac9a54cacf1b";
      hash = "sha256-luW1lZ+QrOXBVyaWjGCesSnI8tNDBLmAiqUtTjNmRN8=";
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
    version = "unstable-2026-08-11";

    src = fetchFromGitLab {
      domain = "git.jami.net";
      owner = "savoirfairelinux";
      repo = "dhtnet";
      rev = "11f916f2cccba068a48d2fd6ed6f02407d95b7ce";
      hash = "sha256-Ly3LvKqbvvA6FQTEwJKv1St+RvyaLIPQiY2MvPLvgaw=";
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
      "-DBUILD_SHARED_LIBS=ON"
      "-DCMAKE_CXX_STANDARD=20"
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
    substituteInPlace CMakeLists.txt \
      --replace-fail 'add_subdirectory(3rdparty/zxing-cpp EXCLUDE_FROM_ALL)' 'find_package(ZXing)'
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
    fmt
    ffmpeg_6
    gmp
    gnutls
    html-tidy
    hunspell
    jsoncpp
    llhttp
    libjack2
    libarchive
    libgit2
    libnatpmp
    libnotify
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
    sdbus-cpp_2
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

  env.NIX_LDFLAGS = "-lz";

  qtWrapperArgs = [
    # With wayland the titlebar is not themed and the wmclass is wrong.
    "--set-default QT_QPA_PLATFORM xcb"
  ];

  preFixup = ''
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  passthru = {
    updateScript = gitUpdater { rev-prefix = "stable/"; };
    inherit pjsip-jami dhtnet;
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
