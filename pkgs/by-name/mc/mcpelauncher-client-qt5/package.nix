{
  lib,
  clangStdenv,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  openssl,
  zlib,
  libpng,
  libglvnd,
  xorg,
  libevdev,
  curl,
  pulseaudio,
  qt5,
  glfw,
  withQtWebview ? false,
  withQtErrorWindow ? !stdenv.hostPlatform.isDarwin,
  fetchzip,
  zenity,
  xdg-utils,
  sdl3,
  apple-sdk,
}:

clangStdenv.mkDerivation (finalAttrs: {
  pname = "mcpelauncher-client-qt5";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "minecraft-linux";
    repo = "mcpelauncher-manifest";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-w/FmpQp/IA+FjR1sGmgjMxTPhTgVicEpnmLhLGuwniI=";
  };

  patches = [ ./dont_download_glfw_client.patch ];

  postPatch = lib.optionalString stdenv.hostPlatform.isLinux ''
    substituteInPlace mcpelauncher-client/src/jni/main_activity.cpp \
      --replace-fail /usr/bin/xdg-open ${xdg-utils}/bin/xdg-open \
      --replace-fail /usr/bin/zenity ${lib.getExe zenity}

    substituteInPlace file-picker/src/file_picker_zenity.cpp \
      --replace-fail 'EXECUTABLE_NAME = "zenity"' 'EXECUTABLE_NAME = "${lib.getExe zenity}"'
  '';

  hardeningDisable = [ "fortify" ];

  nativeBuildInputs =
    [
      cmake
      pkg-config
    ]
    ++ lib.optionals (withQtWebview || withQtErrorWindow) [
      qt5.wrapQtAppsHook
    ];

  buildInputs =
    [
      openssl
      zlib
      libpng
      curl
      glfw
      sdl3
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      libglvnd
      xorg.libX11
      xorg.libXi
      xorg.libXtst
      libevdev
      pulseaudio
    ]
    ++ lib.optionals (withQtWebview || withQtErrorWindow) [
      qt5.qtbase
      qt5.qttools
    ]
    ++ lib.optionals ((withQtWebview || withQtErrorWindow) && stdenv.hostPlatform.isLinux) [
      qt5.qtwayland
    ]
    ++ lib.optionals (withQtWebview && stdenv.hostPlatform.isLinux) [
      qt5.qtwebengine
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      apple-sdk
    ];

  cmakeFlags =
    [
      (lib.cmakeBool "FETCHCONTENT_FULLY_DISCONNECTED" true)
      (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_NLOHMANN_JSON_EXT" (
        toString (fetchzip {
          url = "https://github.com/nlohmann/json/releases/download/v3.7.3/include.zip";
          hash = "sha256-h8czZ4f5vZqvHkDVQawrQdUeQnWxewu4OONisqlrmmM=";
          stripRoot = false;
        })
      ))
      (lib.cmakeBool "USE_OWN_CURL" false)
      (lib.cmakeBool "ENABLE_DEV_PATHS" false)
      (lib.cmakeFeature "GAMEWINDOW_SYSTEM" "GLFW")
      (lib.cmakeBool "USE_SDL3_AUDIO" false)
      (lib.cmakeBool "BUILD_WEBVIEW" withQtWebview)
      (lib.cmakeBool "XAL_WEBVIEW_USE_CLI" (!withQtWebview))
      (lib.cmakeBool "XAL_WEBVIEW_USE_QT" withQtWebview)
      (lib.cmakeBool "ENABLE_QT_ERROR_UI" withQtErrorWindow)
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      (lib.cmakeFeature "OPENSSL_ROOT_DIR" "${openssl}")
      (lib.cmakeFeature "CMAKE_PREFIX_PATH" "${qt5.qtbase}")
    ];

  env = lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    NIX_LDFLAGS = "-framework AppKit -framework Foundation";
  };

  preBuild = lib.optionalString stdenv.hostPlatform.isDarwin ''
    export LDFLAGS="$LDFLAGS -framework AppKit -framework Foundation"
  '';

  meta = {
    description = "Unofficial Minecraft Bedrock Edition launcher with CLI (Qt5)";
    homepage = "https://minecraft-linux.github.io";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      aleksana
      morxemplum
      phanirithvij
      erkin
    ];
    mainProgram = "mcpelauncher-client";
    platforms = lib.platforms.unix;
  };
})
