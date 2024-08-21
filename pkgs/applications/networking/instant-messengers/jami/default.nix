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
  yaml-cpp,
  msgpack-cxx,
  openssl,
  restinio,
  secp256k1,
  speex,
  udev,
  webrtc-audio-processing,
  zlib,

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
  version = "20240627.0";

  src = fetchFromGitLab {
    domain = "git.jami.net";
    owner = "savoirfairelinux";
    repo = "jami-client-qt";
    rev = "stable/${version}";
    hash = "sha256-aePF1c99ju9y7JEgC+F2BPfpSAZlLd5OI5Jm6i9VlQQ=";
    fetchSubmodules = true;
  };

  pjsip-jami = pjsip.overrideAttrs (old: rec {
    version = "8fc165b833eea6e3c88d67a541385424b129fd3f";

    src = fetchFromGitHub {
      owner = "savoirfairelinux";
      repo = "pjproject";
      rev = version;
      hash = "sha256-uA6ZJYUgAu3cK4CKCGtqaI0KPM/0szExPS2pCOflz5A=";
    };

    configureFlags = [
      "--disable-sound"
      "--enable-video"
      "--enable-ext-sound"
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
    ] ++ lib.optionals stdenv.isLinux [ "--enable-epoll" ];

    buildInputs = old.buildInputs ++ [ gnutls ];
  });

  opendht-jami =
    (opendht.overrideAttrs {
      src = fetchFromGitHub {
        owner = "savoirfairelinux";
        repo = "opendht";
        rev = "074e05cc3254d5d73b0d96ee772a6e01bb3113e5";
        hash = "sha256-WuaURlC7eDDxvnM3YuyU9CNrwnE4WBQUIEw3z/0zjN8=";
      };
    }).override
      {
        enableProxyServerAndClient = true;
        enablePushNotifications = true;
      };

  dhtnet = stdenv.mkDerivation {
    pname = "dhtnet";
    version = "unstable-2024-05-17";

    src = fetchFromGitLab {
      domain = "git.jami.net";
      owner = "savoirfairelinux";
      repo = "dhtnet";
      rev = "77331098ff663a5ac54fae7d0bedafe076c575a1";
      hash = "sha256-55LEnI1YgVujCtv1dGOFtJdvnzB2SKqwEptaHasZB7I=";
    };

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
      llhttp
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

  qwindowkit = fetchFromGitHub {
    owner = "stdware";
    repo = "qwindowkit";
    rev = "79b1f3110754f9c21af2d7dacbd07b1a9dbaf6ef";
    hash = "sha256-iZfmv3ADVjHf47HPK/FdrfeAzrXbxbjH3H5MFVg/ZWE=";
    fetchSubmodules = true;
  };

  postPatch = ''
    sed -i -e '/GIT_REPOSITORY/,+1c SOURCE_DIR ''${CMAKE_CURRENT_SOURCE_DIR}/qwindowkit' extras/build/cmake/contrib_tools.cmake
    sed -i -e 's/if(DISTRO_NEEDS_QMSETUP_PATCH)/if(TRUE)/' CMakeLists.txt
    cp -R --no-preserve=mode,ownership ${qwindowkit} qwindowkit
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
