{
  stdenv,
  lib,
  pkg-config,
  fetchFromGitLab,
  gitUpdater,
  ffmpeg_6,

  # for daemon
  autoreconfHook,
  perl, # for pod2man
  alsa-lib,
  asio,
  dbus,
  sdbus-cpp,
  fmt,
  gmp,
  gnutls,
  llhttp,
  jack,
  jsoncpp,
  libarchive,
  libgit2,
  libnatpmp,
  libpulseaudio,
  libupnp,
  msgpack-cxx,
  openssl,
  restinio,
  secp256k1,
  speex,
  udev,
  webrtc-audio-processing,
  yaml-cpp,
  zlib,

  # for dhtnet
  expected-lite,

  # for client
  cmake,
  git,
  networkmanager, # for libnm
  python3,
  qttools, # for translations
  wrapQtAppsHook,
  libnotify,
  qt5compat,
  qtbase,
  qtdeclarative,
  qrencode,
  qtmultimedia,
  qtnetworkauth,
  qtpositioning,
  qtsvg,
  qtwebengine,
  qtwebchannel,
  wrapGAppsHook3,
  withWebengine ? true,

  # for pjsip
  fetchFromGitHub,
  pjsip,

  # for opendht
  opendht,
}:

stdenv.mkDerivation rec {
  pname = "jami";
  version = "20250613.0";

  src = fetchFromGitLab {
    domain = "git.jami.net";
    owner = "savoirfairelinux";
    repo = "jami-client-qt";
    rev = "stable/${version}";
    hash = "sha256-+6DTbYq50UPSQ+KipXhWje1bZs64wZrS37z2Na1RtN8=";
    fetchSubmodules = true;
  };

  pjsip-jami = pjsip.overrideAttrs (old: {
    version = "sfl-2.15-unstable-2025-02-24";

    src = fetchFromGitHub {
      owner = "savoirfairelinux";
      repo = "pjproject";
      rev = "37130c943d59f25a71935803ea2d84515074a237";
      hash = "sha256-7gAiriuooqqF38oajAuD/Lj5trn/9VMkCGOumcV45NA=";
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
    ] ++ lib.optionals stdenv.hostPlatform.isLinux [ "--enable-epoll" ];

    buildInputs = old.buildInputs ++ [ gnutls ];
  });

  opendht-jami = opendht.override {
    enableProxyServerAndClient = true;
    enablePushNotifications = true;
  };

  dhtnet = stdenv.mkDerivation {
    pname = "dhtnet";
    version = "unstable-2025-05-26";

    src = fetchFromGitLab {
      domain = "git.jami.net";
      owner = "savoirfairelinux";
      repo = "dhtnet";
      rev = "6c5ee3a21556d668d047cdedb5c4b746c3c6bdb2";
      hash = "sha256-uweYSEysVMUC7DhI9BhS1TDZ6ZY7WQ9JS3ZF9lKA4Fo=";
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

    # Fix for libgit2 breaking changes
    postPatch = ''
      substituteInPlace src/jamidht/conversationrepository.cpp \
        --replace-fail "git_commit* const" "const git_commit*"
    '';

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
      llhttp
      jack
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
      webrtc-audio-processing
      yaml-cpp
      zlib
    ];

    enableParallelBuilding = true;
  };

  qwindowkit-src = fetchFromGitHub {
    owner = "stdware";
    repo = "qwindowkit";
    rev = "758b00cb6c2d924be3a1ea137ec366dc33a5132d";
    hash = "sha256-qpVsF4gUX2noG9nKgjNP7FCEe59okZtDA8R/aZOef7Q=";
    fetchSubmodules = true;
  };

  postPatch = ''
    sed -i -e '/GIT_REPOSITORY/,+1c SOURCE_DIR ''${CMAKE_CURRENT_SOURCE_DIR}/qwindowkit' extras/build/cmake/contrib_tools.cmake
    sed -i -e 's/if(DISTRO_NEEDS_QMSETUP_PATCH)/if(TRUE)/' CMakeLists.txt
    cp -R --no-preserve=mode,ownership ${qwindowkit-src} qwindowkit
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
    wrapQtAppsHook
    pkg-config
    cmake
    git
    python3
    qttools
  ];

  buildInputs = [
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
  ] ++ lib.optionals withWebengine [ qtwebengine ];

  cmakeFlags = lib.optionals (!withWebengine) [ "-DWITH_WEBENGINE=false" ];

  qtWrapperArgs = [
    # With wayland the titlebar is not themed and the wmclass is wrong.
    "--set-default QT_QPA_PLATFORM xcb"
  ];

  preFixup = ''
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  passthru.updateScript = gitUpdater { rev-prefix = "stable/"; };

  meta = with lib; {
    homepage = "https://jami.net/";
    description = "Free and universal communication platform that respects the privacy and freedoms of its users";
    mainProgram = "jami";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.linsui ];
  };
}
