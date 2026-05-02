{
  lib,
  stdenv,
  fetchFromGitHub,
  boost,
  cmake,
  chromaprint,
  gettext,
  gst_all_1,
  libsForQt5,
  taglib_1,
  fftw,
  glew,
  sqlite,
  libgpod,
  libplist,
  usbmuxd,
  libmtp,
  libpulseaudio,
  gvfs,
  libcdio,
  pcre,
  projectm_3,
  protobuf,
  pkg-config,
  sparsehash,
  config,
  util-linuxMinimal,
  libunwind,
  libselinux,
  elfutils,
  libsepol,
  orc,
  alsa-lib,
}:

let
  withIpod = config.clementine.ipod or false;
  withMTP = config.clementine.mtp or true;
  withCD = config.clementine.cd or true;
  withCloud = config.clementine.cloud or true;

  gst_plugins = with gst_all_1; [
    gst-plugins-base
    gst-plugins-good
    gst-plugins-ugly
    gst-libav
  ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "clementine";
  version = "1.4.1-60-g1a3e8b56f";

  src = fetchFromGitHub {
    owner = "clementine-player";
    repo = "Clementine";
    tag = finalAttrs.version;
    hash = "sha256-FRgTi1Qxzp0vJASNpyANqh4rJX4caxEr0CZOnTHA3Kw=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    libsForQt5.wrapQtAppsHook
    util-linuxMinimal
    libunwind
    libselinux
    elfutils
    libsepol
    orc
  ];

  buildInputs = [
    boost
    chromaprint
    fftw
    gettext
    glew
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-bad
    gst_all_1.gstreamer
    gvfs
    libsForQt5.liblastfm
    libpulseaudio
    pcre
    projectm_3
    protobuf
    libsForQt5.qca-qt5
    libsForQt5.qjson
    libsForQt5.qtbase
    libsForQt5.qtx11extras
    libsForQt5.qttools
    sqlite
    taglib_1
    alsa-lib
  ]
  # gst_plugins needed for setup-hooks
  ++ gst_plugins
  ++ lib.optionals withIpod [
    libgpod
    libplist
    usbmuxd
  ]
  ++ lib.optionals withMTP [ libmtp ]
  ++ lib.optionals withCD [ libcdio ]
  ++ lib.optionals withCloud [ sparsehash ];

  postPatch = ''
    sed -i src/CMakeLists.txt \
      -e 's,-Werror,,g' \
      -e 's,-Wno-unknown-warning-option,,g' \
      -e 's,-Wno-unused-private-field,,g'
    sed -i CMakeLists.txt \
      -e 's,libprotobuf.a,protobuf,g'

    # CMake 3.0.0 is deprecated and no longer supported by CMake > 4
    # https://github.com/NixOS/nixpkgs/issues/445447
    substituteInPlace 3rdparty/{qsqlite,qtsingleapplication,qtiocompressor,qxt}/CMakeLists.txt \
      cmake/{ParseArguments.cmake,Translations.cmake}                                          \
      tests/CMakeLists.txt gst/moodbar/CMakeLists.txt                                          \
      --replace-fail                                                                           \
        "cmake_minimum_required(VERSION 3.0.0)" \
        "cmake_minimum_required(VERSION 3.10)"
    substituteInPlace 3rdparty/libmygpo-qt5/CMakeLists.txt --replace-fail \
      "cmake_minimum_required( VERSION 3.0.0 FATAL_ERROR )" \
      "cmake_minimum_required(VERSION 3.10)"
    substituteInPlace CMakeLists.txt --replace-fail \
        "cmake_policy(SET CMP0053 OLD)" \
        ""
  '';

  preConfigure = ''
    rm -rf ext/{,lib}clementine-spotifyblob
  '';

  cmakeFlags = [
    (lib.cmakeFeature "FORCE_GIT_REVISION" "1.3.1")
    (lib.cmakeBool "USE_SYSTEM_PROJECTM" true)
    (lib.cmakeBool "SPOTIFY_BLOB" false)
  ];

  dontWrapQtApps = true;

  postInstall = ''
    wrapQtApp $out/bin/clementine \
      --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0"
  '';

  meta = {
    homepage = "https://www.clementine-player.org";
    description = "Multiplatform music player";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "clementine";
    maintainers = with lib.maintainers; [ ttuegel ];
  };
})
