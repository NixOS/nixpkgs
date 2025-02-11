{
  lib,
  stdenv,
  fetchFromGitHub,
  boost,
  cmake,
  chromaprint,
  gettext,
  gst_all_1,
  liblastfm,
  qtbase,
  qtx11extras,
  qttools,
  taglib,
  fftw,
  glew,
  qjson,
  sqlite,
  libgpod,
  libplist,
  usbmuxd,
  libmtp,
  libpulseaudio,
  gvfs,
  libcdio,
  pcre,
  projectm,
  protobuf,
  qca-qt5,
  pkg-config,
  sparsehash,
  config,
  wrapQtAppsHook,
  gst_plugins,
  util-linux,
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
in
stdenv.mkDerivation (finalAttrs: {
  pname = "clementine";
  version = "1.4.1-31-g69ba3e85f";

  src = fetchFromGitHub {
    owner = "clementine-player";
    repo = "Clementine";
    tag = finalAttrs.version;
    hash = "sha256-r6x3/Kr8XdFP4sXERjWWMEAxY4M/vIS0QQfneTUWGuc=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapQtAppsHook
    util-linux
    libunwind
    libselinux
    elfutils
    libsepol
    orc
  ];

  buildInputs =
    [
      boost
      chromaprint
      fftw
      gettext
      glew
      gst_all_1.gst-plugins-base
      gst_all_1.gst-plugins-bad
      gst_all_1.gstreamer
      gvfs
      liblastfm
      libpulseaudio
      pcre
      projectm
      protobuf
      qca-qt5
      qjson
      qtbase
      qtx11extras
      qttools
      sqlite
      taglib
      alsa-lib
    ]
    # gst_plugins needed for setup-hooks
    ++ gst_plugins
    ++ lib.optionals (withIpod) [
      libgpod
      libplist
      usbmuxd
    ]
    ++ lib.optionals (withMTP) [ libmtp ]
    ++ lib.optionals (withCD) [ libcdio ]
    ++ lib.optionals (withCloud) [ sparsehash ];

  postPatch = ''
    sed -i src/CMakeLists.txt \
      -e 's,-Werror,,g' \
      -e 's,-Wno-unknown-warning-option,,g' \
      -e 's,-Wno-unused-private-field,,g'
    sed -i CMakeLists.txt \
      -e 's,libprotobuf.a,protobuf,g'
  '';

  preConfigure = ''
    rm -rf ext/{,lib}clementine-spotifyblob
  '';

  cmakeFlags = [
    "-DFORCE_GIT_REVISION=1.3.1"
    "-DUSE_SYSTEM_PROJECTM=ON"
    "-DSPOTIFY_BLOB=OFF"
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
    maintainers = with lib.maintainers; [ ttuegel ];
  };
})
