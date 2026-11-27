{
  lib,
  stdenv,
  fetchFromGitHub,
  boost,
  cmake,
  chromaprint,
  gettext,
  glib,
  gst_all_1,
  libxml2,
  qt6,
  taglib,
  fftw,
  libGLU,
  sqlite,
  zlib,
  libgpod,
  libplist,
  usbmuxd,
  libmtp,
  libpulseaudio,
  libcdio,
  protobuf,
  pkg-config,
  sparsehash,
  config,
  alsa-lib,

  withIpod ? config.clementine.ipod or false,
  withMTP ? config.clementine.mtp or true,
  withCD ? config.clementine.cd or true,
  withCloud ? config.clementine.cloud or true,
}:
let
  gst_plugins = with gst_all_1; [
    gst-plugins-base
    gst-plugins-good
    gst-plugins-ugly
    gst-libav
  ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "clementine";
  version = "1.4.7";

  src = fetchFromGitHub {
    owner = "clementine-player";
    repo = "Clementine";
    tag = finalAttrs.version;
    hash = "sha256-TanOSCpc18MY8zNuj2XFv+r8X+DOKjExqgeZZA0la8I=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    cmake
    gettext
    pkg-config
    protobuf
    qt6.qttools
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    alsa-lib
    boost
    chromaprint
    fftw
    gettext
    glib
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-bad
    gst_all_1.gstreamer
    libGLU
    libpulseaudio
    libxml2
    protobuf
    qt6.qtbase
    qt6.qt5compat
    qt6.qtsvg
    qt6.qtwayland
    sqlite
    taglib
    zlib
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
    substituteInPlace CMakeLists.txt \
      --replace-fail 'libprotobuf.a' 'protobuf'
  '';

  cmakeFlags = [
    # Required to match Version.cmake regex: ^(.+)-([0-9]+)-(g[a-f0-9]+)$
    (lib.cmakeFeature "FORCE_GIT_REVISION" "${finalAttrs.version}-0-g0000000")
    (lib.cmakeBool "BUILD_WERROR" false)
    # TODO: use pkgs.libprojectm once projectM 4.2 is released.
    # Requires projectm_opengl_render_frame_fbo (https://github.com/projectM-visualizer/projectm/pull/815)
    (lib.cmakeBool "USE_SYSTEM_PROJECTM" false)
  ];

  preFixup = ''
    qtWrapperArgs+=(
      --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0"
    )
  '';

  meta = {
    changelog = "https://github.com/clementine-player/Clementine/releases/tag/${finalAttrs.src.tag}";
    downloadPage = "https://github.com/clementine-player/Clementine";
    description = "Multiplatform music player";
    homepage = "https://www.clementine-player.org";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "clementine";
    maintainers = with lib.maintainers; [ phanirithvij ];
  };
})
