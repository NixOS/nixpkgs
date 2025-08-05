{
  lib,
  stdenv,
  fetchgit,
  cmake,
  ninja,
  pandoc,
  pkg-config,
  kdePackages,
  pipewire,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bino3d";
  version = "2.5";

  src = fetchgit {
    url = "https://git.marlam.de/git/bino.git";
    rev = "bino-${finalAttrs.version}";
    hash = "sha256-vGPbSYTfRy414xVcLIvOnN4Te36HWVz7DQegNhYb3u4=";
  };

  postPatch =
    # after including QMediaPlayer, also include the Qt JSON headers
    # so we can use QJsonDocument, QJsonObject, etc
    ''
      sed -i '/#include <QMediaPlayer>/a \
      #include <QJsonDocument>\
      #include <QJsonObject>\
      #include <QJsonArray>\
      #include <QJsonValue>' src/metadata.cpp
    ''
    # on macOS the OpenGL headers lack GL_MAX_FRAMEBUFFER_WIDTH
    # and GL_MAX_FRAMEBUFFER_HEIGHT, so define them here with
    # their standard enum values
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      sed -i '1i\
      #ifndef GL_MAX_FRAMEBUFFER_WIDTH\n\
      #define GL_MAX_FRAMEBUFFER_WIDTH 0x9315\n\
      #define GL_MAX_FRAMEBUFFER_HEIGHT 0x9316\n\
      #endif\n' src/widget.cpp
    '';

  nativeBuildInputs = [
    cmake
    kdePackages.wrapQtAppsHook
    ninja
    pkg-config
    pandoc
  ];

  buildInputs = [
    kdePackages.qtbase
    kdePackages.qtmultimedia
    kdePackages.qttools
    # The optional QVR dependency is not currently packaged.
  ];

  qtWrapperArgs = lib.optionals stdenv.hostPlatform.isLinux [
    # qt.multimedia.symbolsresolver: Couldn't load pipewire-0.3 library
    "--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ pipewire ]}"
    # Force Qt to use the X11 (xcb) platform plugin instead of Wayland or EGL
    "--set QT_QPA_PLATFORM xcb"
  ];

  meta = {
    description = "Video player with a focus on 3D and Virtual Reality";
    homepage = "https://bino3d.org/";
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.orivej ];
    platforms = lib.platforms.unix;
    mainProgram = "bino";
  };
})
