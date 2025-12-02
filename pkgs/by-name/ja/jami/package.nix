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
  autoreconfHook,
  perl, # for pod2man
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
  version = "20251124.0";

  src = fetchFromGitLab {
    domain = "git.jami.net";
    owner = "savoirfairelinux";
    repo = "jami-client-qt";
    rev = "stable/${version}";
    hash = "sha256-IQA6V0Sl+xhuit9kySpsSAS/a0GOsiT+ysYET91/gmc=";
    fetchSubmodules = true;
  };

  patches = [
    (fetchpatch {
      url = "https://gitlab.archlinux.org/archlinux/packaging/packages/jami-qt/-/raw/0ecbaf3b101bbdd0d4a06b06f3ce1ff654abf0b5/fix-link.patch";
      hash = "sha256-VsQbOPHyNFcRhpae+9UCaUJdHH8bMGf3ZIAW3RKiu6k=";
    })
  ];

  pjsip-jami = pjsip.overrideAttrs (old: {
    version = "sfl-2.15-unstable-2025-09-18";

    src = fetchFromGitHub {
      owner = "savoirfairelinux";
      repo = "pjproject";
      rev = "93dc96918bb6ba74e1e1d00c40c80402e856f2ac";
      hash = "sha256-wsbKa3TXqj+nQMtAaEAD0Zh248QdNMhKnIOnq08MPI0=";
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
    version = "unstable-2025-11-10";

    src = fetchFromGitLab {
      domain = "git.jami.net";
      owner = "savoirfairelinux";
      repo = "dhtnet";
      rev = "03c6ce608daf906fc98b82f114b61ebfdeae5dc6";
      hash = "sha256-VTciKJ1IYtQopdV/TpnuB3T2tipcQjjKDlh2cKGDtRQ=";
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
      sdbus-cpp_2
      fmt
      ffmpeg_6
      gmp
      gnutls
      llhttp
      libjack2
      jsoncpp
      libarchive
      libgit2
      libnatpmp
      libpulseaudio
      libupnp
      msgpack-cxx
      opendht-jami
      openssl
      pjsip-jami
      restinio
      secp256k1
      speex
      udev
      webrtc-audio-processing_0_3
      yaml-cpp
      zlib
    ];

    enableParallelBuilding = true;
  };

  qwindowkit-src = fetchFromGitHub {
    owner = "stdware";
    repo = "qwindowkit";
    rev = "0131d673092ab18afd69fac84f4a17ad2ba615f2";
    hash = "sha256-jajgLOj0h/byt3+fSbCpV3VPUoHxijUsKw/0BOwbXTw=";
    fetchSubmodules = true;
  };

  postPatch = ''
    sed -i -e '/GIT_REPOSITORY/,+1c SOURCE_DIR ''${CMAKE_CURRENT_SOURCE_DIR}/qwindowkit' extras/build/cmake/contrib_tools.cmake
    cp -R --no-preserve=mode,ownership ${qwindowkit-src} qwindowkit
    substituteInPlace CMakeLists.txt \
      --replace-fail 'add_subdirectory(3rdparty/zxing-cpp EXCLUDE_FROM_ALL)' 'find_package(ZXing)'
    sed -i -e '/pkg_check_modules/i FIND_PACKAGE(PkgConfig REQUIRED)' src/libclient/CMakeLists.txt
  '';

  preConfigure = ''
    echo 'const char VERSION_STRING[] = "${version}";' > src/app/version.h
    # Currently the daemon is still built seperately but jami expects it in CMAKE_INSTALL_PREFIX
    # This can be removed in future versions when JAMICORE_AS_SUBDIR is on
    mkdir -p $out
    ln -s ${daemon} $out/daemon
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
    ffmpeg_6
    html-tidy
    hunspell
    libnotify
    md4c
    networkmanager
    qrencode
    zxing-cpp
  ]
  ++ (
    with qt6Packages;
    [
      qtbase
      qt5compat
      qtnetworkauth
      qtdeclarative
      qtmultimedia
      qtpositioning
      qtsvg
      qtwebchannel
    ]
    ++ lib.optionals withWebengine [ qtwebengine ]
  );

  cmakeFlags = [
    (lib.cmakeBool "JAMICORE_AS_SUBDIR" false)
    (lib.cmakeBool "DWITH_WEBENGINE" withWebengine)
    "-DLIBJAMI_INCLUDE_DIRS=${daemon}/include/jami"
  ];

  qtWrapperArgs = [
    # With wayland the titlebar is not themed and the wmclass is wrong.
    "--set-default QT_QPA_PLATFORM xcb"
  ];

  preFixup = ''
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  passthru = {
    updateScript = gitUpdater { rev-prefix = "stable/"; };
    inherit daemon pjsip dhtnet;
  };

  meta = with lib; {
    homepage = "https://jami.net/";
    description = "Free and universal communication platform that respects the privacy and freedoms of its users";
    mainProgram = "jami";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.linsui ];
  };
}
